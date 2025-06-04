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

local hover_diag_notify_augroup = vim.api.nvim_create_augroup(
                                      "CustomHoverDiagnosticsNotify",
                                      {clear = true})

vim.api.nvim_create_autocmd("CursorHold", {
    group = hover_diag_notify_augroup,
    pattern = "*",
    callback = show_hover_diagnostic_via_notify,
    desc = "Show diagnostics via notify on hover"
})
