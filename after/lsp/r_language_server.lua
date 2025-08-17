local filetypes = { "r", "rmd", "quarto" }
local root_markers = { ".git", ".RHistory", ".RData" }
local command = { "R", "--no-echo", "-e 'languageserver::run()'" }

return {
	default_config = {
		enable = true,
		name = "r-language-server",
		cmd = command,
		filetypes = filetypes,
		root_markers = root_markers,
		single_file_support = true,
		trace = vim.lsp.protocol.MessageType.Warning,
		log_level = "messages",
		capabilities = require("utils.capabilities").complete(),
		on_attach = require("utils.attach").on,
		settings = {
			r = {
				lsp = {
					debug = true,
					log_file = true,
					diagnostics = true,
					rich_documentation = true,
					snippet_support = true,
					max_completions = 50,
					lint_cache = true,
					link_file_size_limit = 100000000,
				},
			},
		},
	},
	docs = {
		description = [[
[languageserver](https://github.com/REditorSupport/languageserver) is an
implementation of the Microsoft's Language Server Protocol for the R
language.

It is released on CRAN and can be easily installed by

```r
install.packages("languageserver")
```
]],
	},
}
