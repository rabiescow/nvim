---@type vim.lsp.Config
return {
	enable = true,
	name = "json-language-server",
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	root_dir = vim.fn.environ()["PWD"],
	log_level = vim.lsp.protocol.MessageType.Warning,
	trace = "verbose",
	single_file_support = true,
	capabilities = require("utils.capabilities").complete(),
	on_attach = require("utils.attach").on,
	settings = {
		json = {
			validate = { enable = true },
			format = { enable = true },
			schemas = require("schemastore").json.schemas(),
		},
	},
}
