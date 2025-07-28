local parser_config = require("nvim-treesitter.parsers")
parser_config.angelscript = {
	install_info = {
		url = "https://github.com/dehorsley/tree-sitter-angelscript",
		files = { "src/parser.c" },
		branch = "main",
		generate_requires_npm = false,
		requires_generate_from_grammar = false,
	},
	filetype = "as",
}
vim.treesitter.language.register("angelscript", "as")

local home = os.getenv("HOME")
local lsp_cmd_cwd = home .. "/.vscode-oss/extensions/sashi0034.angel-lsp-0.3.49/server/"
local lsp_cmd = "angelscript-language-server.js"

local function new_config(conf)
	if conf.capabilities and conf.capabilities.textDocument then
		conf.capabilities.textDocument.diagnostic = nil
	end
end
local lsp = require("lspconfig")
vim.lsp.config.angel_lsp = {
	cmd_cwd = lsp_cmd_cwd,
	cmd = { "node", lsp_cmd, "--stdio" },
	filetypes = { "as" },
	root_dir = lsp.util.root_pattern("asproject.json", ".git"),
	on_new_config = new_config,
	on_attach = attach,
	capabilities = get_complete_capabilities(),
}

vim.lsp.enable("angel_lsp", true)
