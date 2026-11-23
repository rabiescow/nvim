local function has_clang_format(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local start_dir = fname ~= "" and vim.fs.dirname(fname) or vim.fn.getcwd()
  local found = vim.fs.find({ ".clang-format", "_clang-format" }, {
    path = start_dir,
    upward = true,
    stop = vim.uv.os_homedir(),
  })
  return #found > 0
end

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre", "BufReadPre", "BufNewFile" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
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
			go = { "goimports", "gofmt", "golines" },
			haskell = { "hindent" },
			java = { "google-java-format" },
			json = { "jq", "fixjson" },
			lua = { "stylua", "lua-format" },
			markdown = { "markdownlint" },
			ocaml = { "ocp-indent", "ocamlformat" },
			python = { "isort" },
			qml = { "qmlformat", "qmllint" },
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
				prepend_args = function()
                    local bufnr = vim.api.nvim_get_current_buf()
					if has_clang_format(bufnr) then
                        return {}
                    end
                    return { "--style={BasedOnStyle: LLVM, IndentWidth: 4}", }
                end,
            },
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require.'conform'.formatexpr()"
	end,
}
