return {
   'dchinmay2/alabaster.nvim',
   config = function()
      vim.g.alabaster_dim_comments = true
      vim.opt.termguicolors = true
      vim.cmd.colorscheme("alabaster")
   end
}
