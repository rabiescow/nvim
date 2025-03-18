return {
  "kylechui/nvim-surround",
  event = { "BufReadPre", "BufNewFile" },
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  -- init = function()
  --   vim.api.nvim_set_var("enfocado_plugins", { "surround" })
  -- end,
  config = true,
}
