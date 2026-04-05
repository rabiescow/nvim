return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local lualine = require("lualine")

        local hide_in_width = function()
            return vim.fn.winwidth(0) > 80
        end

        local datetime = { "datetime", style = "%F %T" }

        local workspaces = require("utils.utils").lualine_workspace()

        local diff = {
            "diff",
            colored = true,
            diff_color = {
                added = "LuaLineDiffAdd",
                modified = "LuaLineDiffChange",
                removed = "LuaLineDiffDelete",
            },
            symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
            cond = hide_in_width,
        }

        local modes = {
            ["COMMAND"] = " COMMAND ",
            ["CONFIRM"] = " CONFIRM ",
            ["EX"] = " EX      ",
            ["INSERT"] = " INSERT  ",
            ["MORE"] = " MORE    ",
            ["NORMAL"] = " NORMAL  ",
            ["O-PENDING"] = "O-PENDING",
            ["REPLACE"] = " REPLACE ",
            ["S-BLOCK"] = " S-BLOCK ",
            ["S-LINE"] = " S-LINE  ",
            ["SELECT"] = " SELECT  ",
            ["SHELL"] = " SHELL   ",
            ["TERMINAL"] = " TERMINAL",
            ["V-BLOCK"] = " V-BLOCK ",
            ["V-LINE"] = " V-LINE  ",
            ["V-REPLACE"] = "V-REPLACE",
            ["VISUAL"] = " VISUAL  ",
        }

        local mode = {
            "mode",
            colored = true,
            fmt = function(str)
                if modes[str] then
                    return modes[str]
                else
                    return str
                end
            end,
        }

        local filetype = { "filetype", icons_enabled = true }

        local filename = {
            "filename",
            file_status = true,
            newfile_status = false,
            path = false,
            shorting_target = 40,
            symbols = {
                modified = "[+]",
                readonly = "[-]",
                unnamed = "[No Name]",
                newfile = "[New]",
            },
        }

        local branch = {
            "branch",
            icons_enabled = true,
            icon = { "", color = { fg = "white" }, bold = true },
        }

        local location = { "location", padding = 0 }

        local diagnostic = {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            sections = { "error", "warn", "info", "hint" },
            symbols = {
                error = " ",
                warn = " ",
                info = " ",
                hint = "󰠠 ",
            },
            colored = true,
            update_in_insert = true,
            always_visible = false,
        }

        local lsp = {
            "lsp_status",
            icon = "",
            symbols = {
                spinner = {
                    "∙∙∙",
                    "●∙∙",
                    "∙●∙",
                    "∙∙●",
                },
                done = "✓",
                separator = " ",
            },
            ignore_lsp = {},
        }

        local recording = {
            "recording",
            fmt = function(str)
                local reg = vim.fn.reg_recording()
                if reg ~= "" then
                    return "󰑋  RECORDING @" .. reg
                end
                return str
            end
        }

        lualine.setup({
            options = {
                icons_enabled = true,
                theme = "auto",
                transparent = false,
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = { statusline = {}, winbar = {} },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = true,
                refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
            },

            sections = {
                lualine_a = { mode },
                lualine_b = { workspaces, "encoding", filetype, location },
                lualine_c = { filename, recording },
                lualine_x = { branch, diff },
                lualine_y = { diagnostic, lsp },
                lualine_z = { datetime },
            },

            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_y = {},
                lualine_z = {},
            },
            inactive_winbar = {},
            extensions = {},
        })
    end,
}
