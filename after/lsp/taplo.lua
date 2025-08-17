---@type vim.lsp.Config
return {
	enable = true,
	name = "taplo",
	cmd = { "taplo", "lsp", "stdio" },
	filetypes = { "toml" },
	root_dir = vim.fn.environ()["PWD"],
	log_level = vim.lsp.protocol.MessageType.Warning,
	trace = "verbose",
	single_file_support = true,
	capabilities = require("utils.capabilities").complete(),
	on_attach = require("utils.attach").on,
	settings = {
		taplo = {
			configFile = { enabled = true },
			schema = {
				enabled = true,
				catalogs = { "https://www.schemastore.org/api/json/catalog.json" },
				cache = { memoryExpiration = 60, diskExpiration = 600 },
			},
		},
	},
}
