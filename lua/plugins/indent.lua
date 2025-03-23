return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufEnter" },
  main = "ibl",
  -- init = function()
  --   vim.api.nvim_set_var("enfocado_plugins", "indent-blankline")
  -- end,
  config = function()
    -- local hl = { "CursorBlu" }

    -- local hooks = require("ibl.hooks")
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    -- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    -- 	vim.api.nvim_set_hl(0, "CursorBlu", { fg = "#323C4A" })
    -- end)

    -- require("ibl").setup({
    -- 	indent = { highlight = hl },
    -- 	scope = { enabled = false },
    -- })

    local highlight = {
      "CursorColumn",
      "Whitespace",
    }

    require("ibl").setup({
      indent = { highlight = highlight, char = "" },
      whitespace = {
        highlight = highlight,
        remove_blankline_trail = false,
      },
      scope = { enabled = false },
    })
  end,
}
