return {
  "rabiescow/vim-enfocado",
  priority = 1000,
  lazy = false,
  init = function()
    -- vim.api.nvim_set_var("enfocado_style", "neon")
    vim.api.nvim_set_var("enfocado_style", "nature")

    local plugs = {}
    table.insert(plugs, "all")
    vim.api.nvim_set_var("enfocado_plugins", plugs)

    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "enfocado",
      callback =
          function()
            -- vim.api.nvim_set_hl(0, "NormalNC", { fg = "#cccc33", bg = "#1e1e1e" })
            -- vim.api.nvim_set_hl(0, "Normal", { fg = "#cccc33", bg = "#181818" })
            -- vim.api.nvim_set_hl(0, "OilDirIcon", { fg = "#666622" })
            -- vim.api.nvim_set_hl(0, "OilDirHidden", { fg = "#555555", bold = true })
            -- vim.api.nvim_set_hl(0, "OilDir", { fg = "#44ee66", bold = true })
            -- vim.api.nvim_set_hl(0, "OilFileHidden", { fg = "#555555" })
            -- vim.api.nvim_set_hl(0, "OilFile", { fg = "#9999ff" })
          end,
    })
  end,
  config = function()
  end,
}
