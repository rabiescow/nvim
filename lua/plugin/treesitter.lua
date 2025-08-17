return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
		},
		config = function()
			local treesitter = require("nvim-treesitter.configs")
			treesitter.setup({
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = true,
				},

				indent = { enable = true },
				ensure_installed = {
					-- "angelscript",
					"bash",
					"c",
					"comment",
					"commonlisp",
					"cpp",
					"css",
					"d",
					"dart",
					"elixir",
					"erlang",
					"fish",
					"fortran",
					"gitignore",
					"go",
					"gomod",
					"gosum",
					"haskell",
					"html",
					"hyprlang",
					"java",
					"javascript",
					"json",
					"jsonc",
					"latex",
					"lua",
					"markdown",
					"markdown_inline",
					"ocaml",
					"ocaml_interface",
					"perl",
					"python",
					-- "qml",
					"qmldir",
					"r",
					"ruby",
					"rust",
					"typescript",
					"toml",
					"typst",
					"vim",
					"xml",
					"yaml",
					"zig",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "µ",
						node_incremental = "µ",
						scope_incremental = false,
						node_decremental = false,
					},
				},
				sync_install = false,

				auto_install = false,
				ignore_install = {},
				modules = {},
				additional_vim_regex_highlighting = false,

				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["<leader>ts"] = "@parameter.outer",
							["<leader>tg"] = "@parameter.inner",
							["<leader>tfs"] = "@function.outer",
							["<leader>tfg"] = "@function.inner",
							["<leader>tcs"] = "@class.outer",
							["<leader>tcg"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["C-f"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["A-f"] = "@function.outer",
							["<leader>c]"] = "@class.outer",
						},
						goto_previous_start = {
							["C-F"] = "@function.outer",
							["<leader>c["] = "@class.outer",
						},
						goto_previous_end = {
							["A-F"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
				},
			})
		end,
	},
}
