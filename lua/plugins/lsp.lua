-- return {}
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/nvim-cmp",

    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { "j-hui/fidget.nvim", opts = {} },
  },
  config = function()
    local lsp = require("lspconfig")
    local keymap = vim.keymap
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local on_attach = function(client, bufnr)
      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
      keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
      keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
      keymap.set("n", "*", vim.lsp.buf.code_action, bufopts)
      keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
      keymap.set("n", "gk", vim.lsp.buf.signature_help, bufopts)
      keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
      keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
      keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, bufopts)
      keymap.set("n", "<leader>td", vim.lsp.buf.type_definition, bufopts)
      keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
      keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
      keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
      keymap.set("n", "<leader>f", vim.lsp.buf.format, bufopts)
      keymap.set("n", "<leader>do", vim.diagnostic.open_float, bufopts)
      keymap.set("n", "gp", vim.diagnostic.goto_prev, bufopts)
      keymap.set("n", "gl", vim.diagnostic.goto_next, bufopts)
      keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, bufopts)

      -- code lens
      if client.server_capabilities.code_lens then
        local codelens = vim.api.nvim_create_augroup("LSPCodeLens", { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "CursorHold" }, {
          group = codelens,
          callback = function()
            vim.lsp.codelens.refresh()
          end,
          buffer = bufnr,
        })
      end
    end

    local c = vim.lsp.protocol.make_client_capabilities()
    c.textDocument.completion.completionItem.snippetSupport = true
    c.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    }

    -- Diagnostic symbols in the sign column (gutter)
    vim.diagnostic.config({
      virtual_text = false,
      -- virtual_text = { prefix = "󱒄" },
      signs = { text = { [vim.diagnostic.severity.ERROR] = " ", [vim.diagnostic.severity.WARN] = " ", [vim.diagnostic.severity.INFO] = " ", [vim.diagnostic.severity.HINT] = " " } },
      update_in_insert = true,
      underline = false,
      severity_sort = true,
      float = {
        border = "single",
        source = "always",
        header = "Diagnostics",
        prefix = "",
      },
      virtual_lines = {
        only_current_line = true,
        spacing = 1,
      },
    })

    lsp.ocamllsp.setup({
      cmd_env = { DUNE_BUILD_DIR = '_build_lsp' },
      cmd = { "ocamllsp" },
      filetypes = {
        "ocaml",
        "ocaml.menhir",
        "ocaml.interface",
        "ocaml.ocamllex",
        "dune"
      },
      root_dir = lsp.util.root_pattern(
        "*.opam",
        "esy.json",
        "package.json",
        ".git",
        "dune-project",
        "dune-workspace"
      ),
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp.gopls.setup({
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      root_dir = lsp.util.root_pattern("go.work", "go.mod", ".git"),
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        gopls = {
          -- experimentalPostFixCompletions = true,
          completeUnimported = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
            shadow = true,
          },
          staticcheck = true,
        },
      },
      init_options = {
        usePlaceholders = true,
      }
    })

    lsp.zls.setup({
      cmd = { "zls" },
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp.clangd.setup({
      filetypes = { "c", "cpp", "objc", "objcpp" },
      root_dir = lsp.util.root_pattern("src"),
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp.hls.setup({
      cmd = { "haskell-language-server-wrapper", "--lsp" },
      filetypes = { "haskell", "lhaskell" },
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        haskell = {
          cabalFormattingProvider = "cabalfmt",
          formattingProvider = "ormolu"
        }
      },
    })

    lsp.elixirls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp.fortls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp.jsonls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp.hyprls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })

    lsp.pylsp.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { "python" },
    })

    lsp.sqlls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp.lemminx.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp.rust_analyzer.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { "rust-analyzer" },
      settings = {
        ["rust-analyzer"] = {
          completion = {
            autoImport = {
              enable = true,
            },
            autoself = {
              enable = true,
            },
            callable = {
              snippets = "fill_arguments",
            },
            limit = 1000,
            postfix = {
              enable = true,
            },
          },
          diagnostics = {
            disables = {},
            enabled = true,
            experimental = {
              enable = true,
            },
            remapPrefix = {},
            warningsAsHint = {},
            warningsAsInfo = {},
          },
          hover = {
            action = {
              enable = true,
              debug = {
                enable = true,
              },
              gotoTypeDef = {
                enable = true,
              },
              implementations = {
                enable = true,
              },
              references = {
                enable = true,
              },
              run = {
                enable = true,
              },
            },
            documentation = {
              enable = true,
              keywords = {
                enable = true,
              },
            },
            links = {
              enable = true,
            },
          },
        },
      },
    })

    lsp.serve_d.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    vim.o.updatetime = 250

    function PrintDiagnostics(opts, bufnr, line_nr, client_id)
      bufnr = bufnr or 0
      line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
      opts = opts or { ['lnum'] = line_nr }

      local line_diagnostics = vim.diagnostic.get(bufnr, opts)
      if vim.tbl_isempty(line_diagnostics) then return end

      local diagnostic_message = ""
      for i, diagnostic in ipairs(line_diagnostics) do
        diagnostic_message = diagnostic_message ..
            string.format("󱒄 %s | %s", diagnostic.severity, diagnostic.message or "")
        print(diagnostic_message)
        if i ~= #line_diagnostics then
          diagnostic_message = diagnostic_message .. "\n"
        end
      end
      vim.api.nvim_echo({ { diagnostic_message, "Normal" } }, false, {})
    end

    -- uses the function above to display diagnostics in the cmd bar
    -- vim.cmd([[ autocmd! CursorHold,CursorHoldI * lua PrintDiagnostics() ]])

    -- this function auto generates the behavior of shift-k diagnostics
    -- can be annoying and overlay the text to make it hard to read
    -- vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = false,
      update_in_insert = false,
      virtual_text = { spacing = 4, prefix = "●" },
      severity_sort = true,
    })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

    vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

    vim.cmd([[
      " make hover window"s background transparent
      highlight! link FloatBorder Normal
      highlight! link NormalFloat Normal
    ]])
  end,
}
