return {
    "j-hui/fidget.nvim",
    config = function()
        require("fidget").setup({
            -- Options related to LSP progress subsystem
            progress = {
                poll_rate = 0,
                suppress_on_insert = false,
                ignore_done_already = false,
                ignore_empty_message = false,
                clear_on_detach = function(client_id)
                    local function sleep(n)
                        os.execute("sleep " .. tonumber(n))
                    end
                    sleep(2)
                    local client = vim.lsp.get_client_by_id(client_id)
                    return client and client.name or nil
                end,
                notification_group = function(msg)
                    return msg.lsp_client.name
                end,
                ignore = {},

                -- Options related to how LSP progress messages are displayed as notifications
                display = {
                    render_limit = 16,
                    done_ttl = 3,
                    done_icon = "  󱓵 ",
                    done_style = "FidgetDone",
                    progress_ttl = math.huge,
                    progress_icon = {
                        -- {
                        --     " ⢰  ", " ⠸  ", " ⠘⠁ ", " ⠈⠉ ",
                        --     "  ⠙ ", "  ⠸ ", "  ⢰ ", "  ⣠ ", " ⢀⣀ ",
                        --     " ⢠⡀ "
                        -- }
                        {
                            "∙∙∙∙", "●∙∙∙", "∙●∙∙",
                            "∙∙●∙", "∙∙∙●"
                        }
                    },
                    progress_style = "FidgetSep",
                    group_style = "FidgetGroup",
                    icon_style = "FidgetIcon",
                    priority = 30,
                    skip_history = true,
                    format_message = require("fidget.progress.display").default_format_message,
                    format_annote = function(msg)
                        return msg.title
                    end,
                    format_group_name = function(group)
                        return tostring(group)
                    end,
                    overrides = {rust_analyzer = {name = "rust-analyzer"}}
                },

                -- Options related to Neovim's built-in LSP client
                lsp = {progress_ringbuf_size = 0, log_handler = false}
            },

            -- Options related to notification subsystem
            notification = {
                poll_rate = 10,
                filter = 0,
                history_size = 500,
                override_vim_notify = true,
                configs = {
                    name = "Notifications",
                    icon = "  󱓧 ",
                    ttl = 5,
                    group_style = "FidgetGroup",
                    icon_style = "FidgetIcon",
                    annote_style = "FidgetNormal",
                    debug_style = "FidgetNormal",
                    info_style = "FidgetIcon",
                    warn_style = "WarningMsg",
                    error_style = "ErrorMsg",
                    debug_annote = "DEBUG",
                    info_annote = "FidgetNormal",
                    warn_annote = "WARN",
                    error_annote = "ERROR",
                    update_hook = function(item)
                        require("fidget.notification").set_content_key(item)
                    end
                },
                redirect = function(msg, level, opts)
                    if opts and opts.on_open then
                        return
                            require("fidget.integration.nvim-notify").delegate(
                                msg, level, opts)
                    end
                end,

                -- Options related to how notifications are rendered as text
                view = {
                    stack_upwards = true,
                    icon_separator = " ",
                    group_separator = "╰──────╮",
                    group_separator_hl = "FidgetSep",
                    render_message = function(msg, cnt)
                        return cnt == 1 and msg or
                                   string.format("(%dx) %s", cnt, msg)
                    end
                },

                -- Options related to the notification window and buffer
                window = {
                    normal_hl = "FidgetNormal",
                    winblend = 0,
                    border = "none",
                    zindex = 122245,
                    max_width = 0,
                    max_height = 0,
                    x_padding = 3,
                    y_padding = 1,
                    align = "top",
                    relative = "editor"
                }
            },

            -- Options related to integrating with other plugins
            integration = {},

            -- Options related to logging
            logger = {
                level = vim.log.levels.WARN,
                max_size = 10000,
                float_precision = 0.01,
                path = string.format("%s/fidget.nvim.log",
                                     vim.fn.stdpath("cache"))
            }
        })
    end
}
