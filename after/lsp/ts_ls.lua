local filetypes = {
	"javascript",
	"javascriptreact",
	"javascript.jsx",
	"typescript",
	"typescriptreact",
	"typescript.tsx",
}
local root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" }
local capabilities = require("utils.capabilities")
local attach = require("utils.attach")

---@type vim.lsp.Config
return {
	enable = true,
	name = "ts_ls",
	init_options = { hostInfo = "neovim" },
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = filetypes,
	root_markers = root_markers,
	root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1]),
	log_level = vim.lsp.protocol.MessageType.Warning,
	trace = "messages",
	single_file_support = true,
	capabilities = capabilities.complete(),
	on_attach = attach.on,
}
