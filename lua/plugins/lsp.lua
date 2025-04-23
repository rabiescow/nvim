return {
  'neovim/nvim-lspconfig',
  dependencies = { 'saghen/blink.cmp', "b0o/SchemaStore.nvim" },
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
            completion = { callSnippet = 'Replace' },
            -- Using stylua for formatting.
            format = { enable = false },
            hint = {
              enable = true,
              arrayIndex = 'Disable',
            },
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              enable = true,
              globals = { "vim" },
              severity = {
                'Error',
                'Warning',
                'Information',
                'Hint',
              },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                '${3rd}/luv/library',
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
      },
      gopls = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
           single_file_support = true,
      },
      zls = {
        cmd = { "zls" },
        on_new_config = function(new_config, new_root_dir)
          if vim.fn.filereadable(vim.fs.joinpath(new_root_dir, 'zls.json')) ~= 0 then
            new_config.cmd = { 'zls', '--config-path', 'zls.json' }
          end
        end,
        filetypes = { 'zig', 'zir' },
        root_dir = require("lspconfig").util.root_pattern('zls.json', 'build.zig', '.git'),
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
          offsetEncoding = { 'utf-8', 'utf-16' },
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
        cmd = { 'fish-lsp', 'start' },
        cmd_env = { fish_lsp_show_client_popups = false },
        filetypes = { 'fish' },
        root_dir = function(fname)
          return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
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
        cmd = { 'yaml-language-server', '--stdio' },
        filetypes = { 'yaml' }
      },
      ts_ls = {
        init_options = { hostInfo = 'neovim' },
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = {
          'javascript',
          'javascriptreact',
          'javascript.jsx',
          'typescript',
          'typescriptreact',
          'typescript.tsx',
        },
        root_dir = require("lspconfig").util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git'),
        single_file_support = true,
      },
    }
  },
  config = function(_, opts)
    local lspconfig = require('lspconfig')
    local keymap = vim.keymap
    for server, config in pairs(opts.servers) do
      -- passing config.capabilities to blink.cmp merges with the capabilities in your
      -- `opts[server].capabilities, if you've defined it

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
      end

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
      config.on_attach = on_attach
      lspconfig[server].setup(config)
    end

    vim.o.updatetime = 250

    -- function PrintDiagnostics(opts, bufnr, line_nr, client_id)
    --   bufnr = bufnr or 0
    --   line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
    --   opts = opts or { ['lnum'] = line_nr }
    --
    --   local line_diagnostics = vim.diagnostic.get(bufnr, opts)
    --   if vim.tbl_isempty(line_diagnostics) then return end
    --
    --   local diagnostic_message = ""
    --   for i, diagnostic in ipairs(line_diagnostics) do
    --     diagnostic_message = diagnostic_message ..
    --         string.format("󱒄 %s | %s", diagnostic.severity, diagnostic.message or "")
    --     print(diagnostic_message)
    --     if i ~= #line_diagnostics then
    --       diagnostic_message = diagnostic_message .. "\n"
    --     end
    --   end
    --   vim.api.nvim_echo({ { diagnostic_message, "Normal" } }, false, {})
    -- end

    -- Diagnostic symbols in the sign column (gutter)
    vim.diagnostic.config({
      virtual_text = false,
      -- virtual_text = { prefix = "󱒄" },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.INFO] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 "
        }
      },
      update_in_insert = false,
      underline = true,
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
  end
}
