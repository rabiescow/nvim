-- for conciceness
local api = vim.api


-- Get hover info on CursorHold
local toggleHover = function()
  vim.api.nvim_create_autocmd({ "CursorHold" }, {
    pattern = { "*.ml", "*.rs" },
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
