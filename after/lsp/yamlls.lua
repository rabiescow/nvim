local capabilities = require("utils.capabilities")
local attach = require("utils.attach")

---@type vim.lsp.Config
return {
	enable = true,
	name = "yaml-language-server",
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml" },
	root_dir = vim.fn.environ()["PWD"],
	log_level = vim.lsp.protocol.MessageType.Warning,
	trace = "verbose",
	single_file_support = true,
	capabilities = capabilities.complete(),
	on_attach = attach.on,
	settings = {
		yaml = {
			-- Using the schemastore plugin for schemas.
			schemastore = { enable = false, url = "" },
			schemas = require("schemastore").yaml.schemas(),
		},
	},
}
