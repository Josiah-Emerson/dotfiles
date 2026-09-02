return {
	{
		"mason-org/mason.nvim",
		opts = {}
	},
	{
		"neovim/nvim-lspconfig",
		vim.lsp.enable('clangd'),
		vim.lsp.enable('lua-language-server'),
	}
}
