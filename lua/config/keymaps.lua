-- set leader key to comma
vim.g.mapleader = "`"

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<leader>zz", "<CMD>lua require('config.utils').zen()<CR>", { noremap = true, silent = true, desc = "set zenmode" })

keymap.set("n", "K", function()
	local width, height = get_editor_dimensions()
	local function toint(f)
		if f > 0 then
			return math.floor(f)
		else
			return math.ceil(f)
		end
	end
	local hoverOpts = {
		offset_x = 10000,
		offset_y = 10000,
		max_width = toint(width / 3),
		max_height = toint(height / 3),
		focusable = true,
		focus = true,
		close_events = { "InsertEnter", "InsertLeave", "CursorMoved", "CursorMovedI" },
		border = "single",
		title = "definition:",
		title_pos = "left",
		relative = "editor",
	}
	local def = require("config/definitions")
	def.definition_hover(hoverOpts)
end, { desc = [[ show lsp definitions ]] })
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
keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Browse current working directory" })
-- select all
keymap.set("n", "<C-a>", "ggVG", { desc = "the windows select all" })
