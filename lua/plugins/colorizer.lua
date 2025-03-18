return {
  "norcalli/nvim-colorizer.lua",
  -- init = function()
  --   vim.api.nvim_set_var("enfocado_plugins", "colorizer")
  -- end,
  config = function()
    require("colorizer").setup()
  end,
}
