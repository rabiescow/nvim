return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
    "b0o/SchemaStore.nvim",
  },
  -- example using `opts` for defining servers
  opts = {
    servers = {
      lua_ls = {
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
      },
      ocamllsp = {
        cmd = { "ocamllsp" },
        filetypes = { "ocaml", "menhir", "ocamlinterface", "ocamlocamllex",
          "reason", "dune" },
        root_dir = require("lspconfig").util.root_pattern("*.opam", "esy.json",
          "package.json", ".git", "dune-project", "dune-workspace"),
        settings = {
          ocamllsp = {
            extendedHover = true,
            codelens = true,
            duneDiagnostics = true,
            inlayHints = true,
            syntaxDocumentation = true,
            merlinJumpCodeActions = true,
          },
        },
      },
      gopls = {
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
      },
      zls = {
        cmd = { "zls" },
        on_new_config = function(new_config, new_root_dir)
          if vim.fn.filereadable(vim.fs.joinpath(new_root_dir, "zls.json")) ~= 0 then
            new_config.cmd = { "zls", "--config-path", "zls.json" }
          end
        end,
        filetypes = { 'zig', 'zir' },
        root_dir = require("lspconfig").util.root_pattern("zls.json", "build.zig", ".git"),
        single_file_support = true,
      },
      clangd = {
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
      },
      rust_analyzer = {
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
      },
      hls = {
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
      },
      -- pylsp = {},
      pyright = {
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
      },
      fish_lsp = {
        cmd = { "fish-lsp", "start" },
        cmd_env = { fish_lsp_show_client_popups = false },
        filetypes = { "fish" },
        root_dir = function(fname)
          return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
        end,
        single_file_support = true,
      },
      elixirls = {},
      fortls = {},
      hyprls = {},
      sqlls = {},
      lemminx = {},
      serve_d = {},
      qmlls = {},
      postgres_lsp = {},
      jsonls = {},
      yamlls = {
        cmd = { "yaml-language-server", "--stdio" },
        filetypes = { "yaml" }
      },
      ts_ls = {
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
      },
    }
  },
  config = function(_, opts)
    local lspconfig = require("lspconfig")
    for server, config in pairs(opts.servers) do
      -- passing config.capabilities to blink.cmp merges with the capabilities in your
      -- `opts[server].capabilities, if you've defined it

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}, false))

      capabilities = vim.tbl_deep_extend('force', capabilities, {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true
          }
        }
      })

      config.capabilities = capabilities
      lspconfig[server].setup(config)
    end

    vim.o.updatetime = 250

    -- Mostly turned off diagnostics except the gutter signs
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.INFO] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
        },
      },
      virtual_text = false,
      virtual_lines = false,
    })
  end
}
