-- return {}
return {
    "j-hui/fidget.nvim",
    config = function()
        require("fidget").setup({
            -- Options related to LSP progress subsystem
            progress = {
                poll_rate = 0, -- How and when to poll for progress messages
                suppress_on_insert = false, -- Suppress new messages while in insert mode
                ignore_done_already = false, -- Ignore new tasks that are already complete
                ignore_empty_message = false, -- Ignore new tasks that don't contain a message
                clear_on_detach = -- Clear notification group when LSP server detaches
                function(client_id)
                    local function sleep(n)
                        os.execute("sleep " .. tonumber(n))
                    end
                    sleep(2)
                    local client = vim.lsp.get_client_by_id(client_id)
                    return client and client.name or nil
                end,
                notification_group = -- How to get a progress message's notification group key
                function(msg) return msg.lsp_client.name end,
                ignore = {}, -- List of LSP servers to ignore

                -- Options related to how LSP progress messages are displayed as notifications
                display = {
                    render_limit = 16, -- How many LSP messages to show at once
                    done_ttl = 3, -- How long a message should persist after completion
                    done_icon = "◉︎", -- Icon shown when all LSP progress tasks are complete
                    done_style = "Constant", -- Highlight group for completed LSP tasks
                    progress_ttl = math.huge, -- How long a message should persist when in progress
                    progress_icon = -- Icon shown when LSP progress tasks are in progress
                    {{"", "", "", "", "", ""}},
                    progress_style = -- Highlight group for in-progress LSP tasks
                    "WarningMsg",
                    group_style = "Title", -- Highlight group for group name (LSP server name)
                    icon_style = "Question", -- Highlight group for group icons
                    priority = 30, -- Ordering priority for LSP notification group
                    skip_history = true, -- Whether progress notifications should be omitted from history
                    format_message = -- How to format a progress message
                    require("fidget.progress.display").default_format_message,
                    format_annote = -- How to format a progress annotation
                    function(msg) return msg.title end,
                    format_group_name = -- How to format a progress notification group's name
                    function(group) return tostring(group) end,
                    overrides = { -- Override options from the default notification config
                        rust_analyzer = {name = "rust-analyzer"}
                    }
                },

                -- Options related to Neovim's built-in LSP client
                lsp = {
                    progress_ringbuf_size = 0, -- Configure the nvim's LSP progress ring buffer size
                    log_handler = false -- Log `$/progress` handler invocations (for debugging)
                }
            },

            -- Options related to notification subsystem
            notification = {
                poll_rate = 10, -- How frequently to update and render notifications
                filter = vim.log.levels.INFO, -- Minimum notifications level
                history_size = 500, -- Number of removed messages to retain in history
                override_vim_notify = false, -- Automatically override vim.notify() with Fidget
                configs = {
                    name = "Notifications",
                    icon = " 󰎟 ",
                    ttl = 5,
                    group_style = "Title",
                    icon_style = "Special",
                    annote_style = "Question",
                    debug_style = "Comment",
                    info_style = "Question",
                    warn_style = "WarningMsg",
                    error_style = "ErrorMsg",
                    debug_annote = "DEBUG",
                    info_annote = "INFO",
                    warn_annote = "WARN",
                    error_annote = "ERROR",
                    update_hook = function(item)
                        require("fidget.notification").set_content_key(item)
                    end
                }, -- How to configure notification groups when instantiated
                redirect = -- Conditionally redirect notifications to another backend
                function(msg, level, opts)
                    if opts and opts.on_open then
                        return
                            require("fidget.integration.nvim-notify").delegate(
                                msg, level, opts)
                    end
                end,

                -- Options related to how notifications are rendered as text
                view = {
                    stack_upwards = true, -- Display notification items from bottom to top
                    icon_separator = " ", -- Separator between group name and icon
                    group_separator = "╰──────╮", -- Separator between notification groups
                    group_separator_hl = -- Highlight group used for group separator
                    "Comment",
                    render_message = -- How to render notification messages
                    function(msg, cnt)
                        return cnt == 1 and msg or
                                   string.format("(%dx) %s", cnt, msg)
                    end
                },

                -- Options related to the notification window and buffer
                window = {
                    normal_hl = "Comment", -- Base highlight group in the notification window
                    winblend = 100, -- Background color opacity in the notification window
                    border = "none", -- Border around the notification window
                    zindex = 45, -- Stacking priority of the notification window
                    max_width = 0, -- Maximum width of the notification window
                    max_height = 0, -- Maximum height of the notification window
                    x_padding = 1, -- Padding from right edge of window boundary
                    y_padding = 0, -- Padding from bottom edge of window boundary
                    align = "bottom", -- How to align the notification window
                    relative = "editor" -- What the notification window position is relative to
                }
            },

            -- Options related to integrating with other plugins
            integration = {},

            -- Options related to logging
            logger = {
                level = vim.log.levels.WARN, -- Minimum logging level
                max_size = 10000, -- Maximum log file size, in KB
                float_precision = 0.01, -- Limit the number of decimals displayed for floats
                path = -- Where Fidget writes its logs to
                string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache"))
            }
        })
    end
}
