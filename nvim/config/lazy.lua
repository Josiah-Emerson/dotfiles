-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data").."/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then 
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{"Failed to clone lazy.nvim:\n", "ErrorMsg"},
			{out, "WarningMsg"},
			{"\nPress any key to exit..."},
		},
		true,
		{})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup the following map leader and localleader before loading lazy
-- This ensures that mappings are correct
-- TODO: Can probably pull htis out into some other file and call it
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import plugins 
		{import  = "plugins"},
	},
	-- Configure any other settings here. See documentation for more details
	-- colorscheme is the one that will be used when installing plugins
	install = {colorscheme = {"habamax"}},

	-- automatically check for plugin updates
	checker = {enabled = true},
})
