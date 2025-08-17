local M = {}

local function hover_diagnostic(client, bufnr)
	local api = vim.api
	local fn = vim.fn

	local hover_diag_win = {
		win_id = nil,
		buf_id = nil,
		ns_id = api.nvim_create_namespace("HoverHighlights"),
	}

	---@param text string
	---@param width integer
	---@return table<string>
	local function wrap_text(text, width)
		local lines = {}
		for s in text:gmatch("[^\r\n]+") do
			local start = 1
			while start <= #s do
				local break_pos = start + width
				if break_pos < #s then
					local last_space = s:sub(start, break_pos):match(".*%s")
					if last_space then
						break_pos = start + #last_space - 1
					end
				end
				table.insert(lines, s:sub(start, break_pos))
				start = break_pos + 1
			end
		end
		return lines
	end

	local function clear_hover_diagnostic_float()
		if hover_diag_win.win_id and api.nvim_win_is_valid(hover_diag_win.win_id) then
			api.nvim_win_close(hover_diag_win.win_id, true)
		end
		if hover_diag_win.buf_id and api.nvim_buf_is_valid(hover_diag_win.buf_id) then
			api.nvim_buf_delete(hover_diag_win.buf_id, { force = true })
		end
		hover_diag_win.win_id = nil
		hover_diag_win.buf_id = nil
	end

	local function show_hover_diagnostic_float()
		clear_hover_diagnostic_float()

		local current_win = api.nvim_get_current_win()

		if not api.nvim_buf_is_valid(bufnr) or fn.getbufvar(bufnr, "modifiable") == 0 then
			return
		end
		local cursor_line = api.nvim_win_get_cursor(current_win)[1] - 1
		local diagnostics_on_line = vim.diagnostic.get(bufnr, { lnum = cursor_line })

		if not diagnostics_on_line or vim.tbl_isempty(diagnostics_on_line) then
			return
		end

		local icons = {
			[vim.diagnostic.severity.ERROR] = "   ",
			[vim.diagnostic.severity.WARN] = "   ",
			[vim.diagnostic.severity.INFO] = "   ",
			[vim.diagnostic.severity.HINT] = " 󰠠  ",
		}

		local highlights = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticError",
			[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
			[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
			[vim.diagnostic.severity.HINT] = "DiagnosticHint",
		}

		local wrap_at = 50

		local lines_for_hover = {}
		local highlights_to_apply = {}
		local max_line_width = 0

		for _, diag in ipairs(diagnostics_on_line) do
			local icon = icons[diag.severity] or ""
			local source_info = "[" .. (diag.source or "LSP") .. "] "
			local prefix = icon .. source_info

			local indent = string.rep(" ", fn.strdisplaywidth(prefix))

			local message_lines = wrap_text(diag.message, wrap_at)
			local diag_start_line = #lines_for_hover

			if message_lines[1] then
				local full_line = prefix .. message_lines[1]
				table.insert(lines_for_hover, full_line)
				max_line_width = math.max(max_line_width, fn.strdisplaywidth(full_line))
			end

			for i = 2, #message_lines do
				local full_line = indent .. message_lines[i]
				table.insert(lines_for_hover, full_line)
				max_line_width = math.max(max_line_width, fn.strdisplaywidth(full_line))
			end

			table.insert(highlights_to_apply, {
				start_line = diag_start_line,
				end_line = #lines_for_hover - 1,
				hl_group = highlights[diag.severity] or "Normal",
			})
		end

		if vim.tbl_isempty(lines_for_hover) then
			return
		end

		local win_width = api.nvim_win_get_width(current_win)
		local hover_height = #lines_for_hover
		local hover_width = max_line_width

		hover_diag_win.buf_id = api.nvim_create_buf(false, true)
		api.nvim_buf_set_lines(hover_diag_win.buf_id, 0, -1, false, lines_for_hover)
		api.nvim_set_option_value("modifiable", false, { buf = hover_diag_win.buf_id })

		for _, hl in ipairs(highlights_to_apply) do
			vim.hl.range(
				hover_diag_win.buf_id,
				hover_diag_win.ns_id,
				hl.hl_group,
				{ hl.start_line, 0 },
				{ hl.end_line, -1 }
			)
		end

		hover_diag_win.win_id = api.nvim_open_win(hover_diag_win.buf_id, false, {
			relative = "win",
			win = current_win,
			anchor = "NE",
			width = hover_width,
			height = hover_height,
			row = 0,
			col = win_width - 2,
			focusable = false,
			zindex = 150,
			style = "minimal",
			border = "single",
		})
	end

	local hover_diag_augroup = api.nvim_create_augroup("HoverDiagnostics", { clear = true })

	if client.server_capabilities.diagnosticProvider then
		api.nvim_create_autocmd({
			"CursorHold",
			"BufEnter",
			"LspAttach",
			"ModeChanged",
			"SafeState",
		}, {
			group = hover_diag_augroup,
			buffer = bufnr,
			callback = function()
				show_hover_diagnostic_float()
			end,
			desc = "Show hover diagnostics in corner",
		})

		api.nvim_create_autocmd({ "CursorMoved", "BufLeave", "ModeChanged" }, {
			group = hover_diag_augroup,
			buffer = bufnr,
			callback = function()
				clear_hover_diagnostic_float()
			end,
			desc = "Clear hover diagnostics",
		})
	end
end

local function code_lens(client, bufnr)
	local augroup = vim.api.nvim_create_augroup("LSPCodeLens", { clear = true })
	local codelens = require("utils.code_lens")

	-- Code Lens provider config
	if client.server_capabilities.codeLensProvider then
		vim.api.nvim_create_autocmd( -- {"BufEnter", "InsertLeave", "LspAttach"}, {
			{ "SafeState" },
			{
				buffer = bufnr,
				group = augroup,
				callback = function()
					codelens.refresh()
					local lenses = codelens.get(bufnr)
					codelens.display(lenses, bufnr, client.id)
				end,
			}
		)
	end
end

local function inlay_hints(client, bufnr)
	local augroup = vim.api.nvim_create_augroup("LSPInlayHint", { clear = true })
	-- Inlay Hint provider config
	-- Only turn on inlay hints when not in Insert mode
	if client.server_capabilities.inlayHintProvider then
		vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "LspAttach" }, {
			buffer = bufnr,
			group = augroup,
			callback = function()
				vim.g.inlay_hints_visible = true
				vim.lsp.inlay_hint.enable(true, { bufnr })
			end,
		})
		vim.api.nvim_create_autocmd({ "InsertEnter" }, {
			buffer = bufnr,
			group = augroup,
			callback = function()
				vim.g.inlay_hints_visible = false
				vim.lsp.inlay_hint.enable(false, { bufnr })
			end,
		})
	else
		print("no inlay hints available")
	end
end

function M.on(client, bufnr)
	code_lens(client, bufnr)
	inlay_hints(client, bufnr)
	hover_diagnostic(client, bufnr)
end

return M
