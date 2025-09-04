local M = {}

--- @return lsp.ClientCapabilities
function M.complete()
	-- neovim default capabilities
	local default = vim.lsp.protocol.make_client_capabilities()
	-- blink.nvim capabilitites:
	local blink = require("blink.cmp").get_lsp_capabilities()
	-- combined capabilitites
	local combined = vim.tbl_deep_extend("force", default, blink)

	combined.workspace.didChangeWatchedFiles.dynamicRegistration = true
	combined.workspace.didChangeWatchedFiles.relativePatternSupport = true
	combined.workspace.didChangeConfiguration.dynamicRegistration = true

	-- inlay hints
	combined.textDocument = combined.textDocument or {}
	combined.textDocument.inlayHint = combined.textDocument.inlayHint or {}
	combined.textDocument.inlayHint.dynamicRegistration = true
	combined.textDocument.inlayHint.resolveSupport = combined.textDocument.inlayHint.resolveSupport or {}
	combined.textDocument.inlayHint.resolveSupport.properties = combined.textDocument.inlayHint.resolveSupport.properties
		or {
			"tooltip",
			"label.tooltip", -- etc.
		}

	-- code lens
	combined.textDocument.codeLens = combined.textDocument.codeLens or {}
	combined.textDocument.codeLens.dynamicRegistration = true
	combined.workspace = combined.workspace or {}
	combined.workspace.codeLens = combined.workspace.codeLens or {}
	combined.workspace.codeLens.refreshSupport = true

	-- for ufo foldingplugin
	combined.textDocument.foldingRange.dynamicRegistration = false
	combined.textDocument.foldingRange.lineFoldingOnly = true

	return combined
end

---@param opts table<any>
---@return lsp.ClientCapabilities
function M.adaptive(opts)
	opts = opts or {}
	opts.name = opts.name or ""
	opts.bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = opts.bufnr, name = opts.name })
	if #clients == 0 then
		return vim.lsp.protocol.make_client_capabilities()
	end
	local current_client = clients[1]
	local c = vim.lsp.protocol.make_client_capabilities()
	if current_client.server_capabilities.callHierarchyProvider then
		c.textDocument.callHierarchy.dynamicRegistration = true
	end
	if current_client.server_capabilities.codeActionProvider then
		c.textDocument.codeAction.codeActionLiteralSupport.codeActionKind.valueSet = {
			"notebook",
			"quickfix",
			"refactor",
			"refactor.extract",
			"refactor.inline",
			"refactor.move",
			"refactor.rewrite",
			"source",
			"source.fixAll",
			"source.organizeImports",
		}
		c.textDocument.codeAction.dataSupport = true
		c.textDocument.codeAction.disabledSupport = true
		c.textDocument.codeAction.documentationSupport = true
		c.textDocument.codeAction.dynamicRegistration = true
		c.textDocument.codeAction.honorsChangeAnnotations = true
		c.textDocument.codeAction.isPreferredSupport = true
		c.textDocument.codeAction.resolveSupport.properties = { "edit", "command" }
		-- c.textDocument.codeAction.tagSupport.valueSet = { 1 }
	end
	if current_client.server_capabilities.codeLensProvider then
		c.textDocument.codeLens.dynamicRegistration = true
		c.textDocument.codeLens.resolveSupport.properties = { "command" }
		-- c.workspace.codeLens.refreshSupport = true
	end
	-- if current_client.server_capabilities.colorProvider then
	-- 	c.textDocument.colorProvider.dynamicRegistration = true
	-- end
	if current_client.server_capabilities.completionProvider then
		-- completion items
		c.textDocument.completion.completionItem.commitCharactersSupport = true
		c.textDocument.completion.completionItem.deprecatedSupport = true
		c.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
		c.textDocument.completion.completionItem.insertReplaceSupport = true
		c.textDocument.completion.completionItem.insertTextModeSupport.valueSet = { 1, 2 }
		c.textDocument.completion.completionItem.labelDetailsSupport = true
		c.textDocument.completion.completionItem.preselectSupport = true
		c.textDocument.completion.completionItem.resolveSupport.properties =
			{ "detail", "documentation", "additionalTextEdits", "command" }
		c.textDocument.completion.completionItem.snippetSupport = true
		c.textDocument.completion.completionItem.tagSupport.valueSet = { 1 }
		c.textDocument.completion.completionItemKind.valueSet = {
			1,
			2,
			3,
			4,
			5,
			6,
			7,
			8,
			9,
			10,
			11,
			12,
			13,
			14,
			15,
			16,
			17,
			18,
			19,
			20,
			21,
			22,
			23,
			24,
			25,
		}
		c.textDocument.completion.completionList.applyKindSupport = true
		c.textDocument.completion.completionList.itemDefaults =
			{ "commitCharacters", "editRange", "insertTextFormat", "insertTextMode", "data" }
		c.textDocument.completion.contextSupport = true
		c.textDocument.completion.dynamicRegistration = true
		c.textDocument.completion.insertTextMode = 1
	end
	if current_client.server_capabilities.declarationProvider then
		c.textDocument.declaration.dynamicRegistration = true
		c.textDocument.declaration.linkSupport = true
	end
	if current_client.server_capabilities.definitionProvider then
		c.textDocument.definition.dynamicRegistration = true
		c.textDocument.definition.linkSupport = true
	end
	if current_client.server_capabilities.diagnosticProvider then
		c.textDocument.diagnostic.codeDescriptionSupport = true
		c.textDocument.diagnostic.dataSupport = true
		c.textDocument.diagnostic.dynamicRegistration = true
		c.textDocument.diagnostic.relatedDocumentSupport = true
		c.textDocument.diagnostic.relatedInformation = true
		c.textDocument.diagnostic.tagSupport.valueSet = { 1, 2 }
		c.workspace.diagnostics.refreshSupport = true
	end
	if current_client.server_capabilities.documentFormattingProvider then
		c.textDocument.formatting.dynamicRegistration = true
	end
	if current_client.server_capabilities.documentHighlightProvider then
		c.textDocument.documentHighlight.dynamicRegistration = true
	end
	if current_client.server_capabilities.documentLinkProvider then
		c.textDocument.documentLink.dynamicRegistration = true
		c.textDocument.documentLink.tooltipSupport = true
	end
	if current_client.server_capabilities.documentOnTypeFormattingProvider then
		c.textDocument.onTypeFormatting.dynamicRegistration = true
	end
	if current_client.server_capabilities.documentRangeFormattingProvider then
		c.textDocument.rangeFormatting.dynamicRegistration = true
		c.textDocument.rangeFormatting.rangesSupport = true
	end
	if current_client.server_capabilities.documentSymbolProvider then
		c.textDocument.documentSymbol.dynamicRegistration = true
		c.textDocument.documentSymbol.hierarchicalDocumentSymbolSupport = true
		c.textDocument.documentSymbol.labelSupport = true
		c.textDocument.documentSymbol.symbolKind.valueSet =
			{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 }
		c.textDocument.documentSymbol.tagSupport.valueSet = { 1 }
	end
	if current_client.server_capabilities.executeCommandProvider then
		c.workspace.executeCommand.dynamicRegistration = true
	end
	if current_client.server_capabilities.experimental then
		c.experimental = true
	end
	if current_client.server_capabilities.foldingRangeProvider then
		c.textDocument.foldingRange.dynamicRegistration = true
		c.textDocument.foldingRange.foldingRange.collapsedText = true
		c.textDocument.foldingRange.foldingRangeKind.valueSet = { "comment", "imports", "region" }
		c.textDocument.foldingRange.lineFoldingOnly = true
		c.textDocument.foldingRange.rangeLimit = 10000
		c.workspace.foldingRange.refreshSupport = true
	end
	if current_client.server_capabilities.hoverProvider then
		c.textDocument.hover.contentFormat = { "markdown", "plaintext" }
		c.textDocument.hover.dynamicRegistration = true
	end
	if current_client.server_capabilities.implementationProvider then
		c.textDocument.implementation.dynamicRegistration = true
		c.textDocument.implementation.linkSupport = true
	end
	if current_client.server_capabilities.inlayHintProvider then
		c.textDocument.inlayHint.dynamicRegistration = true
		c.textDocument.inlayHint.resolveSupport.properties =
			{ "textEdits", "tooltip", "tooltip.label", "location", "command" }
		c.workspace.inlayHint.refreshSupport = true
	end
	if current_client.server_capabilities.inlineCompletionProvider then
		c.textDocument.inlineCompletion.dynamicRegistration = true
	end
	if current_client.server_capabilities.inlineValueProvider then
		c.textDocument.inlineValue.dynamicRegistration = true
		c.workspace.inlineValue.refreshSupport = true
	end
	if current_client.server_capabilities.linkedEditingRangeProvider then
		c.textDocument.linkedEditingRange.dynamicRegistration = true
	end
	if current_client.server_capabilities.monikerProvider then
		c.textDocument.moniker.dynamicRegistration = true
	end
	if current_client.server_capabilities.notebookDocumentSync then
		c.notebookDocument.synchronization.dynamicRegistration = true
		c.notebookDocument.synchronization.executionSummarySupport = true
	end
	if current_client.server_capabilities.positionEncoding then
		c.general.positionEncodings = { "utf-8", "utf-16", "utf-32" }
	end
	if current_client.server_capabilities.referencesProvider then
		c.textDocument.references.dynamicRegistration = true
	end
	if current_client.server_capabilities.renameProvider then
		c.textDocument.rename.dynamicRegistration = true
		c.textDocument.rename.honorsChangeAnnotations = true
		c.textDocument.rename.prepareSupport = true
		c.textDocument.rename.prepareSupportDefaultBehavior = 1
	end
	if current_client.server_capabilities.selectionRangeProvider then
		c.textDocument.selectionRange.dynamicRegistration = true
	end
	if current_client.server_capabilities.semanticTokensProvider then
		c.textDocument.semanticTokens.augmentsSyntaxTokens = true
		c.textDocument.semanticTokens.dynamicRegistration = true
		c.textDocument.semanticTokens.formats = { "relative" }
		c.textDocument.semanticTokens.multilineTokenSupport = true
		c.textDocument.semanticTokens.overlappingTokenSupport = true
		c.textDocument.semanticTokens.requests.full = true
		c.textDocument.semanticTokens.requests.range = true
		c.textDocument.semanticTokens.serverCancelSupport = true
		c.textDocument.semanticTokens.tokenModifiers = {
			"declaration",
			"definition",
			"readonly",
			"static",
			"deprecated",
			"abstract",
			"async",
			"modification",
			"documentation",
			"defaultlibrary",
		}
		c.textDocument.semanticTokens.tokenTypes = {
			"namespace",
			"type",
			"class",
			"enum",
			"interface",
			"struct",
			"typeParameter",
			"parameter",
			"variable",
			"property",
			"enumMember",
			"event",
			"function",
			"method",
			"macro",
			"keyword",
			"modifier",
			"comment",
			"string",
			"number",
			"regexp",
			"operator",
		}
		c.workspace.semanticTokens.refreshSupport = true
	end
	c.workspace.applyEdit = true
	c.workspace.configuration = true
	c.workspace.didChangeConfiguration.dynamicRegistration = true
	c.workspace.didChangeWatchedFiles.dynamicRegistration = true
	c.workspace.didChangeWatchedFiles.relativePatternSupport = true
	c.workspace.fileOperations.didCreate = true
	c.workspace.fileOperations.willCreate = true
	c.workspace.fileOperations.didDelete = true
	c.workspace.fileOperations.willDelete = true
	c.workspace.fileOperations.didRename = true
	c.workspace.fileOperations.willRename = true
	c.workspace.fileOperations.dynamicRegistration = true
	c.workspace.workspaceEdit.changeAnnotationSupport.groupsOnLabel = true
	c.workspace.workspaceEdit.documentChanges = true
	c.workspace.workspaceEdit.failureHandling = "transactional"
	c.workspace.workspaceEdit.metadataSupport = true
	c.workspace.workspaceEdit.normalizesLineEndings = true
	c.workspace.workspaceEdit.resourceOperations = { "create", "delete", "rename" }
	c.workspace.workspaceEdit.snippetEditSupport = true
	c.window.showDocument.support = true
	c.window.showMessage.messageActionItem.additionalPropertiesSupport = true
	c.window.workDoneProgress = true
	-- c.general.markdown.allowedTags = { "" }
	-- c.general.markdown.parser = ""
	-- c.general.markdown.version = ""
	-- c.general.regularExpressions.engine = ""
	-- c.general.regularExpressions.version = ""
	-- c.general.staleRequestSupport.cancel = true
	-- c.general.staleRequestSupport.retryOnContentModified = { "" }
	return c
end

return M
