function get_complete_capabilities()
    -- neovim default capabilities
    local default = vim.lsp.protocol.make_client_capabilities();
    -- blink.nvim capabilitites:
    local blink = require("blink.cmp").get_lsp_capabilities();
    -- combined capabilitites
    local combined = vim.tbl_deep_extend("force", default, blink)

    -- if you manually want to ensure specific capabilities
    -- inlay hints
    combined.textDocument = combined.textDocument or {}
    combined.textDocument.inlayHint = combined.textDocument.inlayHint or {}
    combined.textDocument.inlayHint.dynamicRegistration = true
    combined.textDocument.inlayHint.resolveSupport =
        combined.textDocument.inlayHint.resolveSupport or {}
    combined.textDocument.inlayHint.resolveSupport.properties =
        combined.textDocument.inlayHint.resolveSupport.properties or {
            "tooltip", "label.tooltip" -- etc.
        }

    -- code lens
    combined.textDocument.codeLens = combined.textDocument.codeLens or {}
    combined.textDocument.codeLens.dynamicRegistration = true
    combined.workspace = combined.workspace or {}
    combined.workspace.codeLens = combined.workspace.codeLens or {}
    combined.workspace.codeLens.refreshSupport = true

    return combined
end

function dumpTable(tbl, indent)
    indent = indent or 0
    for k, v in pairs(tbl) do
        print(string.rep(" ", indent) .. tostring(k) .. ":")
        if type(v) == "table" then
            dumpTable(v, indent + 2)
        else
            print(string.rep(" ", indent + 2) .. tostring(v))
        end
    end
end

function get_editor_dimensions()
    local statusline_height = 0
    local laststatus = vim.opt.laststatus:get()
    if laststatus == 2 or laststatus == 3 or
        (laststatus == 1 and #vim.api.nvim_tabpage_list_wins(0) > 1) then
        statusline_height = 1
    end

    local height = vim.opt.lines:get() -
                       (statusline_height + vim.opt.cmdheight:get())
    local width = vim.opt.columns:get()
    return width, height
end

---@param diagnosticsHeight integer
function get_diagnostics_position(diagnosticsHeight)
    local display_top = nil
    local first_line = vim.fn.line("w0")
    local current_line = vim.api.nvim_win_get_cursor(0)[1]

    _, row_max = get_editor_dimensions()
    local window_pos = vim.api.nvim_win_get_position(0)
    local cursor_pos = window_pos[1] + (current_line - first_line)

    if ((row_max / 2) < cursor_pos) then
        display_top = true
    else
        display_top = false
    end

    if display_top then
        return 0
    else
        return math.floor(math.abs(row_max - diagnosticsHeight - 2))
    end
end
