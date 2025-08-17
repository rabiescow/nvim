filetypes = { "python" }
root_markers = { ".git", "pyvenv.cfg", "pyproject.toml", "poetry.lock", "Pipfile", "Pipfile.lock", "requirements.txt" }

---@type vim.lsp.Config
return {
	enable = true,
	name = "basedpyright",
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = filetypes,
	root_markers = root_markers,
	log_level = vim.lsp.protocol.MessageType.Warning,
	trace = "messages",
	capabilities = require("utils.capabilities").complete(),
	on_attach = require("utils.attach").on,
	settings = {
		basedpyright = {
			analysis = {
				inlayHints = {
					variableTypes = true,
					callArgumentNamesMatching = true,
					callArgumentNames = true,
					functionReturnTypes = true,
					genericTypes = true,
				},
				autoFormatStrings = true,
				useTypingExtensions = true,
				autoSearchPaths = true,
				extraPaths = {},
				include = {},
				diagnosticMode = "openFilesOnly",
				fileEnumerationTimeout = 60,
				typeCheckingMode = "recommended",
				useLibraryCodeForTypes = true,
			},
			disableOrganizeImports = false,
		},
	},
}
