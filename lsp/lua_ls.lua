return {
    cmd = {"lua-language-server"},
    filetypes = {"lua"},
    root_markers = {
        ".git", ".luacheckrc", ".luarc.json", ".luarc.jsonc", ".stylua.toml",
        "selene.toml", "selene.yml", "stylua.toml"
    },
    single_file_support = true,
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
                globals = {"vim", "require"}
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
                    "/usr/share/lua/5.4/luarocks"
                }
            }
        }
    },
    capabilities = get_complete_capabilities(),
    log_level = vim.lsp.protocol.MessageType.Warning,
    on_attach = function(client, bufnr)
        code_lens(client, bufnr)
        inlay_hints(client, bufnr)
        -- hover(client, bufnr)
    end
}

