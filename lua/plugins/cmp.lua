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

    "Snikimonkd/cmp-go-pkgs",
    -- "crazyhulk/cmp-sign",
    -- "SirVer/ultisnips",

    { "mtoohey31/cmp-fish", ft = "fish" },
  },
  config = function()
    local status, cmp = pcall(require, "cmp")
    if not status then
      return
    end

    local luasnip = require("luasnip")
    local lsp = require("lspconfig")

    -- <LuaSnip>
    --
    -- local has_words_before = function()
    --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    --   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    -- end
    --
    -- </LuaSnip>

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
            cmp.select_next_item()
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
        -- <LuaSnip>
        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item()
        --   elseif has_words_before() then
        --     cmp.complete()
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
        -- ["<S-Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_prev_item()
        --   elseif has_words_before() then
        --     cmp.complete()
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
        -- </LuaSnip>
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        -- { name = "luasnip" },
        { name = 'vsnip' },
        -- { name = "ultisnips" },
        -- { name = 'snippy' },
        { name = "buffer" },
        { name = "path" },
        -- { name = 'nvim_cmp_sign' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'fish' },
        { name = 'emoji' },
        { name = "git" },
        { name = "rg" },
        { name = "go_pkgs" },
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
        format = function(entry, vim_item)
          vim_item.kind = cmp_kinds[vim_item.kind] or ""
          local lsp_icon = "󱗖 "
          vim_item.menu = ({
            buffer = "󰝹 ",
            nvim_lsp = lsp_icon,
            luasnip = " ",
            vsnip = "X"
            -- ultisnips = ""
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
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })
  end,
}
