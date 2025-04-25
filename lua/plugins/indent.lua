return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufEnter" },
  main = "ibl",
  -- init = function()
  --   vim.api.nvim_set_var("enfocado_plugins", "indent-blankline")
  -- end,
  config = function()
    local hooks = require("ibl.hooks")
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "CursorBlu", { fg = "#181818" })
    end)

    require("ibl").setup({
      indent = { highlight = "CursorBlu" },
      scope = { enabled = true },
    })
  end,
}
