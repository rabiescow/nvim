local filetypes = { "fish" }
local command = { "fish-lsp", "start" }

---@type vim.lsp.Config
return {
	enable = true,
	name = "fish-lsp",
	cmd = command,
	cmd_env = { fish_lsp_show_client_popups = false },
	filetypes = filetypes,
	single_file_support = true,
	trace = "verbose",
	log_level = vim.lsp.protocol.MessageType.Warning,
	capabilities = require("utils.capabilities").complete(),
	on_attach = require("utils.attach").on,
}
