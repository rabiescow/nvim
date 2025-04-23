return {
  "windwp/nvim-autopairs",

  event = { "InsertEnter" },
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  config = function()
    local autopairs = require("nvim-autopairs")
    local cond = require("nvim-autopairs.conds")
    -- nvim autopairs config
    autopairs.setup({
      check_ts = true, -- enable treesitter
      ts_config = {
        lua = { "string" },
        ocaml = { "string" },
      },
      fast_wrap = {
        map = "A-e",
        chars = { "{", "[", "(", '"', "'", "<", "(*" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = "$",
        before_key = "h",
        after_key = "l",
        cursor_pos_before = false,
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        manual_position = true,
        highlight = "Search",
        highlight_grey = "Comment",
      },
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      disable_in_macro = true,        -- disable when recording or executing a macro
      disable_in_visualblock = false, -- disable when insert after visual block mode
      disable_in_replace_mode = true,
      ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
      enable_moveright = true,
      enable_afterquote = true,         -- add bracket pairs after quote
      enable_check_bracket_line = true, --- check bracket in same line
      enable_bracket_in_quote = true,   --
      enable_abbr = false,              -- trigger abbreviation
      break_undo = true,                -- switch for basic rule break undo sequence
      map_cr = true,
      map_bs = true,                    -- map the <BS> key
      map_c_h = true,                   -- Map the <C-h> key to delete a pair
      map_c_w = true,                   -- map <c-w> to delete a pair if possible
    })

    -- import nvim-autopairs completion functionality
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    -- import nvim-cmp plugin (completions plugin)
    local cmp = require("cmp")

    -- make autopairs and completion work together
    -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    autopairs.get_rules("'")[1]:with_pair(cond.not_filetypes({ "scheme", "lisp", "ocaml", "ml" }))
  end,
}
