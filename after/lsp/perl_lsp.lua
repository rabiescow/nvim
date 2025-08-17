local filetypes = { "perl" }
local root_markers = { ".git" }
local command =
	{ "perl", "-MPerl::LanguageServer", "-e", "Perl::LanguageServer::run", "--", "--port 13603", "--nostdio 0" }

return {
	enable = true,
	name = "Perl-LSP",
	cmd = command,
	filetypes = filetypes,
	root_markers = root_markers,
	single_file_support = true,
	trace = vim.lsp.protocol.MessageType.Warning,
	log_level = "messages",
	capabilities = require("utils.capabilities").complete(),
	on_attach = require("utils.attach").on,
	settings = {
		perl = {
			perlCmd = "perl",
			perlInc = " ",
			fileFilter = { ".pm", ".pl" },
			ignoreDirs = ".git",
		},
	},
}
