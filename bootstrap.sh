#!/bin/bash
#TODO: change base path for files

DOTFILES_ROOT=$(pwd -P)

# exit on failure
set -e

# prints a request to a user
request () {
   printf "[??] $1\n"
}

fail () {
   printf "[FAIL] $1\n"
   exit
}

link_file () {
   local src=$1
   local dst=$2

   # if this file already exists in .config
   if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]; then
      # check if the file is our symlink
      local currSrc="$(readlink $dst)"

      if [ "$currSrc" == "$src" ]; then
         break
      fi

      request "File already exists: $dst ($(basename "$src")).\n\
      Would you like to [s]kip or [o]verwrite it?"
      read -n 1
   fi
}

if [ "$(uname -s)" != "Linux" ]
then
   fail 'Unsupported OS'
fi

for src in $(find "$DOTFILES_ROOT" -mindepth 2 -not -path '*.git*' -not -path '*test*')
do
   # home/josi/projects/dotfiles/nvim/lua/file.lua
   # nvim/lua/file.lua
   # home/josi/projects/dotfiles/test/ 
   base_path="${DOTFILES_ROOT}/test"
   dst="${base_path}${src#$DOTFILES_ROOT}"
   link_file "$src" "$dst"
done
