vim.api.nvim_create_autocmd({"BufWritePre"}, {
    group = vim.api.nvim_create_augroup("UpdateTimestampOnBackup",
                                        {clear = true}),
    callback = function()
        vim.o.backupext = "." .. vim.fn.strftime("%Y%m%d_%H%m%s") .. ".tmp"
    end
})

vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("OilOnUserEventForStartup",
                                        {clear = true}),
    pattern = "StartupNvimReady",
    callback = function(args)
        print("User event '" .. args.match .. "' triggered!")

        local oil_is_already_open = false
        for _, winid in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_is_valid(winid) then
                local buf_in_win = vim.api.nvim_win_get_buf(winid)
                if vim.api.nvim_buf_is_valid(buf_in_win) and
                    vim.bo[buf_in_win].filetype == 'oil' then
                    oil_is_already_open = true
                    break
                end
            end
        end

        if not oil_is_already_open then
            vim.schedule(function() vim.cmd("Oil --float") end)
        end
    end,
    desc = "Open Oil in a float when the startup dashboard is ready"
})

vim.api.nvim_create_autocmd({"BufEnter", "CursorHold"}, {
    buffer = 0,
    group = vim.api.nvim_create_augroup("LspDiagnostics", {clear = true}),

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
        local _, windownr = vim.diagnostic.open_float(hoverOpts, secondaryOpts)
        if windownr ~= nil then
            local config = vim.api.nvim_win_get_config(windownr)
            config = vim.tbl_extend("force", config, dialog)
            vim.api.nvim_win_set_config(windownr, config)
        end
    end
})

-- highlight last yank
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "highlight when yanking text",
    group = vim.api.nvim_create_augroup("yanker", {clear = true}),
    callback = function()
        vim.highlight.on_yank({higroup = "CurSearch", timeout = 1000})
    end
})

vim.api.nvim_create_autocmd({'BufDelete', 'BufWipeout'}, {
    group = vim.api.nvim_create_augroup('wshada_on_delete', {clear = true}),
    desc = 'Write to ShaDa when deleting/wiping out buffers',
    command = 'wshada'
})

-- local hover_diag_notify_augroup = vim.api.nvim_create_augroup(
--                                       "CustomHoverDiagnosticsNotify",
--                                       {clear = true})
--
-- vim.api.nvim_create_autocmd("CursorHold", {
--     group = hover_diag_notify_augroup,
--     pattern = "*",
--     callback = show_hover_diagnostic_via_notify,
--     desc = "Show diagnostics via notify on hover"
-- })
