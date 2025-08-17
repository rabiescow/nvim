---@type vim.lsp.Config
return {
	enable = true,
	name = "hyprls",
	single_file_support = true,
	log_level = vim.lsp.protocol.MessageType.Warning,
	trace = "messages",
	capabilities = require("utils.capabilities").complete(),
	on_attach = require("utils.attach").on,
}
