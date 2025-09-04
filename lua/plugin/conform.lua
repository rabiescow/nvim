return {
	"stevearc/conform.nvim",
	event = { "BufWritePre", "BufReadPre", "BufNewFile" },
	cmd = { "ConformInfo" },
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	-- This will provide type hinting with LuaLS
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		ft_parsers = { jsonc = "json" },
		formatters_by_ft = {
			bash = { "shfmt" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			dart = { "dart_format" },
			dune = { "format-dune-file" },
			elm = { "elm_format" },
			fish = { "fish_indent" },
			fortran = { "fprettify", "findent" },
			-- go = { "goimports", "gofmt", "golines" },
			haskell = { "hindent" },
			java = { "google-java-format" },
			json = { "jq", "fixjson" },
			lua = { "stylua", "lua-format" },
			markdown = { "markdownlint" },
			ocaml = { "ocp-indent", "ocamlformat" },
			python = { "isort" },
			qml = { "qmlformat" },
			ruby = { "rubyfmt" },
			rust = { "rustfmt", lsp_format = "fallback" },
			sh = { "shfmt" },
			toml = { "taplo" },
			xml = { "xmlformatter", "xmllint" },
			yaml = { "yamlfix", "yamlfmt" },
			zig = { "zigfmt" },
		},
		default_format_opts = { lsp_format = "fallback", stop_after_first = true },
		format_on_save = { lsp_format = "fallback", timeout_ms = 500 },
		format_after_save = { lsp_format = "fallback" },
		notify_on_error = true,
		notify_no_formatters = true,
		formatters = {
			["ocamlformat"] = {
				prepend_args = {
					"--if-then-else",
					"--vertical",
					"--break-cases",
					"fit-or-vertical",
					"--type-decl",
					"--sparse",
				},
			},
			["clang-format"] = {
				prepend_args = {
					"--style={BasedOnStyle: GNU, IndentWidth: 4}",
				},
			},
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require.'conform'.formatexpr()"
	end,
}
