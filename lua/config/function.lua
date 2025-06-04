function show_hover_diagnostic_via_notify()
    local current_win = vim.api.nvim_get_current_win()
    local current_buf = vim.api.nvim_win_get_buf(current_win)

    if not vim.api.nvim_buf_is_valid(current_buf) or
        vim.fn.getbufvar(current_buf, '&modifiable') == 0 then return end

    local cursor_pos = vim.api.nvim_win_get_cursor(current_win)
    local cursor_line_0idx = cursor_pos[1] - 1

    local diagnostics_on_line = vim.diagnostic.get(current_buf, {
        lnum = cursor_line_0idx,
        severity = {min = vim.diagnostic.severity.HINT}
    })

    if not diagnostics_on_line or vim.tbl_isempty(diagnostics_on_line) then
        return -- No diagnostics on this line
    end

    local lines_for_notification = {}
    local max_messages_to_show = 3 -- Limit the number of messages in one notification

    for i = 1, math.min(#diagnostics_on_line, max_messages_to_show) do
        local diag = diagnostics_on_line[i]
        local severity_char = " "
        if diag.severity == vim.diagnostic.severity.ERROR then
            severity_char = " "
        elseif diag.severity == vim.diagnostic.severity.WARN then
            severity_char = " "
        elseif diag.severity == vim.diagnostic.severity.INFO then
            severity_char = " "
        elseif diag.severity == vim.diagnostic.severity.HINT then
            severity_char = "󰠠 "
        end
        -- Each diagnostic message becomes a line in our final string
        table.insert(lines_for_notification,
                     string.format("%s %s", severity_char, diag.message))
    end

    if vim.tbl_isempty(lines_for_notification) then return end

    -- Combine all messages into a single string with newlines
    local notification_message = table.concat(lines_for_notification, "\n")

    -- Determine the highest severity for the notification level
    local highest_severity = vim.diagnostic.severity.HINT
    for _, diag in ipairs(diagnostics_on_line) do
        if diag.severity < highest_severity then -- Lower number means higher severity
            highest_severity = diag.severity
        end
    end
    -- Show the notification
    vim.notify(notification_message, vim.diagnostic.severity.HINT, {
        title = "Diagnostics on Hover" -- Optional title
        -- Other options depend on your notification plugin (e.g., timeout, icon)
    })
end

function hover(client, bufnr)
    if client.server_capabilities.hoverProvider then
        local augroup = vim.api.nvim_create_augroup("LspHoverMode",
                                                    {clear = true})
        local event = {"CursorHold", "InsertLeave", "BufEnter"}
        local close = {"CursorMoved", "InsertEnter"}
        local hover = require("config.hover")
        local opts = {
            wrap = true,
            close_events = close,
            focusable = false,
            focus = false,
            offset_x = 25,
            offset_y = 0,
            border = "single",
            title = "Definition",
            title_pos = "center"
        }
        vim.api.nvim_create_autocmd(event,
                                    {
            buffer = bufnr,
            group = augroup,
            callback = function() hover.hover(opts) end
        })
    end
end

function inline_float_diagnostics(_, bufnr)
    -- Hover Provider config
    local augroup = vim.api
                        .nvim_create_augroup("LspDiagnostics", {clear = true})
    local event = {"BufEnter", "CursorHold"}
    vim.api.nvim_create_autocmd(event, {
        buffer = bufnr,
        group = augroup,

        callback = function()
            local currentWidth, _ = get_editor_dimensions()
            local diagnosticsWidth = math.floor(math.abs(currentWidth / 2))
            local diagnosticsHeight = 8
            local diagnosticsColumn = currentWidth - (diagnosticsWidth + 3)
            local diagnosticsRow = get_diagnostics_position(diagnosticsHeight)
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

function code_lens(client, bufnr)
    local augroup = vim.api.nvim_create_augroup("LSPCodeLens", {clear = true})
    local codelens = require("config.codelens")

    -- Code Lens provider config
    if client.server_capabilities.codeLensProvider then
        vim.api
            .nvim_create_autocmd( -- {"BufEnter", "InsertLeave", "LspAttach"}, {
        {"SafeState"}, {
            buffer = bufnr,
            group = augroup,
            callback = function()
                codelens.refresh()
                local lenses = codelens.get(bufnr)
                codelens.display(lenses, bufnr, client.id)
            end
        })
    end
end

function inlay_hints(client, bufnr)
    local augroup = vim.api.nvim_create_augroup("LSPInlayHint", {clear = true})
    -- Inlay Hint provider config
    -- Only turn on inlay hints when not in Insert mode
    if client.server_capabilities.inlayHintProvider then
        vim.api.nvim_create_autocmd({"BufEnter", "InsertLeave", "LspAttach"}, {
            buffer = bufnr,
            group = augroup,
            callback = function()
                vim.g.inlay_hints_visible = true
                vim.lsp.inlay_hint.enable(true, {bufnr})
            end
        })
        vim.api.nvim_create_autocmd({"InsertEnter"}, {
            buffer = bufnr,
            group = augroup,
            callback = function()
                vim.g.inlay_hints_visible = false
                vim.lsp.inlay_hint.enable(false, {bufnr})
            end
        })
    else
        print("no inlay hints available")
    end
end
