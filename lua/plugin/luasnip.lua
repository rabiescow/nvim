return {
	"L3MON4D3/LuaSnip",
	lazy = false,
	dependencies = { "kmarius/jsregexp" },
	-- tag = "v2.*",
	build = "make install_jsregexp",
	config = function()
		local home = os.getenv("HOME")
		local snips = home .. "/.config/nvim/snippets"

		require("luasnip.loaders.from_vscode").lazy_load({
			paths = { snips },
		})
	end,
}
