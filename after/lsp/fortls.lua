local root_markers = { ".fortls" }
local filetypes = { "fortran" }

---@type vim.lsp.Config
return {
	enable = true,
	name = "fortls",
	cmd = {
		"fortls",
		"--incremental_sync",
		"--notify_init",
		"--recursion_limit 1000",
		"--lowercase_intrinsics",
		"--use_signature_help",
		"--variable_hover",
		"--hover_signature",
		"--hover_language=fortran",
		"--enable_code_actions",
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
