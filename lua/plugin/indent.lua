return {
    "lukas-reineke/indent-blankline.nvim",
    event = {"BufEnter"},
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
        enabled = true,
        debounce = 200,
        viewport_buffer = {min = 6000, max = 10000},
        indent = {
            char = "│",
            tab_char = nil,
            highlight = "IblIndent",
            smart_indent_cap = true,
            priority = 1,
            repeat_linebreak = true
        },
        whitespace = {
            highlight = "IblWhitespace",
            remove_blankline_trail = true
        },
        scope = {
            enabled = false,
            char = nil,
            show_start = true,
            show_end = true,
            show_exact_scope = true,
            injected_languages = true,
            highlight = "IblScope",
            priority = 1024,
            include = {node_type = {}},
            exclude = {
                language = {},
                node_type = {
                    ["*"] = {"source_file", "program"},
                    lua = "chunk",
                    python = "module",
                    ocaml = "module"
                }
            }
        },
        exclude = {
            filetypes = {
                "lspinfo", "packer", "checkhealth", "help", "man", "gitcommit",
                "TelescopePrompt", "TelescopeResults", ""
            },
            buftypes = {"terminal", "nofile", "quickfix", "prompt"}
        }
    }
}
