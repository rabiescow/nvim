return {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    config = function()
        local M = require("catppuccin")
        local U = require("catppuccin.utils.colors")
        M.setup({
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            background = {light = "latte", dark = "mocha"},
            transparent_background = false,
            show_end_of_buffer = false,
            term_colors = false,
            dim_inactive = {enabled = false, shade = "dark", percentage = 0.15},
            no_italic = false,
            no_bold = false,
            no_underline = false,
            styles = {
                comments = {"italic"},
                conditionals = {"italic"},
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {}
            },
            color_overrides = {},
            custom_highlights = function(colors)
                return {
                    -- ocaml
                    ["@constructor.ocaml"] = {fg = colors.flamingo},
                    ["@punctuation.delimiter.ocaml"] = {fg = colors.flamingo},
                    ["@keyword.ocaml"] = {
                        fg = colors.peach,
                        style = {"bold", "italic"}
                    },
                    ["@keyword.function.ocaml"] = {
                        fg = colors.peach,
                        bold = true,
                        italic = true
                    },
                    ["@keyword.import.ocaml"] = {fg = colors.maroon},
                    ["@keyword.module.open.ocaml"] = {fg = colors.maroon},
                    ["@keyword.module.name.ocaml"] = {fg = colors.maroon},
                    ["@keyword.type.ocaml"] = {fg = colors.pink},
                    ["@variable.ocaml"] = {link = "Function"},

                    ["@lsp.type.keyword.zig"] = {
                        fg = colors.peach,
                        bold = true
                        -- italic = true
                    },
                    ["@lsp.typemod.struct.declaration.zig"] = {
                        fg = colors.maroon
                    },
                    ["@lsp.typemod.variable.declaration.zig"] = {
                        fg = colors.maroon
                    },
                    ["@lsp.typemod.function.declaration.zig"] = {
                        fg = colors.blue,
                        italic = true
                    },
                    ["@lsp.type.namespace.zig"] = {
                        fg = colors.pink,
                        italic = true
                    },
                    ["DiagnosticUnderlineError"] = {
                        fg = colors.base,
                        bg = colors.red
                    },
                    ["DiagnosticUnderlineWarning"] = {
                        fg = colors.base,
                        bg = colors.peach
                    },
                    ["DiagnosticUnderlineHint"] = {
                        fg = colors.base,
                        bg = colors.teal
                    },
                    ["DiagnosticUnderlineInfo"] = {
                        fg = colors.base,
                        bg = colors.blue
                    },

                    LspCodeLens = {fg = colors.hint, bold = true, italic = true}, -- virtual text of the codelens
                    LspInlayHint = {fg = colors.hint, italic = true}, -- virtual text of the inlay hints
                    CursorLine = {
                        fg = U.brighten(colors.lavender, 0.3, colors.text),
                        bg = U.darken(colors.surface0, 0.2, colors.base)
                    }
                }
            end,
            default_integrations = true,
            integrations = {
                blink_cmp = true,
                diffview = true,
                fidget = false,
                gitsigns = true,
                indent_blankline = {
                    enabled = true,
                    scope_color = "surface2",
                    colored_indent_levels = false
                },
                lualine = require('lualine').setup {
                    options = {theme = "catppuccin"}
                },
                treesitter = true,
                mini = {enabled = true, indentscope_color = ""},
                native_lsp = {enabled = true, inlay_hints = {background = true}}
            }
        })
        return M
    end
}
