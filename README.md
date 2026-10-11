My dotfiles I guess

Usage: 
git clone git@github.com:Josiah-Emerson/dotfiles.git ~/.dotfiles 
cd ~/.dotfiles
./bootstrap.sh

CURRENT: Need to finish bootstrap script. Just added prompt if the file exists, so need to 
figure out a way to overwrite it. But as I am writing this, I think I need a way to do the following:
if we are in the directory nvim, and a config is found in .config, then we need to notify the user for sure 
and decide what to do from there

bootstrap script essentially just creates a symlink 
in the proper config directory to each file in the folder (excluding .git)
Ex: nvim/ contains configuration and setup for neovim, and bootstrap
will create a symlink to every file within that directory

TODO: Write a script that can properly bootstrap it
TOD): rn script only adds nvim (or at least will) so when i finish or add other configs
need to update that.
TODO: Add extensibility for things like other OSs
TODO: this puts in ~/.config instead of directly in ~/, which means it follows XDG format 
as opposed to other traditional unix style, not sure if this matters
TODO: Handling for input and such 
TODO: Extend so that we can add or ignore based on a program's config.
For example if the script finds that a file exists for nvim/
it will ask for every file. Maybe add an option that allows the user to say
override all nvim, or do not override all nvim
TODO: Honestly it could just use a whole revamp

dotfile specific TODOs

[nvim] 
    - TODO: unsure_installed for mason lsp
    - TODO: A lot of areas have the same list of LSPs, for example in ensure installed
        and my autocomplete should have the same list and thus figure out a way to do this 
        automatically instead of copying each lsp in each spot
    - TODO: why is my setup lspconfig different than the autcomplete's readme? does it matter?
    - TODO: update autcomplete (or lsp, whichever is correct) to have clangd's compile commands for cmake
    - TODO: remove the notificaiton about things being updated when nvim is opened
    - TODO: figure out the lua language server issue 
        - Steps to reproduce: open .lua file and run :checkhealth vim.lsp
    - TODO: Add glsl as a filetype. NOTE: in my old config this was put in options.lua. I think the better way might be 
        to somehow change something in my lsp config? Not exactly sure yet
    - TODO: Function folding?
    - TODO: Can update autocomplete to get lots of sources!
    - TODO: customize things like window for autocomplete (see github for that plugin)
