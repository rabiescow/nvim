return {
	"yamatsum/nvim-cursorline",
	config = function()
		require("nvim-cursorline").setup({
			cursorline = { enable = true, timeout = 300, number = true },
			cursorword = {
				enable = true,
				min_length = 5,
				hl = {
					underline = true,
					undercurl = true,
					underdouble = false,
					underdotted = false,
					underdashed = false,
					strikethrough = false,
					bold = true,
					italic = false,
					bg = nil,
					fg = #EED49F,
					sp = #EED49F,
					blend = 60,
					reverse = false,
					standout = false,
					nocombine = false,
				},
			},
		})
	end,
}
