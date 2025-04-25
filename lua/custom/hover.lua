-- Displays Line Diagnostics in a floating window at the top of the
-- buffer when hovering over the line.
function Hover()
  local group = vim.api.nvim_create_augroup("Diagnostics", {})
  local buffer = vim.api.nvim_get_current_buf()
  local event = 'CursorHold'
  local event2 = "CursorHoldI"
  local hoverOpts = {
    scope = "line",
    header = "Line diagnostics:",
    width = 40,
    height = 15,
    max_heigth = 15,
  }
  local dialog = {
    relative = "win",
    win = vim.api.nvim_get_current_win(),
    anchor = "NW",
    row = 1,
    col = 43,
    focusable = false,
    title = "Line Diagnostics",
    title_pos = "center",
    fixed = true,
    -- border = "rounded",
    -- border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
  }
  vim.api.nvim_create_autocmd(event, {
    buffer = buffer,
    group = group,

    callback = function()
      local _, windownr =
          vim.diagnostic.open_float(hoverOpts, { focusable = false })
      if windownr ~= nil then
        local config = vim.api.nvim_win_get_config(windownr)
        config = vim.tbl_extend("force", config, dialog)
        vim.api.nvim_win_set_config(windownr, config)
      end
    end
  })
  vim.api.nvim_create_autocmd(event2, {
    buffer = buffer,
    group = group,
    callback = function()
      local _, windownr =
          vim.diagnostic.open_float(hoverOpts, { focusable = false })
      if windownr ~= nil then
        local config = vim.api.nvim_win_get_config(windownr)
        config = vim.tbl_extend("force", config, dialog)
        vim.api.nvim_win_set_config(windownr, config)
      end
    end
  })
end

vim.cmd([[
      " make hover window"s background transparent
      lua Hover()
    ]])
