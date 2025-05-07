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
        -- defaults for the `Lazy log` command
        log = {"-8"}, -- show the last 8 commits
        timeout = 120, -- kill processes that take more than 2 minutes
        url_format = "https://github.com/%s.git",
        -- lazy.nvim requires git >=2.19.0. For older version, set to false (not
        -- recommended)
        filter = true,
        -- rate of network related git operations (clone, fetch, checkout)
        throttle = {
            enabled = false,
            rate = 2, -- max 2 ops every 5 seconds
            duration = 5 * 1000 -- in ms
        },
        -- Time in seconds to wait before running fetch again for a plugin.
        -- Repeated update/check operations will not run again until this
        -- cooldown period has passed.
        cooldown = 0
    },
    change_detection = {
        -- automatically check for config file changes and reload the ui
        enabled = false, -- default: true
        notify = true -- get a notification when changes are found
    }
})

if vim.bo.filetype == "ocaml" then
    vim.cmd.colorscheme("bluloco")
else
    vim.cmd.colorscheme("oscura")
end
