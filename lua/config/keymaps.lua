-- set leader key to comma
vim.g.mapleader = ","

local keymap = vim.keymap -- for conciseness

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", {desc = "Exit insert mode with jk"})
-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", {desc = "Clear search highlights"})
-- Swap between last two buffers
keymap.set("n", "<leader>'", "<C-^>", {desc = "Switch to last buffer"})
-- Save with leader key
keymap.set("n", "<leader>w", "<CMD>w<CR>", {silent = false})
-- Quit with leader key
keymap.set("n", "<leader>q", "<CMD>q<CR>", {silent = false})
-- Save and Quit with leader key
keymap.set("n", "<leader>z", "<CMD>wq<CR>", {silent = false})
-- Oil floating window keymap
keymap.set("n", "-", "<CMD>Oil --float<CR>",
           {desc = "Browse current working directory"})

