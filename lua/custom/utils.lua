function Get_editor_dimensions()
    local statusline_height = 0
    local laststatus = vim.opt.laststatus:get()
    if laststatus == 2 or laststatus == 3 or
        (laststatus == 1 and #vim.api.nvim_tabpage_list_wins(0) > 1) then
        statusline_height = 1
    end

    local height = vim.opt.lines:get() -
                       (statusline_height + vim.opt.cmdheight:get())
    local width = vim.opt.columns:get()
    return width, height
end

---@param diagnosticsHeight integer
function Get_diagnostics_position(diagnosticsHeight)
    local display_top = nil
    local first_line = vim.fn.line("w0")
    local current_line = vim.api.nvim_win_get_cursor(0)[1]

    _, row_max = Get_editor_dimensions()
    local window_pos = vim.api.nvim_win_get_position(0)
    local cursor_pos = window_pos[1] + (current_line - first_line)

    if ((row_max / 2) < cursor_pos) then
        display_top = true
    else
        display_top = false
    end

    if display_top then
        return 0
    else
        return math.floor(math.abs(row_max - diagnosticsHeight - 2))
    end
end
