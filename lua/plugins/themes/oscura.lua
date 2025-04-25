return {
  {
    "webhooked/oscura.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd.colorscheme "oscura" -- or "oscura-dusk" for the dusk variant
    end,
  },
}
