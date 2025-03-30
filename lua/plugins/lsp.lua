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

    -- local capabilities = vim.tbl_deep_extend('force', {
    --   textDocument = {
    --     foldingRange = {
    --       dynamicRegistration = false,
    --       lineFoldingOnly = true
    --     }
    --   }
    -- }, {})

    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = vim.tbl_deep_extend('force', capabilities,
    --   require('blink.cmp').get_lsp_capabilities({}, false))

    local on_attach = function(client, bufnr)
      -- enable completion triggered by <C-x><C-o>
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

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

    lsp.ocamllsp.setup({
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
          completeUnimported = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
          },
        },
      },
    })

    lsp.zls.setup({
      cmd = { "zls", "--enable-debug-log" },
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
      cmd = { "rust-analyzer" },
      settings = {
        ["rust-analyzer"] = {
          imports = {
            granularity = {
              group = "module",
            },
            prefix = "self",
          },
          assist = {
            importMergeBehavior = "last",
            importPrefix = "by_self",
          },
          cargo = {
            loadOutDirsFromCheck = true,
            buildScripts = {
              enable = true,
            },
            extraArgs = {},
            extraEnv = {},
            target = null,
            unsetTest = { "core" },
          },
          checkOnSave = true,
          check = {
            allTargets = true,
            extraArgs = {},
            extraEnv = {},
            features = null,
            ignores = {},
            invocationLocation = "workspace",
            noDefaultFeatures = null,
            overrideCommand = null,
            targets = null,
            workspace = true,
          },
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
            limit = null,
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
          files = {
            excludeDirs = {},
            watcher = {},
          },
          highlightRelated = {
            breakPoints = {
              enable = true,
            },
            closureCapture = {
              enable = true,
            },
            exitPoints = {
              enable = true,
            },
            references = {
              enable = true,
            },
            yieldPoints = {
              enable = true,
            },
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
            memoryLayout = {
              alignment = "hexadecimal",
              enable = true,
              niches = false,
              offset = "hexadecimal",
              size = "both",
            },
          },
          procMacro = {
            enable = true,
          },
        },
      },
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp.serve_d.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    -- Diagnostic symbols in the sign column (gutter)
    local signs = {
      Error = " ",
      Warn = " ",
      Info = " ",
      Hint = " ",
    }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    vim.diagnostic.config({
      virtual_text = false,
      -- virtual_text = { prefix = "●" }, ** enable this to get inline error messages
      signs = true,     -- enables a diagnostics symbol in sign column
      update_in_insert = true,
      underline = true, -- underlines the offender
      severity_sort = true,
      float = {
        border = "single",
        source = "always",
        header = "Diagnostics",
        prefix = "",
      },
    })

    vim.o.updatetime = 250
    vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = false,
      update_in_insert = false,
      -- virtual_text = { spacing = 4, prefix = "●" },
      virtual_text = false,
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
