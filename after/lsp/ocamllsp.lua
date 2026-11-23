local filetypes = {
	"ocaml",
	"ocaml.menhir",
	"ocaml.interface",
	"ocaml.ocamllex",
	"dune",
}
local root_markers = {
	"*.opam",
	"esy.json",
	"package.json",
	".git",
	"dune-project",
	"dune-workspace",
}
local capabilities = require("utils.capabilities")
local attach = require("utils.attach")

---@type vim.lsp.Config
return {
	enable = true,
	name = "ocaml-lsp",
	cmd = { "ocamllsp" },
	filetypes = filetypes,
	root_markers = root_markers,
	root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1]),
	log_level = vim.lsp.protocol.MessageType.Warning,
	trace = "messages",
	single_file_support = true,
	capabilities = capabilities.complete(),
	on_attach = attach.on,
	settings = {
		extendedHover = { enable = true },
		standardHover = { enable = true },
		codelens = { enable = true },
		duneDiagnostics = { enable = true },
		inlayHints = {
			hintPatternVariables = true,
			hintLetBindings = true,
			hintFunctionParams = true,
		},
		syntaxDocumentation = { enable = true },
		merlinJumpCodeActions = { enable = true },
	},
}
