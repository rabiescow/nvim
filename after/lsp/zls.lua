local root_markers = { "zls.json", "build.zig", ".git" }

---@type vim.lsp.Config
return {
	enable = true,
	name = "zls",
	cmd = { "zls" },
	filetypes = { "zig", "zir" },
	root_markers = root_markers,
	root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1]),
	log_level = vim.lsp.protocol.MessageType.Warning,
	trace = "messages",
	single_file_support = true,
	capabilities = require("utils.capabilities").complete(),
	on_attach = require("utils.attach").on,
	on_new_config = function(new_config, new_root_dir)
		if vim.fn.filereadable(vim.fs.joinpath(new_root_dir, "zls.json")) ~= 0 then
			new_config.cmd = { "zls", "--config-path", "zls.json" }
		end
	end,
	settings = {
		zls = {
			enable_build_on_save = false,
			semantic_tokens = "partial",
			zig_exe_path = executable_path("zig"),
		},
	},
}
