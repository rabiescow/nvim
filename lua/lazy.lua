local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.themes" },
    { import = "plugins.lsp" },
  },
})

vim.opt.termguicolors = true
vim.cmd.colorscheme("kat.nvim")
vim.api.nvim_set_hl(0, "Normal", { bg = "#080808" })
-- vim.api.nvim_set_hl(0, "Visual", { bg = "#080808" })
