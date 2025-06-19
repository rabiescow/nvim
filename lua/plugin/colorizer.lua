return {
	"rabiescow/nvim-colorizer.lua",
	lazy = false,
	event = { "BufEnter" },
	cmd = { "ColorizerToggle" },
	config = function()
		require("colorizer").setup({
			default_options = {
				rgb = true,
				rrggbb = true,
				names = true,
				rrggbbaa = true,
				rgb_fn = true,
				hsl_fn = true,
				css = true,
				css_fn = true,
				mode = "background",
			},
		})
	end,
}
