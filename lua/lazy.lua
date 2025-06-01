local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {{import = "plugins"}, {import = "plugins.themes"}},

    git = {
        log = {"-8"},
        timeout = 120,
        url_format = "https://github.com/%s.git",
        filter = true,
        throttle = {
            enabled = false,
            rate = 2, -- max 2 ops every 5 seconds
            duration = 5 * 1000 -- in ms
        },
        cooldown = 0
    },
    change_detection = {enabled = false, notify = true}
})

vim.cmd.colorscheme "catppuccin"
