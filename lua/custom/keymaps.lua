-- set leader key to comma
vim.g.mapleader = ","

local keymap = vim.keymap -- for conciseness

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Swap between last two buffers
keymap.set("n", "<leader>'", "<C-^>", { desc = "Switch to last buffer" })

-- Save with leader key
keymap.set("n", "<leader>w", "<CMD>w<CR>", { silent = false })

-- Quit with leader key
keymap.set("n", "<leader>q", "<CMD>q<CR>", { silent = false })

-- Save and Quit with leader key
keymap.set("n", "<leader>z", "<CMD>wq<CR>", { silent = false })

-- Oil floating window keymap
keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "browse filesystem" })

-- set keymaps
-- Telescope keymaps
keymap.set("n", "ff", "<CMD>Telescope find_files<CR>", { desc = "Fuzzy find files in cwd" })
keymap.set("n", "fr", "<CMD>Telescope oldfiles<CR>", { desc = "Fuzzy find recent files" })
keymap.set("n", "fs", "<CMD>Telescope live_grep<CR>", { desc = "Find string in cwd" })
keymap.set("n", "fc", "<CMD>Telescope grep_string<CR>", { desc = "Find string under cursor in cwd" })

-- Trouble
keymap.set("n", "<leader>tr", "<CMD>Trouble<CR>", { desc = "Open Trouble for diagnostics" })
keymap.set("n", "<Esc>", "<CMD>TroubleClose<CR>", { desc = "Close current Trouble dialog" })

keymap.set("n", "<leader><", "<CMD>require(‘nvim-autopairs’).disable()<CR>", { desc = "Disable Autopairs" })
keymap.set("n", "<leader><", "<CMD>require(‘nvim-autopairs’).enable()<CR>", { desc = "Enable Autopairs" })

-- Diagnostic keymaps
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- -- Ufo folds
-- vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
-- vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
-- vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
-- vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)

-- BLOCK TOGGLE
-- vim.api.nvim_create_user_command('Block', "<CMD>require('block').toggle<CR>", { desc = "TOGGLE" })
-- vim.api.nvim_create_user_command('BlockOn', "<CMD>require('block').on<CR>", { desc = "ON" })
-- vim.api.nvim_create_user_command('BlockOff', "<CMD>require('block').off<CR>", { desc = "OFF" })
