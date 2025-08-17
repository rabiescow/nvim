---@type vim.lsp.Config
return {
	enable = true,
	name = "html-language-server",
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	embeddedLanguages = { css = true, javascript = true },
	root_dir = vim.fn.environ()["PWD"],
	log_level = vim.lsp.protocol.MessageType.Warning,
	trace = "verbose",
	single_file_support = true,
	capabilities = require("utils.capabilities").complete(),
	on_attach = require("utils.attach").on,
}
