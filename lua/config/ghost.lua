-- Hey, man, this is the whole setup. We gotta return it at the end.
local M = {}

-- This is where we keep track of the ghost window so we can make it disappear
local hover_diag_win = {win_id = nil, buf_id = nil}

-- POOF! This makes the window vanish. Now you see it, now you don't.
local function clear_hover_diagnostic_float()
    if hover_diag_win.win_id and
        vim.api.nvim_win_is_valid(hover_diag_win.win_id) then
        vim.api.nvim_win_close(hover_diag_win.win_id, true) -- true means RIGHT NOW, man.
    end
    if hover_diag_win.buf_id and
        vim.api.nvim_buf_is_valid(hover_diag_win.buf_id) then
        vim.api.nvim_buf_delete(hover_diag_win.buf_id, {force = true})
    end
    hover_diag_win.win_id = nil
    hover_diag_win.buf_id = nil
end

-- This is the real magic. This makes the ghost window appear with the secrets.
local function show_hover_diagnostic_float()
    clear_hover_diagnostic_float() -- Always get rid of the old ghost first.

    local current_win = vim.api.nvim_get_current_win()
    local current_buf = vim.api.nvim_win_get_buf(current_win)

    -- Don't bother if the buffer is weird or you can't type in it.
    if not vim.api.nvim_buf_is_valid(current_buf) or
        vim.fn.getbufvar(current_buf, '&modifiable') == 0 then return end

    local cursor_line = vim.api.nvim_win_get_cursor(current_win)[1] - 1 -- 0-indexed line number

    -- Grab the signals for the line you're on. All of 'em.
    local diagnostics_on_line = vim.diagnostic.get(current_buf,
                                                   {lnum = cursor_line})

    if not diagnostics_on_line or vim.tbl_isempty(diagnostics_on_line) then
        return -- No signal? Nothing to show. Move along.
    end

    -- We're gonna stack the messages, man, one on top of the other.
    local lines_for_float = {}
    local max_line_width = 0
    for _, diag in ipairs(diagnostics_on_line) do
        local message = diag.message:gsub("[\n\r]+", " ") -- Flatten messages so they don't get weird.
        table.insert(lines_for_float, message)
        max_line_width = math.max(max_line_width,
                                  vim.fn.strdisplaywidth(message))
    end

    if vim.tbl_isempty(lines_for_float) then return end

    -- Gotta figure out how big to make the ghost. Can't be too big.
    local parent_win_width = vim.api.nvim_win_get_width(current_win)
    local float_width = math.min(max_line_width + 2,
                                 math.floor(parent_win_width * 0.5)) -- Half the screen width, tops.
    local float_height = #lines_for_float

    -- Make a secret buffer just for the ghost.
    hover_diag_win.buf_id = vim.api.nvim_create_buf(false, true) -- not listed, scratch buffer
    vim.api.nvim_buf_set_lines(hover_diag_win.buf_id, 0, -1, false,
                               lines_for_float)
    vim.api.nvim_buf_set_option(hover_diag_win.buf_id, 'modifiable', false)

    -- Now, the real trick. Open the ghost window.
    hover_diag_win.win_id = vim.api.nvim_open_win(hover_diag_win.buf_id, false,
                                                  {
        relative = 'win', -- Relative to the window you're in
        win = current_win,
        anchor = 'NE', -- North-East corner, man, top-right!
        width = float_width,
        height = float_height,
        row = 0, -- Top row
        col = parent_win_width, -- Rightmost column
        style = 'minimal',
        border = 'none', -- NO BORDER. That's the key. No one can see the edges.
        focusable = false, -- Can't even click on it. It's not real.
        zindex = 150 -- Make sure it's on top of everything else.
    })
end

-- This is the setup function. You gotta call this from your main config.
function M.setup()
    -- This here is the lookout. It sees everything.
    local hover_diag_augroup = vim.api.nvim_create_augroup(
                                   "MyGhostlyHoverDiagnostics", {clear = true})

    -- The lookout that watches for when you stop moving your cursor.
    vim.api.nvim_create_autocmd("CursorHold", {
        group = hover_diag_augroup,
        pattern = "*",
        callback = show_hover_diagnostic_float,
        desc = "Show ghost diagnostics on hover"
    })

    -- This one watches for when you move again, so it can make the ghost disappear. Poof.
    vim.api.nvim_create_autocmd({"CursorMoved", "BufLeave", "ModeChanged"}, {
        group = hover_diag_augroup,
        pattern = "*",
        callback = clear_hover_diagnostic_float,
        desc = "Clear ghost diagnostics on activity"
    })

    print("The ghost is watching for diagnostics, man...") -- So you know it's working
end

return M
