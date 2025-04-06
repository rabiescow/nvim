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
keymap.set("n", "Tf", "<CMD>Telescope find_files<CR>", { desc = "Fuzzy find files in cwd" })
keymap.set("n", "Tr", "<CMD>Telescope oldfiles<CR>", { desc = "Fuzzy find recent files" })
keymap.set("n", "Tg", "<CMD>Telescope live_grep<CR>", { desc = "Find string in cwd" })
keymap.set("n", "Tc", "<CMD>Telescope grep_string<CR>", { desc = "Find string under cursor in cwd" })

-- Autopairs
keymap.set("n", "<leader><", "<CMD>require(‘nvim-autopairs’).disable()<CR>", { desc = "Disable Autopairs" })
keymap.set("n", "<leader><", "<CMD>require(‘nvim-autopairs’).enable()<CR>", { desc = "Enable Autopairs" })

-- Diagnostic keymaps
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Colortils
keymap.set("n", "<A-c>", "<CMD>Colortils<CR>", { desc = "" })

-- Colorizer
keymap.set("n", "<A-v>", "<CMD>ColorizerToggle<CR>", { desc = "" })

keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Keybinds to make split navigation easier.
--  Use ALT+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<A-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<A-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<A-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<A-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
