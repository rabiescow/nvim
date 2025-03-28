-- return {}
return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    position = "bottom",   -- position of the list can be: bottom, top, left, right
    height = 10,           -- height of the trouble list when position is top or bottom
    width = 50,            -- width of the list when position is left or right
    icons = true,          -- use devicons for filenames
    -- mode options:
    -- "workspace_diagnostics"
    -- "document_diagnostics"
    -- "quickfix"
    -- "lsp_references"
    -- "loclist"
    mode = "document_diagnostics",
    severity = nil, -- nil (ALL) or vim.diagnostic.severity.ERROR | WARN | INFO | HINT
    fold_open = " ", -- icon used for open folds
    fold_closed = " ", -- icon used for closed folds
    group = true, -- group results by file
    padding = true, -- add an extra new line on top of the list
    cycle_results = true, -- cycle item list when reaching beginning or end of list
    action_keys = { -- key mappings for actions in the trouble list
      -- map to {} to remove a mapping, for example:
      -- close = {},
      close = "q",
      cancel = "<esc>",
      refresh = "r",
      jump = { "<cr>", "<tab>", "<2-leftmouse>" },
      open_split = { "<c-x>" },
      open_vsplit = { "<c-v>" },
      open_tab = { "<c-t>" },
      jump_close = { "o" },
      toggle_mode = "m",
      toggle_preview = "P",                                                                 -- toggle auto_preview
      hover = "K",                                                                          -- opens a small popup with the full multiline message
      preview = "p",                                                                        -- preview the diagnostic location
      open_code_href = "c",                                                                 -- if present, open a URI with more information about the diagnostic error
      close_folds = { "zM", "zm" },                                                         -- close all folds
      open_folds = { "zR", "zr" },                                                          -- open all folds
      toggle_fold = { "zA", "za" },                                                         -- toggle fold of current file
      previous = "k",                                                                       -- previous item
      next = "j",                                                                           -- next item
      help = "?",                                                                           -- help menu
    },
    multiline = true,                                                                       -- render multi-line messages
    indent_lines = true,                                                                    -- add an indent guide below the fold icons
    win_config = { border = "single" },                                                     -- window configuration for floating windows. See |nvim_open_win()|.
    auto_open = false,                                                                      -- automatically open the list when you have diagnostics
    auto_close = true,                                                                      -- automatically close the list when you have no diagnostics
    auto_preview = true,                                                                    -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
    auto_fold = false,                                                                      -- automatically fold a file trouble list at creation
    auto_jump = { "lsp_definitions" },                                                      -- for the given modes, automatically jump if there is only a single result
    include_declaration = { "lsp_references", "lsp_implementations", "lsp_definitions" },   -- for the given modes, include the declaration of the current symbol in the results
    signs = {
      -- icons / text used for a diagnostic
      error = " ",
      warning = " ",
      hint = " ",
      information = "",
      other = "⇋",
    },
    use_diagnostic_signs = true,   -- enabling this will use the signs defined in your lsp client
  },
}
