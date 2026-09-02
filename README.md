My dotfiles I guess

TODO: Write a script that can properly bootstrap it

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
