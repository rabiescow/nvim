local filetypes = { "erlang" }
local root_markers = { "rebar.config", "erlang.mk", ".git" }
local command = { "erlang_ls" }

---@type vim.lsp.Config
return {
	enable = true,
	name = "erlang_ls",
	cmd = command,
	filetypes = filetypes,
	root_markers = root_markers,
	root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1]),
	log_level = vim.lsp.protocol.MessageType.Warning,
	trace = "messages",
	single_file_support = true,
	capabilities = require("utils.capabilities").complete(),
	on_attach = require("utils.attach").on,
}
