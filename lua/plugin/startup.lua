local function banner()
	local b = {
		{
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡖⠛⠛⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⢀⡀⠀⠀⢠⡞⠛⠳⡄⠀⠀⢀⣀⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡄⠀⠀⢸⠇⠀⢀⣀⠀⠀⠀⠀⣠⣤⣀⠀⠀⠀",
			"⠀⡾⠉⠉⠳⣄⢸⡆⠀⠀⣧⢀⡾⠋⠀⠀⠀⠉⢳⡄⠀⠠⠶⠒⠲⠶⣄⢀⡴⠶⢦⡀⠀⢠⡞⠉⢻⣝⣶⣾⡋⢀⡞⠉⠉⢷⡀⠀⡾⠁⠀⠈⣷⠀⠀",
			"⢨⡇⠀⠀⠀⠙⣆⣇⠀⠀⣿⡏⠀⠀⡴⠛⢦⡀⢀⣿⠟⢻⠀⣠⣀⠀⠈⢿⡄⠀⠘⡇⠀⣼⠀⠀⢸⡟⠀⠀⡿⢸⠁⠀⠀⠈⢷⣼⠁⠀⡀⠀⠸⡆⠀",
			"⢸⡇⠀⢸⡄⠀⠘⣿⠀⠀⣿⠀⠀⠈⠉⠙⢻⡍⠉⡟⠀⠀⣷⠁⠹⡆⠀⠘⣷⠀⠀⢻⣰⠇⠀⢠⣿⡇⠀⠀⡇⣿⠀⠀⣆⠀⠈⡏⠀⢠⣇⠀⠀⢿⠀",
			"⢸⡇⠀⠈⡿⣆⠀⠈⠀⠀⣿⡀⠀⢰⡶⠶⢾⡷⠲⣷⠀⠀⢿⡀⢠⡇⠀⢀⡿⡆⠀⠘⡟⠀⠀⡼⢹⡇⠀⠀⡇⣿⠀⠀⢿⡆⠀⠀⠀⡿⣿⠀⠀⢹⡀",
			"⠀⡇⠀⠀⣿⠙⣦⠀⠀⢠⡏⢧⠀⠀⠙⠲⠚⠀⠀⣼⣆⠀⠈⠛⠋⠀⢀⡼⠁⢻⡀⠀⠀⠀⣸⠃⠀⡇⠀⠀⣷⢿⠀⠀⢸⡹⣤⣠⡼⠁⣿⠀⠀⢸⡇",
			"⠀⢿⡀⢀⡼⠀⠘⠦⠤⠞⠀⠈⠳⢤⣄⣀⣀⣤⠞⠁⠈⠳⣤⣤⣤⠴⠚⠁⠀⠈⢷⡀⠀⣰⠇⠀⠀⢷⠀⠀⣸⠸⣆⣀⣸⠃⠀⠀⠀⠀⢿⡀⢀⣸⠃",
			"⠀⠀⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠛⠁⠀⠀⠀⠈⠛⠛⠁⠀⠈⠉⠀⠀⠀⠀⠀⠀⠀⠉⠉⠁⠀",
		},
		{
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⢰⣿⣿⡄⠀⣠⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣤⣤⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀",
			"⠀⢠⣾⣷⣄⠀⠈⣿⣿⡇⢸⣿⣿⣿⣦⡀⠀⠀⠀⣀⣠⣤⣤⣀⣠⣤⡀⠀⠀⢀⣾⣿⣟⣭⣏⣠⣴⣦⡄⠀⠀⠀⣸⣿⣿⡇⠀⠀⠀⠀",
			"⠀⠸⣿⣿⣿⣧⡀⢻⣿⣷⣼⣿⡟⢿⣿⣿⣦⣠⣾⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⣾⣿⣿⣿⣿⣿⢹⣿⣿⣷⡀⠀⢀⣿⣿⣿⣿⠀⠀⠀⠀",
			"⠀⣤⢿⣿⣿⣿⣿⣾⣿⣿⣿⣿⣧⣾⣿⣿⣿⣿⣿⣿⣿⡟⠹⣿⣿⣿⣿⣆⢰⣿⣿⠃⣿⣿⡏⢸⣿⣿⣿⣷⣀⣾⣿⣿⣿⣿⡀⡀⠀⠀",
			"⣶⣿⡜⣿⣿⣿⢿⣿⣿⣿⣿⣿⣟⢻⠛⠉⢉⣽⣿⣿⣻⠃⢀⣿⣿⡿⣿⣿⣿⣿⡏⠀⢸⣿⣧⢸⣿⣿⢻⣿⣿⣿⣿⠁⣿⣿⣇⣷⣶⡆",
			"⠉⠈⠃⢿⣿⣿⠀⠹⣿⣿⣿⣿⣿⣦⣤⣴⣿⣿⣿⣿⣿⣿⣾⣿⡿⠀⢻⣿⣿⣿⠁⠀⢸⣿⣿⣼⣿⣿⠀⠙⠿⠿⠃⠀⢹⣿⣿⡙⠀⠀",
			"⠀⠀⠀⠈⢿⡿⠀⠀⠈⠛⠉⠘⠻⢿⣿⠟⠛⠉⠈⠛⠻⣿⠟⠋⠀⠀⠀⢻⣿⠋⢰⣿⣿⣿⣿⣿⡟⠛⠀⠀⠀⠀⠀⠀⠀⣿⣿⡷⠀⠀",
			"⠀⠀⠀⠀⠀⠃⠀⠀⠀⠀⠀⠀⠀⠘⡏⠀⠀⠀⠀⠀⠀⠏⠀⠀⠀⠀⠀⠘⠁⠀⠀⠀⠈⠙⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡟⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠁⠀⠀⠀",
			"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀",
		},
	}
	return b[math.random(1, 2)]
end

return {
	"startup-nvim/startup.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
	},
	config = function()
		local startup = require("startup")

		startup.setup({
			header = {
				type = "text",
				oldfiles_directory = false,
				align = "center",
				fold_section = false,
				title = "Title",
				margin = 0,
				content = banner(),
				highlight = "Statement",
				default_color = "#FAB487",
				oldfiles_amount = 0,
			},
			body = {
				type = "mapping",
				oldfiles_directory = false,
				align = "center",
				fold_section = false,
				title = "Header",
				margin = 0,
				content = {
					{ "  Find File (oil)", "Oil --float", "<leader>ff" },
					{ "  Find Word (telescope)", "Telescope live_grep", "<leader>lg" },
					{ "  Recent Files (telescope)", "Telescope oldfiles", "<leader>of" },
					{ "  File Browser (telescope)", "Telescope file_browser", "<leader>fb" },
					{ "  Colorschemes (telescope)", "Telescope colorscheme", "<leader>cs" },
					{ "  New File", "enew", "<leader>nf" },
				},
				highlight = "String",
				default_color = "",
				oldfiles_amount = 0,
			},
			footer = {
				type = "text",
				oldfiles_directory = false,
				align = "center",
				fold_section = false,
				title = "Footer",
				margin = 5,
				-- content = {" "},
				content = { "" },
				highlight = "Number",
				default_color = "",
				oldfiles_amount = 0,
			},
			options = {
				mapping_keys = true,
				cursor_column = 0.37,
				empty_lines_between_mappings = false,
				disable_statuslines = false,
				paddings = { 1, 0, 0, 0 },
			},
			mappings = {
				execute_command = "<CR>",
				open_file = "o",
				open_file_split = "<C-o>",
				open_section = "<TAB>",
				open_help = "?",
			},
			colors = { background = "#232332", folded_section = "#56b6c2" },
			parts = { "header", "body", "footer" },
		})
	end,
}
