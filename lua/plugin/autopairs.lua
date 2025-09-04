return {
	"windwp/nvim-autopairs",
	event = { "InsertEnter" },
	dependencies = { "hrsh7th/nvim-cmp" },
	config = function()
		local autopairs = require("nvim-autopairs")

		autopairs.setup({
			check_ts = true,
			ts_config = { lua = { "string" }, ocaml = { "string" } },
			fast_wrap = {
				map = "€",
				chars = { "{", "[", "(", '"', "'", "<", "(*" },
				pattern = [=[[%'%"%>%]%)%}%,]]=],
				end_key = "$",
				before_key = "h",
				after_key = "l",
				cursor_pos_before = false,
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				manual_position = true,
				highlight = "Search",
				highlight_grey = "Comment",
			},
			disable_filetype = { "TelescopePrompt", "spectre_panel" },
			disable_in_macro = true,
			disable_in_visualblock = false,
			disable_in_replace_mode = true,
			ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
			enable_moveright = true,
			enable_afterquote = true,
			enable_check_bracket_line = true,
			enable_bracket_in_quote = true,
			enable_abbr = false,
			break_undo = true,
			map_cr = true,
			map_bs = true,
			map_c_h = true,
			map_c_w = true,
		})

		local rule = require("nvim-autopairs.rule")
		autopairs.add_rules({
			rule("<", ">"):with_pair(function()
				return require("utils.utils").contains({
					"c",
					"cpp",
					"csharp",
					"html",
					"java",
					"rust",
					"svg",
					"typescript",
					"xml",
					"zig",
				}, vim.o.filetype)
			end),
		})
	end,
}
