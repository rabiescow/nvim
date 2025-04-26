return {
    "stevearc/conform.nvim",
    event = {"BufWritePre", "BufReadPre", "BufNewFile"},
    cmd = {"ConformInfo"},
    keys = {
        {
            -- Customize or remove this keymap to your liking
            "<leader>f",
            function()
                require("conform").format({async = true, lsp_fallback = true})
            end,
            mode = "",
            desc = "Format buffer"
        }
    },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        ft_parsers = {jsonc = "json"},
        formatters_by_ft = {
            dart = {"dart"},
            dune = {"format-dune-file"},
            elm = {"elm-format"},
            fish = {"fish_indent"},
            go = {"goimports", "gofmt", "golines"},
            haskell = {"hindent"},
            java = {"google-java-format"},
            json = {"fixjson", "jq"},
            lua = {"lua-format", "stylua"},
            markdown = {"markdownlint"},
            ocaml = {"ocp-indent", "ocamlformat"},
            python = {"isort"},
            rust = {"rustfmt", lsp_format = "fallback"},
            toml = {"taplo"},
            xml = {"xmlformatter", "xmllint"},
            yaml = {"yamlfix", "yamlfmt"},
            zig = {"zigfmt"}
        },
        default_format_opts = {lsp_format = "fallback", stop_after_first = true},
        format_on_save = {lsp_format = "fallback", timeout_ms = 500},
        format_after_save = {lsp_format = "fallback"},
        notify_on_error = true,
        notify_no_formatters = true,
        formatters = {
            ocamlformat = {
                prepend_args = {
                    "--if-then-else", "--vertical", "--break-cases",
                    "fit-or-vertical", "--type-decl", "--sparse"
                }
            },
            dart = {prepend_args = {"format"}}
        }
    },
    init = function()
        vim.o.formatexpr = "v:lua.require.'conform'.formatexpr()"
    end
}
