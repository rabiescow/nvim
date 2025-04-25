return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
    "b0o/SchemaStore.nvim",
  },
  config = function()
    local lsp = require("lspconfig")
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local on_attach = function(client, bufnr)
      -- Inlay Hint provider config
      -- Only turn on inlay hints when not in Insert mode
      if client.server_capabilities.inlayHintProvider then
        local inlayhint = vim.api.nvim_create_augroup(
          "LspInlayHint", { clear = true })
        vim.api.nvim_create_autocmd({ "InsertLeave", "BufEnter" }, {
          buffer = bufnr,
          group = inlayhint,
          callback = function()
            vim.g.inlay_hints_visible = true
            vim.lsp.inlay_hint.enable(true, { bufnr })
          end
        })
        vim.api.nvim_create_autocmd({ "InsertEnter" }, {
          buffer = bufnr,
          group = inlayhint,
          callback = function()
            vim.g.inlay_hints_visible = false
            vim.lsp.inlay_hint.enable(false, { bufnr })
          end
        })
      else
        print("no inlay_hints available")
      end

      -- Code Lens provider config
      if client.server_capabilities.codeLensProvider then
        local codelens = vim.api.nvim_create_augroup(
          "LSPCodeLens", { clear = true })
        vim.api.nvim_create_autocmd({ "InsertLeave", "BufEnter" }, {
          buffer = bufnr,
          group = codelens,
          callback = function()
            vim.lsp.codelens.refresh()
            local lenses = vim.lsp.codelens.get(bufnr)
            vim.lsp.codelens.display(lenses, bufnr, client.id)
          end,
        })
        vim.api.nvim_create_autocmd({ "InsertEnter" }, {
          buffer = bufnr,
          group = codelens,
          callback = function()
            vim.lsp.codelens.clear(client.id, bufnr)
          end,
        })
      end

      -- Hover Provider config
      if client.server_capabilities.hoverProvider then
        local group = vim.api.nvim_create_augroup("Diagnostics", {})
        local buffer = vim.api.nvim_get_current_buf()
        local event = { 'CursorHold' }
        local hoverOpts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          scope = "line",
          header = "Line diagnostics:",
          width = 40,
          height = 15,
          max_heigth = 15,
        }
        local secondaryOpts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          source = "always",
        }
        local dialog = {
          relative = "win",
          win = vim.api.nvim_get_current_win(),
          anchor = "NW",
          row = 1,
          col = 43,
          focusable = false,
          title = "Line Diagnostics",
          title_pos = "center",
          fixed = true,
        }
        vim.api.nvim_create_autocmd(event, {
          buffer = buffer,
          group = group,

          callback = function()
            local _, windownr =
                vim.diagnostic.open_float(hoverOpts, secondaryOpts)
            if windownr ~= nil then
              local config = vim.api.nvim_win_get_config(windownr)
              config = vim.tbl_extend("force", config, dialog)
              vim.api.nvim_win_set_config(windownr, config)
            end
          end
        })
      end
    end

    capabilities = vim.tbl_deep_extend("force", capabilities,
      require("blink.cmp").get_lsp_capabilities({}, false))

    lsp.ocamllsp.setup({
      capabilities = capabilities,
      on_attach = on_attach,
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
      -- grabbed from https://github.com/ocaml/ocaml-lsp/blob/3dc1a6633bfe2ebd34d7aa38f008c8c28300ee55/ocaml-lsp-server/docs/ocamllsp/config.md
      settings = {
        extendedHover = { enable = true },
        codelens = { enable = true },
        duneDiagnostics = { enable = true },
        inlayHints = { enable = true },
        syntaxDocumentation = { enable = true },
        merlinJumpCodeActions = { enable = true },
      },
    })

    lsp.lua_ls.setup({
      cmd = { "lua-language-server" },
      filetypes = { "lua" },
      root_dir = require("lspconfig").util.root_pattern("luarc.json",
        "luarc.jsonc", "luacheckrc", ".stylua.toml", "stylua.toml",
        "selene.toml", "selene.yml", ".git"),
      single_file_support = true,
      log_level = vim.lsp.protocol.MessageType.Warning,
      settings = {
        Lua = {
          telemetry = { enable = false },
          completion = {
            callSnippet = "Replace",
            displayContext = 2,
            keywordSnippet = "Both",
          },
          format = { enable = true },
          hint = {
            enable = true,
            arrayIndex = "Enable",
            setType = true,
          },
          diagnostics = {
            enable = true,
            globals = { "vim" },
          },
          runtime = {
            version = "LuaJIT"
          },
          workspace = {
            checkThirdParty = "ApplyInMemory",
            library = {
              vim.env.VIMRUNTIME,
              "${3rd}/luv/library",
            },
          },
        },
      },
      capabilities = capabilities,
      on_attach = on_attach
    })

    lsp.gopls.setup({
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      single_file_support = true,
      settings = {
        gopls = {
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
      capabilities = capabilities,
      on_attach = on_attach
    })

    lsp.zls.setup({
      cmd = { "zls" },
      on_new_config = function(new_config, new_root_dir)
        if vim.fn.filereadable(vim.fs.joinpath(new_root_dir, "zls.json")) ~= 0 then
          new_config.cmd = { "zls", "--config-path", "zls.json" }
        end
      end,
      filetypes = { 'zig', 'zir' },
      root_dir = require("lspconfig").util.root_pattern("zls.json", "build.zig", ".git"),
      single_file_support = true,
      capabilities = capabilities,
      on_attach = on_attach
    })

    lsp.clangd.setup({
      cmd = { "clangd" },
      filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
      root_dir = function(fname)
        local util = require("lspconfig").util
        return util.root_pattern(".clangd", ".clang-tidy", ".clang-format",
              "compile_commands.json", "compile_flags.txt", "configure.ac")(fname)
            or vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
      end,
      single_file_support = true,
      capabilities = {
        textDocument = {
          completion = {
            editsNearCursor = true,
          },
        },
        offsetEncoding = { "utf-8", "utf-16" },
      },
      on_attach = on_attach
    })

    lsp.rust_analyzer.setup({
      cmd = { "rust-analyzer" },
      filetypes = { "rust" },
      capabilities = capabilities,
      on_attach = on_attach
    })

    lsp.hls.setup({
      cmd = { "haskell-language-server-wrapper", "--lsp" },
      filetypes = { "haskell", "lhaskell" },
      root_dir = require("lspconfig").util.root_pattern("hie.yaml",
        "stack.yaml", "cabal.project", "*.cabal", "package.yaml"),
      single_file_support = true,
      settings = {
        haskell = {
          cabalFormattingProvider = "cabalfmt",
          formattingProvider = "ormolu"
        },
      },
      capabilities = capabilities,
      on_attach = on_attach
    })

    lsp.pyright.setup({
      on_new_config = function(new_config)
        local get_pipenv_venv_path = function()
          local pipenv_venv = vim.fn.trim(vim.fn.system("pipenv --venv"))
          if pipenv_venv == "" then return nil end
          local split = vim.split(pipenv_venv, "\n")
          for _, line in ipairs(split) do
            if string.match(line, "^/") ~= nil then
              if vim.fn.isdirectory(line) then return line end
            end
          end

          return nil
        end
        local get_python_path = function()
          local venv_path = get_pipenv_venv_path()
          if venv_path ~= nil then
            return venv_path .. "/bin/python"
          else
            return vim.fn.trim(vim.fn.system("python -c 'import sys; print(sys.executable)'"))
          end
        end
        local python_path = get_python_path()
        if python_path ~= nil then new_config.settings.python.pythonPath = python_path end
      end,
      settings = {
        pyright = {
          disableOrganizeImports = false,
          analysis = {
            useLibraryCodeForTypes = true,
            autoSearchPaths = true,
            diagnosticMode = "workspace",
            autoImportCompletions = true,
          },
        },
      },
      capabilities = capabilities,
      on_attach = on_attach
    })

    lsp.fish_lsp.setup({
      cmd = { "fish-lsp", "start" },
      cmd_env = { fish_lsp_show_client_popups = false },
      filetypes = { "fish" },
      root_dir = function(fname)
        return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
      end,
      single_file_support = true,
      capabilities = capabilities,
      on_attach = on_attach
    })

    lsp.yamlls.setup({
      cmd = { "yaml-language-server", "--stdio" },
      filetypes = { "yaml" },
      capabilities = capabilities,
      on_attach = on_attach
    })

    lsp.jsonls.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    lsp.ts_ls.setup({
      init_options = { hostInfo = "neovim" },
      cmd = { "typescript-language-server", "--stdio" },
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      root_dir = require("lspconfig").util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
      single_file_support = true,
      capabilities = capabilities,
      on_attach = on_attach
    })

    lsp.hyprls.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    lsp.elixirls.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    lsp.fortls.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    lsp.sqlls.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    lsp.lemminx.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    lsp.serve_d.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    lsp.qmlls.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    lsp.postgres_lsp.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    vim.cmd([[
      lua vim.lsp.codelens.refresh({ bufnr = 0 })
    ]])
  end
}
