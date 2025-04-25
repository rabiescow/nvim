--- Get the current width and height of the editor window.
---
---@return number width
---@return number height
function Get_editor_dimensions()
  local statusline_height = 0
  local laststatus = vim.opt.laststatus:get()
  if laststatus == 2 or laststatus == 3
      or (laststatus == 1 and #vim.api.nvim_tabpage_list_wins(0) > 1)
  then
    statusline_height = 1
  end

  local height = vim.opt.lines:get() - (statusline_height + vim.opt.cmdheight:get())

  -- Does not account for &signcolumn or &foldcolumn, but there is no amazing way to get the
  -- actual "viewable" width of the editor
  --
  -- However, I cannot imagine that many people will render fidgets on the left side of their
  -- editor as it will more often overlay text
  local width = vim.opt.columns:get()

  return width, height
end

-- --- Compute the row, col, anchor for |nvim_open_win()| to align the window.
-- ---
-- --- (Thanks @levouh!)
-- ---
-- ---@return number       row
-- ---@return number       col
-- ---@return ("NE"|"SE")  anchor
-- function get_window_position()
--   local align_bottom, col, row, row_max
--   local first_line = vim.fn.line("w0")
--   local current_line = vim.api.nvim_win_get_cursor(0)[1]
--
--   local function should_align_bottom(cursor_pos, rows)
--     if M.options.align == "top" then
--       return false
--     elseif M.options.align == "bottom" then
--       return true
--     else
--       return cursor_pos <= (rows / 2)
--     end
--   end
--
--   if options.relative == "editor" then
--     col, row_max = M.get_editor_dimensions()
--     local window_pos = vim.api.nvim_win_get_position(0)
--     local cursor_pos = window_pos[1] + (current_line - first_line)
--     align_bottom = should_align_bottom(cursor_pos, row_max)
--
--     if align_bottom then
--       row = row_max
--     else
--       -- When the layout is anchored at the top, need to check &tabline height
--       local stal = vim.opt.showtabline:get()
--       local tabline_shown = stal == 2 or (stal == 1 and #vim.api.nvim_list_tabpages() > 1)
--       row = tabline_shown and 1 or 0
--     end
--   else -- fidget relative to "window" (currently unreachable)
--     local cursor_pos = current_line - first_line
--
--     col = vim.api.nvim_win_get_width(0)
--     row_max = vim.api.nvim_win_get_height(0)
--     if vim.fn.exists("+winbar") > 0 and vim.opt.winbar:get() ~= "" then
--       -- When winbar is set, effective win height is reduced by 1 (see :help winbar)
--       row_max = row_max - 1
--     end
--     align_bottom = should_align_bottom(cursor_pos, row_max)
--
--     row = align_bottom and row_max or 1
--   end
--
--   col = math.max(0, col - M.options.x_padding - state.x_offset)
--
--   if align_bottom then
--     row = math.max(0, row - M.options.y_padding)
--   else
--     row = math.min(row_max, row + M.options.y_padding)
--   end
--
--   return row, col, (align_bottom and "S" or "N") .. "E"
-- end
