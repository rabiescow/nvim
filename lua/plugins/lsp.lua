return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
    "b0o/SchemaStore.nvim",
  },
  config = function()
    local lsp = require("lspconfig")
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities,
      require("blink.cmp").get_lsp_capabilities({}, false))
    local on_attach = function(client, bufnr)
      if client.server_capabilities.code_lens then
        local codelens = vim.api.nvim_create_augroup("LSPCodeLens",
          { clear = true })
        vim.api.nvim_create_autocmd(
          { "BufEnter", "InsertLeave", "CursorHold" }, {
            buffer = bufnr,
            group = codelens,
            callback = function()
              vim.lsp.codelens.refresh()
            end,
          })
      end
    end


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
      settings = {
        ocaml = {
          extendedHover = true,
          codelens = true,
          duneDiagnostics = true,
          inlayHints = true,
          syntaxDocumentation = true,
          merlinJumpCodeActions = true,
        },
      },
      capabilities = capabilities,
      on_attach = on_attach
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
      -- capabilities = {
      --   textDocument = {
      --     completion = {
      --       editsNearCursor = true,
      --     },
      --   },
      --   offsetEncoding = { "utf-8", "utf-16" },
      -- },
      capabilities = capabilities,
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
  end
}
