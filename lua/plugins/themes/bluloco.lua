return {
  "uloco/bluloco.nvim",
  lazy = true,
  priority = 1000,
  dependencies = { 'rktjmp/lush.nvim' },
  config = function()
    require("bluloco").setup({
      style       = "dark",
      transparent = false,
      terminal    = vim.fn.has("gui_running") == 1, -- bluoco colors are enabled in gui terminals per default.
      guicursor   = true,
    })
  end,
}
