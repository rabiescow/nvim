return {
	"ray-x/go.nvim",
	dependencies = { -- optional packages
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	ft = { "go", "gomod" },
	lazy = true,
	event = { "CmdlineEnter" },
	build = ':lua require("go.install").update_all_sync()',
	config = function()
		require("go").setup(opts)
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("GoFormat", {}),
			pattern = "*.go",
			callback = function()
				require("go.format").goimports()
			end,
		})
	end,
}
