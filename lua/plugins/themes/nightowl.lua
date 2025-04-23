return {
  "oxfist/night-owl.nvim",
  lazy = true,
  priority = 1000,
  config = function()
    require("night-owl").setup()
    vim.api.nvim_set_hl(0, "@nowl.visual.active", { bg = "#284671" })
  end
}
