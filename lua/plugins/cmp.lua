-- return {}
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim",
    {
      "L3MON4D3/LuaSnip",
      -- follow latest release.
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
    },
  },
  -- init = function()
  --   vim.api.nvim_set_var("enfocado_plugins", "cmp")
  -- end,
  config = function()
    local status, cmp = pcall(require, "cmp")
    if not status then
      return
    end

    local luasnip = require("luasnip")
    local lsp = require("lspconfig")

    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

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
          luasnip.lsp_expand(args.body)
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
        ["<Enter>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
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
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          vim_item.kind = cmp_kinds[vim_item.kind] or ""
          local lsp_icon = "󱗖 "
          vim_item.menu = ({
            buffer = "󰝹 ",
            nvim_lsp = lsp_icon,
            luasnip = " ",
          })[entry.source.name]
          return vim_item
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
      -- mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
      mapping = {
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      },
      -- mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })

    -- Set up lspconfig.
    -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
    -- require('lspconfig')['ocamllsp'].setup {
    --   capabilities = capabilities
    -- }
  end,
}
