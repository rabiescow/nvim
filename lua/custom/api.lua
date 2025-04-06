-- for conciceness
local api = vim.api

-- highlight last yank
-- try it with "yap" in normal mode
-- see `:help vim.highlight.on_yank()`
api.nvim_create_autocmd("TextYankPost", {
  desc = "highlight when yanking text",
  group = api.nvim_create_augroup("kickstart", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

api.nvim_set_option("clipboard", "unnamed")

-- Get hover info on CursorHold
local toggleHover = function()
  vim.api.nvim_create_autocmd({ "CursorHold" }, {
    pattern = { "*.ml" },
    callback = vim.lsp.buf.hover,
  })
end
vim.keymap.set("n", "<leader>h", toggleHover)

local format_sync_grp = api.nvim_create_augroup("goimports", {})
api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require('go.format').goimports()
  end,
  group = format_sync_grp,
})
