return {
  "nvim-treesitter/nvim-treesitter-refactor",
  dependencies = { "nvim-treesitter/nvim-tree-docs" },
  config = function()
    require("nvim-treesitter.configs").setup({
      refactor = {
        highlight_definitions = {
          enable = true,
          -- Set to false if you have an `updatetime` of ~100.
          clear_on_cursor_move = false,
        },
        highlight_current_scope = {
          enable = false,
        },
        navigation = {
          enable = true,
          -- Assign keymaps to false to disable them, e.g. `goto_definition = false`.
          keymaps = {
            goto_definition = "gnd",
            list_definitions = "gnD",
            list_definitions_toc = "gO",
            goto_next_usage = "<a-*>",
            goto_previous_usage = "<a-#>",
          },
        },
        smart_rename = {
          enable = true,
          -- Assign keymaps to false to disable them, e.g. `smart_rename = false`.
          keymaps = {
            smart_rename = "grr",
          },
        },
      },
      tree_docs = {
        enable = true,
        spec_config = {
          jsdoc = {
            slots = {
              class = { author = true }
            },
          },
        },
      },
    })
  end
}
