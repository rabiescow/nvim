local filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }
local root_markers = {
	".clangd",
	".clang-tidy",
	".clang-format",
	"compile_commands.json",
	"compile_flags.txt",
	"configure.ac",
	".git",
	"CMakeList.txt",
	"CMake*",
	".build.yml",
	".build.yaml",
	".hg",
	".hgignore",
	".hgtags",
	"meson.build",
	"meson_options.txt",
}
local command = {
	"clangd",
	"--background-index",
	"--clang-tidy",
	"--header-insertion=iwyu",
	"--fallback-style=none",
	"--completion-style=detailed",
	"--function-arg-placeholders=true",
	"--log=verbose",
}

---@type vim.lsp.Config
return {
	enable = true,
	name = "clangd",
	cmd = command,
	filetypes = filetypes,
	root_markers = root_markers,
	root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1]),
	single_file_support = true,
	log_level = vim.lsp.protocol.MessageType.Warning,
	-- capabilities = require("utils.capabilities").complete(),
	capabilities = require("utils.capabilities").complete(),
	on_attach = require("utils.attach").on,
	on_new_config = nil,
}
