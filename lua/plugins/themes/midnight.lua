return {
  "dasupradyumna/midnight.nvim",
  lazy = true,
  priority = 1000,
  config = function()
    require("midnight").setup()
  end
}
