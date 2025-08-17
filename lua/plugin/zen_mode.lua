return {
	"folke/zen-mode.nvim",
	---@type ZenOptions
	opts = {
		border = "none",
		zindex = 30,
		window = {
			backdrop = 1,
			width = 150,
			height = 1,
		},
		plugins = {
			options = {
				enabled = true,
				ruler = false,
				showcmd = true,
			},
			kitty = {
				enabled = true,
				font = "+8",
			},
		},
	},
}
