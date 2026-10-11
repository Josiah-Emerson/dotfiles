#!/bin/bash
#TODO: change base path for files

DOTFILES_ROOT=$(pwd -P)
# exit on failure
set -e 

fail () {
   printf "[FAIL] $1\n"
   exit
}

msg () {
   printf "[###] $1\n"
}

request () {
   printf "[???] $1\n"
}

link_file () {
   local src_file=$1
   local dst_file=$2

   ln -sr "$src_file" "$dst_file"
}

# creates the needed directories prior to linking. 
# EX: we have folder ~/.config/foo and we want to link to 
# our dotfiles/foo/bar/baz/file.txt config file 
# pass rel_src_file as bar/baz/file.txt
# and dst_dir as ~/.config/foo 
# and this function will create the directories such that:
# ~/.config/foo/bar/baz exists
create_necessary_directories(){
   local rel_src_file=$1
   local dst_dir=$2

   local relative_dir=$(dirname "$rel_src_file")
   local target_dir="${dst_dir}/${relative_dir}"

   mkdir -p "$target_dir"
}

# creates symlinks in dst_dir for every file in src_dir 
# if there are subdirectories it creates a directory until subtree of src_dir is linked to by dst_dir
# dst_dir should be empty to avoid path collisisons
link_directory () {
   local src_dir=$1
   local dst_dir=$2

   for CURR_SRC in $(find "$src_dir" -mindepth 1)
   do 
      CURR_DST="$dst_dir${CURR_SRC#$src_dir}"
      if [ -d $CURR_SRC ]
      then 
         mkdir $CURR_DST
      else 
         link_file "$CURR_SRC" "$CURR_DST"
      fi
   done
}

# calculates the state of an existing directory
# The first argument passed is the src_dir and second is dst_dir
# STATE is 0 if the directory is empty
# STATE is 1 if no files conflict
# STATE is 2 if some conflict
# All additional non-conflicting filepaths will be accessible
# All conflicting filepaths will be accessible
# All unlinked files (file in src which is not linked in dst) will be accessible
#
# The variable NON_CONFLICTING will be populated with the file paths of all files 
# which exist in dst_dir and are not a file in src_dir
# The variable UNLINKED will contain any files which exist in the src_dir but are not 
# linked and in the dst_dir (if any)
# The variable CONFLICTING will contain a list of all files which existed in the src_dir and 
# the dst_dir and were not sym links
directory_state () {
   local src_dir=$1
   local dst_dir=$2

   local LINKED=()
   UNLINKED=()
   CONFLICTING=()
   NON_CONFLICTING=()
   STATE=0

   if [ -z "$(find "$dst_dir" -mindepth 1 -print -quit)" ]
   then
      STATE=0
   else 
      for dst_file in $(find "$dst_dir" -mindepth 1 -type f,l)
      do 
         local rel_path="${dst_file#"$dst_dir"/}"
         local src_path="$src_dir/$rel_path"

         if [ ! -f "$src_path" ]
         then # no file in src
            NON_CONFLICTING+=("$dst_file")
         elif [ ! -L "$dst_file" ]
         then
            CONFLICTING+=("$dst_file")
         else # file is in source
            local link_src="$(realpath $dst_file)"
            if [ "$link_src" == "$DOTFILES_ROOT/${src_path##./}" ]
            then 
               LINKED+=("$src_path")
            else 
               echo "link: $link_src, src: $s"
               CONFLICTING+=("$dst_file")
            fi
         fi
      done

      # then go through src_dir, and for every file not encountered in dst_dir, 
      # add to UNLINKED
      for src_file in $(find "$src_dir" -mindepth 1 -type f)
      do 
         local found=0
         for linked_file in "${LINKED[@]}"
         do
            if [[ "$linked_file" == "$src_file" ]]
            then 
               found=1
               break
            fi
         done

         if [[ ! $found -eq 1 ]]
         then 
            UNLINKED+=("$src_file")
         fi
      done
   fi

   if [ ${#CONFLICTING[@]} -eq 0 ]
   then 
      STATE=1
   else 
      STATE=2
   fi
}

link_unlinked () {
   local src_dir=$1
   local dst_dir=$2

   for unlinked in "${UNLINKED[@]}"
   do
      unlinked=${unlinked#./} # remove optional ./ at beginning
      unlinked=${unlinked#*/} # remove up to first directory
      unlinked=${unlinked%/}  # remove trailing slash
      create_necessary_directories "$unlinked" "$dst_dir"
      link_file "$src_dir/$unlinked" "$dst_dir/$unlinked"
   done
}

non_conflicting () {
   REPLY=""
   while [[ $REPLY != 'w' && $REPLY != 'W' && $REPLY != 'k' && $REPLY != 'K' ]]
   do 
      msg "These files may or may not interfere with the added config files"
      request "Would you like to (w)ipe them or (k)eep them?"
      read -e -n 1
   done

   if [[ $REPLY == 'w' || $REPLY == 'W' ]]
   then 
      msg "Wiping files"
      for no_confl in "${NON_CONFLICTING[@]}"
      do 
         rm "$no_confl"
      done
   else 
      msg "Keeping files"
   fi
}

copy_config () {
   local src_dir=$1
   local dst_dir=$2

   local curr_config="$src_dir"
   curr_config=${curr_config#./}
   curr_config=${curr_config%%/*}

   msg "Setting up configs for $curr_config"

   if [ ! -d $dst_dir ] # No config exists for this
   then 
      mkdir $dst_dir
      link_directory "$src_dir" "$dst_dir"
   else # config folder already exists
      directory_state "$src_dir" "$dst_dir"
      if [ $STATE = 0 ]
      then # empty
         link_directory "$src_dir" "$dst_dir"
      elif [ $STATE = 1 ] # no conflicting
      then
         # if none are conflicting, go through and add sym links then notify user
         if [ ! ${#UNLINKED[@]} -eq 0 ]
         then 
            link_unlinked "$src_dir" "$dst_dir"
         fi

         if [ ! ${#NON_CONFLICTING[@]} -eq 0 ]
         then 
            msg "All config files for $curr_config were successfully added however some extra files existed in the config"
            msg "These files are: "
            for no_confl in "${NON_CONFLICTING[@]}"
            do 
               echo "$no_confl"
            done
            non_conflicting
         fi

      elif [ $STATE = 2 ] # some conflicting
      then
         msg "Some files already existed for the configuration of $curr_config"
         msg "These files are: "
         for confl in "${CONFLICTING[@]}"
         do 
            echo "$confl"
         done

         REPLY=""
         while [[ $REPLY != 's' && $REPLY != 'S' && $REPLY != 'o' && $REPLY != 'O' ]]
         do 
            request "You can either (s)kip the setup for this folder, or (o)verwrite the conflicting files"
            read -e -n 1
         done

         if [[ $REPLY == 's' || $REPLY == 'S' ]]
         then 
            msg "Skipping configuration for $curr_config"
         else 
            for confl in "${CONFLICTING[@]}"
            do 
               rm "$confl"
            done

            link_unlinked "$src_dir"  "$dst_dir"

            if [ ! ${#NON_CONFLICTING[@]} -eq 0 ]
            then 
               msg "All config files for $curr_config were successfully added however some extra files existed in the config"
               msg "These files are: "
               for no_confl in "${NON_CONFLICTING[@]}"
               do 
                  echo "$no_confl"
               done
               non_conflicting
            fi
         fi
      else 
         fail "ERROR: Unhandled STATE in copy_config"
      fi
   fi

}

if [ "$(uname -s)" != "Linux" ]
then 
   fail "Unsupported OS Detected"
fi

CONFIG_ROOT=${XDG_CONFIG_HOME:-$HOME/.config}

# Our deduced CONFIG_ROOT does not exist
while [ ! -d $CONFIG_ROOT ]
do 
   msg "Could not deduce config directory."
   msg "$CONFIG_ROOT is not an existing directory."
   REPLY=""
   while [[ $REPLY != 'y' && $REPLY != 'Y' && $REPLY != 'n' && $REPLY != 'N' ]]
   do
      request "Would you like to create a folder here for your configs? (Y/n)"
      read -e -n 1
      echo ""
   done

   if [[ $REPLY == 'y' || $REPLY == 'Y' ]]
   then 
      mkdir $CONFIG_ROOT
   else 
      request "Please enter new filepath: "
      read -e CONFIG_ROOT
      echo ""
      CONFIG_ROOT="${CONFIG_ROOT/#~/${HOME}}"
      continue
   fi
done

msg "Copying configs to $CONFIG_ROOT"

# TODO Eventually remove test once we remove that folder
for CURR_DIR in $(find -maxdepth 1 -type d -not -path '*.git' -not -path '*test*' -not -path '.')
do 
   dir_name="${CURR_DIR%/}"   # strip trailing slash
   dir_name="${dir_name##*/}" # delete everything up to final slash

   base_path="${CONFIG_ROOT}/${dir_name}"
   copy_config "$CURR_DIR" "$base_path" 
done
