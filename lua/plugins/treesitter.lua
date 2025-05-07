return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = {"BufReadPre", "BufNewFile"},
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "windwp/nvim-ts-autotag"
        },
        -- init = function()
        --   vim.api.nvim_set_var("enfocado_plugins", { "surround" })
        -- end,
        config = function()
            -- import nvim-treesitter plugin
            local treesitter = require("nvim-treesitter.configs")

            -- configure treesitter
            treesitter.setup({
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = true
                },
                -- enable indentation
                indent = {enable = true},
                -- ensure following languages are covered
                ensure_installed = {
                    "json", "yaml", "html", "css", "markdown",
                    "markdown_inline", "comment", "fish", "bash", "go", "gomod",
                    "gosum", "rust", "haskell", "python", "lua", "vim",
                    "gitignore", "ocaml", "ocaml_interface", "qmldir",
                    "hyprlang", "json", "jsonc", "typescript", "fortran", "c",
                    "cpp", "dart", "elixir", "erlang", "java", "javascript",
                    "r", "toml", "xml", "yaml", "zig", "d"
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = false,
                        node_decremental = false
                    }
                },
                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = true,

                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = true,
                ignore_install = {},
                modules = {},

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["<leader>ts"] = "@parameter.outer",
                            ["<leader>tg"] = "@parameter.inner",
                            ["<leader>tfs"] = "@function.outer",
                            ["<leader>tfg"] = "@function.inner",
                            ["<leader>tcs"] = "@class.outer",
                            ["<leader>tcg"] = "@class.inner"
                        }
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["C-f"] = "@function.outer",
                            ["]]"] = "@class.outer"
                        },
                        goto_next_end = {
                            ["A-f"] = "@function.outer",
                            ["<leader>c]"] = "@class.outer"
                        },
                        goto_previous_start = {
                            ["C-F"] = "@function.outer",
                            ["<leader>c["] = "@class.outer"
                        },
                        goto_previous_end = {
                            ["A-F"] = "@function.outer",
                            ["[]"] = "@class.outer"
                        }
                    }
                }
            })
        end
    }
}
