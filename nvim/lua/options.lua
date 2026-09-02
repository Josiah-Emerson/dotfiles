-- set leader? 
-- already set in lazy?
-- plus isn't this the default anyway?
vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.clipboard = "unnamedplus" -- sync system clipboard with neovim
vim.opt.scrolloff = 999 -- something about keeping cursor in middle of screen when scrolling? was in my old config so oh well

-- setup indentation
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.tabstop = 3
vim.o.shiftwidth = 3
