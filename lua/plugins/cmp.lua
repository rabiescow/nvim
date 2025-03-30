-- return {}
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-emoji",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "cmp-nvim-lsp-document-symbol",
    "hrsh7th/vim-vsnip",
    "hrsh7th/vim-vsnip-integ",
    "petertriho/cmp-git",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim",
    "L3MON4D3/LuaSnip",
    "lukas-reineke/cmp-rg",
    "amarz45/nvim-cmp-fonts",

    "Snikimonkd/cmp-go-pkgs",
    -- rust completions
    {
      "zjp-CN/nvim-cmp-lsp-rs",
      ---@type cmp_lsp_rs.Opts
      opts = {
        unwanted_prefix = { "color", "ratatui::style::Styled" },
        kind = function(k)
          return { k.Module, k.Function }
        end,
        combo = {
          alphabetic_label_but_underscore_last = function()
            local comparators = require("cmp_lsp_rs").comparators
            return { comparators.sort_by_label_but_underscore_last }
          end,
          recentlyUsed_sortText = function()
            local compare = require("cmp").config.compare
            local comparators = require("cmp_lsp_rs").comparators
            return {
              compare.recently_used,
              compare.sort_text,
              comparators.sort_by_label_but_underscore_last
            }
          end,
        },
      },
    },
    { "mtoohey31/cmp-fish", ft = "fish" },
  },
  config = function()
    local status, cmp = pcall(require, "cmp")
    if not status then
      return
    end

    local luasnip = require("luasnip")
    local lsp = require("lspconfig")

    -- <vsnip>
    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local feedkey = function(key, mode)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end
    -- </vsnip>

    local cmp_kinds = {
      Text = "󰵴",
      Method = " ",
      Function = "󰡱 ",
      Constructor = " ",
      Field = " ",
      Variable = "󱃻 ",
      Class = "ﴯ  ",
      Interface = " ",
      Module = "",
      Property = "ﰠ  ",
      Unit = "",
      Value = "λ",
      Enum = "",
      Keyword = " ",
      Snippet = " ",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = " ",
      Struct = "  ",
      Event = "",
      Operator = "",
      TypeParameter = "",
    }

    cmp.setup({
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
          -- luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = {
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        },
        documentation = {
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        },
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-S-j>"] = cmp.mapping.scroll_docs(-4),
        ["<C-S-k>"] = cmp.mapping.scroll_docs(4),
        ["<Esc>"] = cmp.mapping.abort(),
        -- ["<Enter>"] = cmp.mapping.complete({}),
        ["<S-Enter>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true
        }),
        -- <vsnip>
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if #cmp.get_entries() == 1 then
              cmp.confirm({ select = true })
            else
              cmp.select_next_item()
            end
          elseif vim.fn["vsnip#available"](1) == 1 then
            feedkey("<Plug>(vsnip-expand-or-jump)", "")
          elseif has_words_before() then
            cmp.complete()
          else
            fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.fn["vsnip#jumpable"](-1) == 1 then
            feedkey("<Plug>(vsnip-jump-prev)", "")
          end
        end, { "i", "s" }),
        -- </vsnip>
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = 'vsnip' },
        { name = "buffer" },
        { name = "path" },
        { name = 'nvim_lsp_signature_help' },
        { name = 'fish' },
        { name = 'emoji' },
        { name = "git" },
        { name = "rg" },
        { name = "go_pkgs" },
        { name = "rust" },

        option = {
          get_bufnrs = function()
            local bufs = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              bufs[vim.api.nvim_win_get_buf(win)] = true
            end
            return vim.tbl_keys(bufs)
          end,
        },
      }),
      formatting = {
        expandable_indicator = true,
        fields = { "kind", "abbr", "menu" },
        format = function(entry, item)
          item.kind = cmp_kinds[item.kind] or ""
          local menu_icons = {
            lsp_icon = "󱗖 ",
            path = '🖫',
            buffer = "󰝹 ",
            luasnip = " ",
            vsnip = ""
          }
          item.menu = menu_icons[entry.source.name]
          return item
        end,
      },
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = {
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      },
      sources = {
        { name = "buffer" },
        { name = 'nvim_lsp_document_symbol' },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
      mapping = {
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      },
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })
  end,

  --@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp_lsp_rs = require("cmp_lsp_rs")
    local comparators = cmp_lsp_rs.comparators
    local compare = require("cmp").config.compare

    -- opts.sorting.comparators = {
    --   compare.exact,
    --   compare.score,
    --   -- comparators.inherent_import_inscope,
    --   comparators.inscope_inherent_import,
    --   comparators.sort_by_label_but_underscore_last,
    -- }

    -- for _, source in ipairs(opts.sources) do
    --   cmp_lsp_rs.filter_out.entry_filter(source)
    -- end

    return opts
  end,
}
