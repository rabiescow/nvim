return {
  "katawful/kat.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.opt.termguicolors = true
    vim.cmd.colorscheme("kat.nvim")
  end
}
