return {
	"yamatsum/nvim-cursorline",
	config = function()
		local U = require("catppuccin.utils.colors")
		require("nvim-cursorline").setup({
			cursorline = { enable = true, timeout = 300, number = true },
			cursorword = {
				enable = true,
				min_length = 5,
				hl = {
					underline = false,
					undercurl = false,
					underdouble = false,
					underdotted = false,
					underdashed = false,
					strikethrough = false,
					bold = true,
					italic = false,
					-- bg = U.brighten("#11111B", 0.25, "#1E1E2B"),
					-- fg = "#F9E2AF",
					-- sp = "#CDD6F4",
					blend = 60,
					reverse = false,
					standout = false,
					nocombine = false,
				},
			},
		})
	end,
}
