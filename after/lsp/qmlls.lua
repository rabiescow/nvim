local filetypes = { "qml" }
local root_markers = { ".git", ".qmlformat.ini", ".qmllint.ini", ".qmlls.ini" }

---@type vim.lsp.Config
return {
	enable = true,
	name = "qmlls6",
	cmd = { "qmlls6" },
	cmd_env = {
		QT_QML_GENERATE_QMLLS_INI = true,
		QMLLS_BUILD_DIRS = vim.fn.environ()["PWD"] .. "/build",
		QT_QML_OUTPUT_DIRECTORY = vim.fn.environ()["PWD"],
	},
	filetypes = filetypes,
	root_markers = root_markers,
	root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1]),
	log_level = vim.lsp.protocol.MessageType.Warning,
	trace = "messages",
	single_file_support = true,
	capabilities = require("utils.capabilities").complete(),
	on_attach = require("utils.attach").on,
}
