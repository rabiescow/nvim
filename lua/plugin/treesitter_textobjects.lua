return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = true,
    config = function()
        require("nvim-treesitter.configs").setup({
            textobjects = {
                select = {
                    enable = true,

                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true
                },
                swap = {
                    enable = true,
                    swap_previous = {
                        ["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
                        ["<leader>p:"] = "@property.outer", -- swap object property with prev
                        ["<leader>pm"] = "@function.outer" -- swap function with previous
                    },
                    swap_next = {
                        ["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
                        ["<leader>n:"] = "@property.outer", -- swap object property with next
                        ["<leader>nm"] = "@function.outer" -- swap function with next
                    }
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["]f"] = {
                            query = "@call.outer",
                            desc = "Next function call start"
                        },
                        ["]m"] = {
                            query = "@function.outer",
                            desc = "Next method/function def start"
                        },
                        ["]c"] = {
                            query = "@class.outer",
                            desc = "Next class start"
                        },
                        ["]i"] = {
                            query = "@conditional.outer",
                            desc = "Next conditional start"
                        },
                        ["]l"] = {
                            query = "@loop.outer",
                            desc = "Next loop start"
                        },

                        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                        ["]s"] = {
                            query = "@scope",
                            query_group = "locals",
                            desc = "Next scope"
                        },
                        ["]z"] = {
                            query = "@fold",
                            query_group = "folds",
                            desc = "Next fold"
                        }
                    },
                    goto_next_end = {
                        ["]F"] = {
                            query = "@call.outer",
                            desc = "Next function call end"
                        },
                        ["]M"] = {
                            query = "@function.outer",
                            desc = "Next method/function def end"
                        },
                        ["]C"] = {
                            query = "@class.outer",
                            desc = "Next class end"
                        },
                        ["]I"] = {
                            query = "@conditional.outer",
                            desc = "Next conditional end"
                        },
                        ["]L"] = {query = "@loop.outer", desc = "Next loop end"}
                    },
                    goto_previous_start = {
                        ["[f"] = {
                            query = "@call.outer",
                            desc = "Prev function call start"
                        },
                        ["[m"] = {
                            query = "@function.outer",
                            desc = "Prev method/function def start"
                        },
                        ["[c"] = {
                            query = "@class.outer",
                            desc = "Prev class start"
                        },
                        ["[i"] = {
                            query = "@conditional.outer",
                            desc = "Prev conditional start"
                        },
                        ["[l"] = {
                            query = "@loop.outer",
                            desc = "Prev loop start"
                        }
                    },
                    goto_previous_end = {
                        ["[F"] = {
                            query = "@call.outer",
                            desc = "Prev function call end"
                        },
                        ["[M"] = {
                            query = "@function.outer",
                            desc = "Prev method/function def end"
                        },
                        ["[C"] = {
                            query = "@class.outer",
                            desc = "Prev class end"
                        },
                        ["[I"] = {
                            query = "@conditional.outer",
                            desc = "Prev conditional end"
                        },
                        ["[L"] = {query = "@loop.outer", desc = "Prev loop end"}
                    }
                },
                lsp_interop = {
                    enable = true,
                    border = 'none',
                    floating_preview_opts = {},
                    peek_definition_code = {
                        ["<leader>df"] = "@function.outer",
                        ["<leader>dF"] = "@class.outer"
                    }
                }
            }
        })

        local ts_repeat_move = require(
                                   "nvim-treesitter.textobjects.repeatable_move")

        -- vim way: ; goes to the direction you were moving.
        vim.keymap.set({"n", "x", "o"}, ";", ts_repeat_move.repeat_last_move)
        vim.keymap.set({"n", "x", "o"}, ",",
                       ts_repeat_move.repeat_last_move_opposite)

        -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
        vim.keymap.set({"n", "x", "o"}, "f", ts_repeat_move.builtin_f)
        vim.keymap.set({"n", "x", "o"}, "F", ts_repeat_move.builtin_F)
        vim.keymap.set({"n", "x", "o"}, "t", ts_repeat_move.builtin_t)
        vim.keymap.set({"n", "x", "o"}, "T", ts_repeat_move.builtin_T)
    end
}
