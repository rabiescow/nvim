return {
  "katawful/kat.nvim",
  lazy = true,
  priority = 1000,
  config = function()
    vim.opt.termguicolors = true
    vim.cmd.colorscheme("kat.nvim")
  end
}
