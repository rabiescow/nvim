-- highlight last yank
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "highlight when yanking text",
    group = vim.api.nvim_create_augroup("yanker", {clear = true}),
    callback = function()
        vim.highlight.on_yank({higroup = "CurSearch", timeout = 1000})
    end
})

-- local format_sync_grp = api.nvim_create_augroup("goimports", {})
vim.api.nvim_create_autocmd({"InsertLeave", "BufWritePre"}, {
    pattern = "*.go",
    callback = function() require('go.format').goimports() end,
    group = vim.api.nvim_create_augroup("goimports_on_insertleave",
                                        {clear = true})
})

vim.api.nvim_create_autocmd({'BufDelete', 'BufWipeout'}, {
    group = vim.api.nvim_create_augroup('wshada_on_delete', {clear = true}),
    desc = 'Write to ShaDa when deleting/wiping out buffers',
    command = 'wshada'
})
