-- local function underline_diagnostics(client, bufnr)
--     if client.server_capabilities.hoverProvider then
--         local augroup = vim.api.nvim_create_augroup("LspUnderline",
--                                                     {clear = true})
--         local event = {"BufEnter"}
--         vim.api.nvim_create_autocmd(event, {
--             buffer = bufnr,
--             group = augroup,
--             callback = function()
--                 diagnosts = vim.diagnostic.get(bufnr,
--                                                {vim.diagnostic.severity.ERROR})
--                 if diagnosts then
--                     for _, d in diagnosts do
--                         vim.fn.sign_define("LspLinecolor",
--                                            {texthl = "Error", text = ""})
--                         line = d.lnum
--                         vim.api.nvim_get_current_line()
--                     end
--                 end
--             end
--         })
--     end
-- end
local function inline_float_diagnostics(client, bufnr)
    -- Hover Provider config
    if client.server_capabilities.hoverProvider then
        local augroup = vim.api.nvim_create_augroup("LspDiagnostics",
                                                    {clear = true})
        local event = {"BufEnter", "CursorHold"}
        vim.api.nvim_create_autocmd(event, {
            buffer = bufnr,
            group = augroup,

            callback = function()
                local currentWidth, _ = Get_editor_dimensions()
                local diagnosticsWidth = math.floor(math.abs(currentWidth / 2))
                local diagnosticsHeight = 12
                local diagnosticsColumn = currentWidth - (diagnosticsWidth + 3)
                local diagnosticsRow = Get_diagnostics_position(
                                           diagnosticsHeight)
                local hoverOpts = {
                    focusable = false,
                    close_events = {
                        "BufLeave", "CursorMoved", "InsertEnter", "FocusLost"
                    },
                    scope = "line",
                    header = "Line diagnostics:",
                    width = diagnosticsWidth,
                    height = diagnosticsHeight,
                    max_heigth = diagnosticsHeight
                }
                local secondaryOpts = {
                    focusable = false,
                    close_events = {
                        "BufLeave", "CursorMoved", "InsertEnter", "FocusLost"
                    },
                    source = "always"
                }
                local dialog = {
                    relative = "win",
                    win = vim.api.nvim_get_current_win(),
                    anchor = "NW",
                    row = diagnosticsRow,
                    col = diagnosticsColumn,
                    focusable = false,
                    title = "Line Diagnostics",
                    title_pos = "center",
                    fixed = true,
                    border = "rounded"
                }
                local _, windownr = vim.diagnostic.open_float(hoverOpts,
                                                              secondaryOpts)
                if windownr ~= nil then
                    local config = vim.api.nvim_win_get_config(windownr)
                    config = vim.tbl_extend("force", config, dialog)
                    vim.api.nvim_win_set_config(windownr, config)
                end
            end
        })
    end
end

local function code_lens(client, bufnr)
    local augroup_lens = vim.api.nvim_create_augroup("LSPCodeLens",
                                                     {clear = true})

    -- Code Lens provider config
    if client.server_capabilities.codeLensProvider then
        vim.api.nvim_create_autocmd({"InsertLeave", "BufEnter", "LspAttach"}, {
            buffer = bufnr,
            group = augroup_lens,
            callback = function()
                vim.lsp.codelens.refresh()
                local lenses = vim.lsp.codelens.get(bufnr)
                vim.lsp.codelens.display(lenses, bufnr, client.id)
            end
        })
        vim.api.nvim_create_autocmd({"InsertEnter"}, {
            buffer = bufnr,
            group = augroup_lens,
            callback = function()
                vim.lsp.codelens.clear(client.id, bufnr)
            end
        })
    end
end

local function inlay_hints(client, bufnr)
    local augroup_inlay = vim.api.nvim_create_augroup("LSPInlayHint",
                                                      {clear = true})
    -- Inlay Hint provider config
    -- Only turn on inlay hints when not in Insert mode
    if client.server_capabilities.inlayHintProvider then
        vim.api.nvim_create_autocmd({"InsertLeave", "BufEnter", "LspAttach"}, {
            buffer = bufnr,
            group = augroup_inlay,
            callback = function()
                vim.g.inlay_hints_visible = true
                vim.lsp.inlay_hint.enable(true, {bufnr})
            end
        })
        vim.api.nvim_create_autocmd({"InsertEnter"}, {
            buffer = bufnr,
            group = augroup_inlay,
            callback = function()
                vim.g.inlay_hints_visible = false
                vim.lsp.inlay_hint.enable(false, {bufnr})
            end
        })
    else
        print("no inlay hints available")
    end
end

local function attach(client, bufnr)
    inlay_hints(client, bufnr)
    code_lens(client, bufnr)
    inline_float_diagnostics(client, bufnr)
end

return {
    "neovim/nvim-lspconfig",
    dependencies = {"saghen/blink.cmp", "b0o/SchemaStore.nvim"},
    config = function()
        local lsp = require("lspconfig")
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local on_attach = function(client, bufnr) attach(client, bufnr) end
        capabilities = vim.tbl_deep_extend("force", capabilities, require(
                                               "blink.cmp").get_lsp_capabilities(
                                               {}, false))

        lsp.ocamllsp.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = {"ocamllsp"},
            filetypes = {
                "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex",
                "dune"
            },
            root_dir = lsp.util.root_pattern("*.opam", "esy.json",
                                             "package.json", ".git",
                                             "dune-project", "dune-workspace"),
            -- grabbed from https://github.com/ocaml/ocaml-lsp/blob/3dc1a6633bfe2ebd34d7aa38f008c8c28300ee55/ocaml-lsp-server/docs/ocamllsp/config.md
            settings = {
                extendedHover = {enable = true},
                codelens = {enable = true},
                duneDiagnostics = {enable = true},
                inlayHints = {enable = true},
                syntaxDocumentation = {enable = true},
                merlinJumpCodeActions = {enable = true}
            }
        })

        lsp.lua_ls.setup({
            cmd = {"lua-language-server"},
            filetypes = {"lua"},
            root_dir = require("lspconfig").util.root_pattern("luarc.json",
                                                              "luarc.jsonc",
                                                              "luacheckrc",
                                                              ".stylua.toml",
                                                              "stylua.toml",
                                                              "selene.toml",
                                                              "selene.yml",
                                                              ".git"),
            single_file_support = true,
            log_level = vim.lsp.protocol.MessageType.Warning,
            settings = {
                Lua = {
                    telemetry = {enable = false},
                    completion = {
                        callSnippet = "Replace",
                        displayContext = 2,
                        keywordSnippet = "Both"
                    },
                    format = {enable = true},
                    codelens = {enable = true},
                    hint = {
                        enable = true,
                        arrayIndex = "Enable",
                        setType = true,
                        semicolon = "All"
                    },
                    diagnostics = {
                        enable = true,
                        disable = {"lowercase-global"},
                        globals = {"vim"}
                    },
                    hover = {
                        enumsLimit = 10,
                        expandAlias = true,
                        previewFields = 50,
                        viewNumber = true,
                        viewString = true,
                        viewStringMax = 200
                    },
                    misc = {
                        parameters = {},
                        executablePath = "/usr/bin/lua-language-server"

                    },
                    runtime = {
                        version = "LuaJIT",
                        path = {"?.lua", "../init.lua", "?/init.lua"}
                    },
                    workspace = {
                        checkThirdParty = "ApplyInMemory",
                        library = {
                            vim.env.VIMRUNTIME, "${3rd}/luv/library",
                            "/usr/share/lua/5.4/luarocks",
                            "~/.local/share/nvim/lazy"
                        }
                    }
                }
            },
            capabilities = capabilities,
            on_attach = on_attach
        })

        lsp.gopls.setup({
            cmd = {"gopls"},
            filetypes = {"go", "gomod", "gowork", "gotmpl"},
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
                        rangeVariableTypes = true
                    }
                }
            },
            capabilities = capabilities,
            on_attach = on_attach
        })

        lsp.zls.setup({
            cmd = {"zls"},
            on_new_config = function(new_config, new_root_dir)
                if vim.fn
                    .filereadable(vim.fs.joinpath(new_root_dir, "zls.json")) ~=
                    0 then
                    new_config.cmd = {"zls", "--config-path", "zls.json"}
                end
            end,
            filetypes = {'zig', 'zir'},
            root_dir = require("lspconfig").util.root_pattern("zls.json",
                                                              "build.zig",
                                                              ".git"),
            single_file_support = true,
            capabilities = capabilities,
            on_attach = on_attach
        })

        lsp.clangd.setup({
            cmd = {
                'clangd', '--clang-tidy', '--header-insertion=iwyu',
                '--completion-style=detailed', '--fallback-style=none',
                '--function-arg-placeholders=false'
            },
            filetypes = {"c", "cpp", "objc", "objcpp", "cuda", "proto"},
            root_dir = function(fname)
                local util = require("lspconfig").util
                return util.root_pattern(".clangd", ".clang-tidy",
                                         ".clang-format",
                                         "compile_commands.json",
                                         "compile_flags.txt", "configure.ac")(
                           fname) or
                           vim.fs
                               .dirname(
                               vim.fs
                                   .find(".git", {path = fname, upward = true})[1])
            end,
            single_file_support = true,
            capabilities = {
                textDocument = {completion = {editsNearCursor = true}},
                offsetEncoding = {"utf-8", "utf-16"}
            },
            on_attach = on_attach
        })

        lsp.rust_analyzer.setup({
            cmd = {'rust-analyzer'},
            filetypes = {'rust'},
            root_markers = {'Cargo.toml', 'rust-project.json'},
            settings = {
                ['rust-analyzer'] = {
                    inlayHints = {
                        -- These are a bit too much.
                        chainingHints = {enable = false}
                    }
                }
            },
            capabilities = capabilities,
            on_attach = on_attach
        })

        lsp.hls.setup({
            cmd = {"haskell-language-server-wrapper", "--lsp"},
            filetypes = {"haskell", "lhaskell"},
            root_dir = require("lspconfig").util.root_pattern("hie.yaml",
                                                              "stack.yaml",
                                                              "cabal.project",
                                                              "*.cabal",
                                                              "package.yaml"),
            single_file_support = true,
            settings = {
                haskell = {
                    cabalFormattingProvider = "cabalfmt",
                    formattingProvider = "ormolu"
                }
            },
            capabilities = capabilities,
            on_attach = on_attach
        })

        lsp.pyright.setup({
            on_new_config = function(new_config)
                local get_pipenv_venv_path = function()
                    local pipenv_venv = vim.fn.trim(vim.fn.system(
                                                        "pipenv --venv"))
                    if pipenv_venv == "" then return nil end
                    local split = vim.split(pipenv_venv, "\n")
                    for _, line in ipairs(split) do
                        if string.match(line, "^/") ~= nil then
                            if vim.fn.isdirectory(line) then
                                return line
                            end
                        end
                    end

                    return nil
                end
                local get_python_path = function()
                    local venv_path = get_pipenv_venv_path()
                    if venv_path ~= nil then
                        return venv_path .. "/bin/python"
                    else
                        return vim.fn.trim(vim.fn.system(
                                               "python -c 'import sys; print(sys.executable)'"))
                    end
                end
                local python_path = get_python_path()
                if python_path ~= nil then
                    new_config.settings.python.pythonPath = python_path
                end
            end,
            settings = {
                pyright = {
                    disableOrganizeImports = false,
                    analysis = {
                        useLibraryCodeForTypes = true,
                        autoSearchPaths = true,
                        diagnosticMode = "workspace",
                        autoImportCompletions = true
                    }
                }
            },
            capabilities = capabilities,
            on_attach = on_attach
        })

        lsp.fish_lsp.setup({
            cmd = {"fish-lsp", "start"},
            cmd_env = {fish_lsp_show_client_popups = false},
            filetypes = {"fish"},
            root_dir = function(fname)
                return vim.fs.dirname(vim.fs.find(".git",
                                                  {path = fname, upward = true})[1])
            end,
            single_file_support = true,
            capabilities = capabilities,
            on_attach = on_attach
        })

        lsp.yamlls.setup({
            cmd = {"yaml-language-server", "--stdio"},
            filetypes = {"yaml"},
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                yaml = {
                    -- Using the schemastore plugin for schemas.
                    schemastore = {enable = false, url = ''},
                    schemas = require('schemastore').yaml.schemas()
                }
            }
        })

        lsp.html.setup({
            cmd = {'vscode-html-language-server', '--stdio'},
            filetypes = {'html'},
            embeddedLanguages = {css = true, javascript = true},
            capabilities = capabilities,
            on_attach = on_attach
        })

        lsp.jsonls.setup({
            cmd = {'vscode-json-language-server', '--stdio'},
            filetypes = {'json', 'jsonc'},
            settings = {
                json = {
                    validate = {enable = true},
                    schemas = require('schemastore').json.schemas()
                }
            },
            capabilities = capabilities,
            on_attach = on_attach
        })

        lsp.ts_ls.setup({
            init_options = {hostInfo = "neovim"},
            cmd = {"typescript-language-server", "--stdio"},
            filetypes = {
                "javascript", "javascriptreact", "javascript.jsx", "typescript",
                "typescriptreact", "typescript.tsx"
            },
            root_dir = require("lspconfig").util.root_pattern("tsconfig.json",
                                                              "jsconfig.json",
                                                              "package.json",
                                                              ".git"),
            single_file_support = true,
            capabilities = capabilities,
            on_attach = on_attach
        })

        lsp.hyprls.setup({capabilities = capabilities, on_attach = on_attach})

        lsp.elixirls.setup({capabilities = capabilities, on_attach = on_attach})

        lsp.fortls.setup({capabilities = capabilities, on_attach = on_attach})

        lsp.sqlls.setup({capabilities = capabilities, on_attach = on_attach})

        lsp.lemminx.setup({capabilities = capabilities, on_attach = on_attach})

        lsp.serve_d.setup({capabilities = capabilities, on_attach = on_attach})

        lsp.qmlls.setup({capabilities = capabilities, on_attach = on_attach})

        lsp.postgres_lsp.setup({
            capabilities = capabilities,
            on_attach = on_attach
        })
        lsp.taplo.setup({
            cmd = {'taplo', 'lsp', 'stdio'},
            filetypes = {'toml'},
            root_markers = {'.git'},
            capabilities = capabilities,
            on_attach = on_attach,

            settings = {
                -- Use the defaults that the VSCode extension uses: https://github.com/tamasfe/taplo/blob/2e01e8cca235aae3d3f6d4415c06fd52e1523934/editors/vscode/package.json
                taplo = {
                    configFile = {enabled = true},
                    schema = {
                        enabled = true,
                        catalogs = {
                            'https://www.schemastore.org/api/json/catalog.json'
                        },
                        cache = {memoryExpiration = 60, diskExpiration = 600}
                    }
                }
            }
        })

        lsp.eslint.setup({
            cmd = {'vscode-eslint-language-server', '--stdio'},
            filetypes = {
                'javascript', 'javascriptreact', 'typescript',
                'typescriptreact', 'graphql'
            },
            root_markers = {
                '.eslintrc', '.eslintrc.js', '.eslintrc.json',
                'eslint.config.js', 'eslint.config.mjs'
            },
            -- Using roughly the same defaults as nvim-lspconfig: https://github.com/neovim/nvim-lspconfig/blob/d3ad666b7895f958d088cceb6f6c199672c404fe/lua/lspconfig/configs/eslint.lua#L70
            settings = {
                validate = 'on',
                packageManager = nil,
                useESLintClass = false,
                experimental = {useFlatConfig = false},
                codeActionOnSave = {enable = false, mode = 'all'},
                format = false,
                quiet = false,
                onIgnoredFiles = 'off',
                options = {},
                rulesCustomizations = {},
                run = 'onType',
                problems = {shortenToSingleLine = false},
                nodePath = '',
                workingDirectory = {mode = 'location'},
                codeAction = {
                    disableRuleComment = {
                        enable = true,
                        location = 'separateLine'
                    },
                    showDocumentation = {enable = true}
                }
            },
            capabilities = capabilities,
            on_attach = on_attach,
            before_init = function(params, config)
                -- Set the workspace folder setting for correct search of tsconfig.json files etc.
                config.settings.workspaceFolder = {
                    uri = params.rootPath,
                    name = vim.fn.fnamemodify(params.rootPath, ':t')
                }
            end,
            ---@type table<string, lsp.Handler>
            handlers = {
                ['eslint/openDoc'] = function(_, params)
                    vim.ui.open(params.url)
                    return {}
                end,
                ['eslint/probeFailed'] = function()
                    vim.notify('LSP[eslint]: Probe failed.', vim.log.levels.WARN)
                    return {}
                end,
                ['eslint/noLibrary'] = function()
                    vim.notify('LSP[eslint]: Unable to load ESLint library.',
                               vim.log.levels.WARN)
                    return {}
                end
            }
        })
    end
}
