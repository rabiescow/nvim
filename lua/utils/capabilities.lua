local M = {}

--- @return lsp.ClientCapabilities
function M.complete()
	-- neovim default capabilities
	local default = vim.lsp.protocol.make_client_capabilities()
	-- blink.nvim capabilitites:
	local blink = require("blink.cmp").get_lsp_capabilities()
	-- combined capabilitites
	local combined = vim.tbl_deep_extend("force", default, blink)

	-- if you manually want to ensure specific capabilities
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

	return combined
end

return M
