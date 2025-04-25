--  Get the current width and height of the editor window.

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

function Inlay()
  local hint = vim.lsp.inlay_hint.get({ bufnr = 0 }) -- 0 for current buffer
  print(hint.buf_nr, hint.client_id, hint.inlay_hint)
  local client = vim.lsp.get_client_by_id(hint.client_id)
  print(client)
  -- local resp = client:request_sync('inlayHint/resolve', hint.inlay_hint, 100, 0)
  -- local resolved_hint = assert(resp and resp.result, resp.err)
  -- print(hint, client, resp, resolved_hint)
  -- vim.lsp.util.apply_text_edits(resolved_hint.textEdits, 0, client.encoding)
  -- location = resolved_hint.label[1].location
  -- client:request('textDocument/hover', {
  --   textDocument = { uri = location.uri },
  --   position = location.range.start,
  -- })
end

local M   = {}
M.options = {
  --- Base highlight group in the notification window

  --- Used by any Fidget notification text that is not otherwise highlighted,
  --- i.e., message text.
  --- Note that we use this blanket highlight for all messages to avoid adding
  --- separate highlights to each line (whose lengths may vary).
  --- Set to empty string to keep your theme defaults.
  --- With `winblend` set to anything less than `100`, this will also affect the
  --- background color in the notification box area (see `winblend` docs).
  ---@type string
  normal_hl = "Comment",

  --- Background color opacity in the notification window

  --- Note that the notification window is rectangular, so any cells covered by
  --- that rectangular area is affected by the background color of `normal_hl`.
  --- With `winblend` set to anything less than `100`, the background of
  --- `normal_hl` will be blended with that of whatever is underneath,
  --- including, e.g., a shaded `colorcolumn`, which is usually not desirable.
  --- However, if you would like to display the notification window as its own
  --- "boxed" area (especially if you are using a non-"none" `border`), you may
  --- consider setting `winblend` to something less than `100`.
  --- See also: options for |nvim_open_win()|
  ---@type number
  winblend = 100,

  --- Border around the notification window
  --- See also: options for |nvim_open_win()|
  ---@type "none"|"single"|"double"|"rounded"|"solid"|"shadow"|string[]
  border = "none",

  --- Highlight group for notification window border
  --- Set to empty string to keep your theme's default `FloatBorder` highlight.
  ---@type string
  border_hl = "",

  --- Stacking priority of the notification window
  --- Note that the default priority for Vim windows is 50.
  --- See also: options for |nvim_open_win()|
  ---@type number
  zindex = 45,

  --- Maximum width of the notification window
  --- `0` means no maximum width.
  ---@type integer
  max_width = 0,

  --- Maximum height of the notification window
  --- `0` means no maximum height.
  ---@type integer
  max_height = 0,

  --- Padding from right edge of window boundary
  ---@type integer
  x_padding = 1,

  --- Padding from bottom edge of window boundary
  ---@type integer
  y_padding = 0,

  --- How to align the notification window
  ---@type "top"|"bottom"|"avoid_cursor"
  align = "bottom",

  --- What the notification window position is relative to
  --- See also: options for |nvim_open_win()|
  ---@type "editor"|"win"
  relative = "editor",
}


---@return number       row
---@return number       col
---@return ("NE"|"SE")  anchor
function get_window_position()
  local align_bottom, col, row, row_max
  local first_line = vim.fn.line("w0")
  local current_line = vim.api.nvim_win_get_cursor(0)[1]

  local function should_align_bottom(cursor_pos, rows)
    if M.options.align == "top" then
      return false
    elseif M.options.align == "bottom" then
      return true
    else
      return cursor_pos <= (rows / 2)
    end
  end

  if options.relative == "editor" then
    col, row_max = M.get_editor_dimensions()
    local window_pos = vim.api.nvim_win_get_position(0)
    local cursor_pos = window_pos[1] + (current_line - first_line)
    align_bottom = should_align_bottom(cursor_pos, row_max)

    if align_bottom then
      row = row_max
    else
      -- When the layout is anchored at the top, need to check &tabline height
      local stal = vim.opt.showtabline:get()
      local tabline_shown = stal == 2 or (stal == 1 and #vim.api.nvim_list_tabpages() > 1)
      row = tabline_shown and 1 or 0
    end
  else -- fidget relative to "window" (currently unreachable)
    local cursor_pos = current_line - first_line

    col = vim.api.nvim_win_get_width(0)
    row_max = vim.api.nvim_win_get_height(0)
    if vim.fn.exists("+winbar") > 0 and vim.opt.winbar:get() ~= "" then
      -- When winbar is set, effective win height is reduced by 1 (see :help winbar)
      row_max = row_max - 1
    end
    align_bottom = should_align_bottom(cursor_pos, row_max)

    row = align_bottom and row_max or 1
  end

  col = math.max(0, col - M.options.x_padding - state.x_offset)

  if align_bottom then
    row = math.max(0, row - M.options.y_padding)
  else
    row = math.min(row_max, row + M.options.y_padding)
  end

  return row, col, (align_bottom and "S" or "N") .. "E"
end
