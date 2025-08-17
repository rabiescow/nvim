return {
	"mfussenegger/nvim-lint",
	event = { "BufWritePost", "BufReadPost", "InsertLeave" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			bash = { "shellcheck" },
			-- erlang = {"elvis"},
			elixir = { "credo" },
			fortran = { "fortitude" },
			-- go = { "golangcilint" },
			haskell = { "hlint" },
			javascript = { "eslint_d" },
			-- lua = {"luacheck", args = {"--read-globals vim require"}},
			markdown = { "markdownlint" },
			python = { "pylint" },
			-- qml = { "qmllint" },
			ruby = { "rubocop" },
			-- rust = { "clippy" },
			typescript = { "eslint_d" },
			sh = { "shellcheck" },
			yaml = { "yamllint" },
		}
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("linting", { clear = true }),
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
