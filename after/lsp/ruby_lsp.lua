local filetypes = { "ruby" }
local root_marker = { "Gemfile", ".git" }
local command = { "ruby-lsp" }

return {
	enable = true,
	name = "ruby-lsp",
	cmd = command,
	filetypes = filetypes,
	root_markers = root_markers,
	trace = vim.lsp.protocol.MessageType.Warning,
	log_level = "messages",
	single_file_support = true,
	capabilities = require("utils.capabilities").complete(),
	on_attach = require("utils.attach").on,
	init_options = {
		enabledFeatures = {
			codeActions = true,
			codeLens = true,
			completion = true,
			definition = true,
			diagnostics = true,
			documentHighlights = true,
			documentLink = true,
			documentSymbols = true,
			foldingRanges = true,
			formatting = true,
			hover = true,
			inlayHint = true,
			onTypeFormatting = true,
			selectionRanges = true,
			semanticHighlighting = true,
			signatureHelp = true,
			typeHierarchy = true,
			workspaceSymbol = true,
		},
		featuresConfiguration = {
			inlayHint = {
				implicitHashValue = true,
				implicitRescue = true,
			},
		},
		indexing = {
			excludedPatterns = {},
			includedPatterns = {},
			excludedGems = {},
			excludedMagicComments = { "compiled:true" },
		},
		formatter = "auto",
		linters = { "rubocop" },
		experimentalFeaturesEnabled = false,
	},
}
