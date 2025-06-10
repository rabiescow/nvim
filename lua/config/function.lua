local function ghost()
    local api = vim.api
    local fn = vim.fn

    -- create the hover diagnostic namespace
    local hover_diag_win = {
        win_id = nil,
        buf_id = nil,
        ns_id = api.nvim_create_namespace("GhostHoverHighlights") -- A namespace for our paint job.
    }

    -- clears the diagnostics when moving away from line
    local function clear_hover_diagnostic_float()
        if hover_diag_win.win_id and
            api.nvim_win_is_valid(hover_diag_win.win_id) then
            api.nvim_win_close(hover_diag_win.win_id, true)
        end
        if hover_diag_win.buf_id and
            api.nvim_buf_is_valid(hover_diag_win.buf_id) then
            api.nvim_buf_delete(hover_diag_win.buf_id, {force = true})
        end
        hover_diag_win.win_id = nil
        hover_diag_win.buf_id = nil
    end

    local function show_hover_diagnostic_float()
        clear_hover_diagnostic_float()

        local current_win = api.nvim_get_current_win()
        local current_buf = api.nvim_win_get_buf(current_win)

        if not api.nvim_buf_is_valid(current_buf) or
            fn.getbufvar(current_buf, '&modifiable') == 0 then return end

        local cursor_line = api.nvim_win_get_cursor(current_win)[1] - 1
        local diagnostics_on_line = vim.diagnostic.get(current_buf,
                                                       {lnum = cursor_line})

        if not diagnostics_on_line or vim.tbl_isempty(diagnostics_on_line) then
            return
        end

        -- The secret symbols. You need a Nerd Font for these!
        local icons = {
            [vim.diagnostic.severity.ERROR] = "   ", -- Skull / Error Icon
            [vim.diagnostic.severity.WARN] = "   ", -- Warning Triangle
            [vim.diagnostic.severity.INFO] = "   ", -- Info Circle
            [vim.diagnostic.severity.HINT] = " 󰠠  " -- Lightbulb / Hint
        }

        -- The highlight groups that match the symbols. Our paint cans.
        local highlights = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticError",
            [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticHint"
        }

        local lines_for_float = {}
        local highlights_to_apply = {}
        local max_line_width = 0

        for i, diag in ipairs(diagnostics_on_line) do
            local icon = icons[diag.severity] or ''
            local message = diag.message:gsub("[\n\r]+", " ") -- Flatten the message
            local line_to_add = icon .. "[" .. i .. "] " .. message

            table.insert(lines_for_float, line_to_add)
            table.insert(highlights_to_apply, {
                line = i - 1, -- 0-indexed line number in the new buffer
                hl_group = highlights[diag.severity] or 'Normal'
            })
            max_line_width = math.max(max_line_width,
                                      fn.strdisplaywidth(line_to_add))
        end

        if vim.tbl_isempty(lines_for_float) then return end

        -- Figure out the size of the ghost window
        local parent_win_width = api.nvim_win_get_width(current_win)
        local float_width = math.min(max_line_width + 2,
                                     math.floor(parent_win_width * 0.75))
        local float_height = #lines_for_float

        -- Make the secret buffer for the ghost
        hover_diag_win.buf_id = api.nvim_create_buf(false, true)
        api.nvim_buf_set_lines(hover_diag_win.buf_id, 0, -1, false,
                               lines_for_float)
        -- api.nvim_buf_set_option(hover_diag_win.buf_id, 'modifiable', false)
        api.nvim_set_option_value("modifiable", false,
                                  {buf = hover_diag_win.buf_id})

        -- Now we paint the lines *after* putting them in the buffer
        for _, hl in ipairs(highlights_to_apply) do
            vim.hl.range(hover_diag_win.buf_id, hover_diag_win.ns_id,
                         hl.hl_group, {hl.line, 0}, {hl.line, -1})
        end

        -- Open the ghost window in the corner
        hover_diag_win.win_id = api.nvim_open_win(hover_diag_win.buf_id, false,
                                                  {
            relative = 'win',
            win = current_win,
            anchor = 'NE',
            width = float_width,
            height = float_height,
            row = 0,
            col = parent_win_width - 1,
            focusable = false,
            zindex = 150,
            style = "minimal",
            border = "none"
        })
    end

    -- This is the setup. Call it from your main config.
    -- The lookout crew.
    local hover_diag_augroup = api.nvim_create_augroup(
                                   "MyWarPaintHoverDiagnostics", {clear = true})

    -- The lookout for when you stop.
    api.nvim_create_autocmd("CursorHold", {
        group = hover_diag_augroup,
        pattern = "*",
        callback = show_hover_diagnostic_float,
        desc = "Show ghost diagnostics with war paint"
    })

    -- The lookout for when you move. Makes the ghost vanish.
    api.nvim_create_autocmd({"CursorMoved", "BufLeave", "ModeChanged"}, {
        group = hover_diag_augroup,
        pattern = "*",
        callback = clear_hover_diagnostic_float,
        desc = "Clear ghost diagnostics"
    })
end

local function code_lens(client, bufnr)
    local augroup = vim.api.nvim_create_augroup("LSPCodeLens", {clear = true})
    local codelens = require("config.codelens")

    -- Code Lens provider config
    if client.server_capabilities.codeLensProvider then
        vim.api
            .nvim_create_autocmd( -- {"BufEnter", "InsertLeave", "LspAttach"}, {
        {"SafeState"}, {
            buffer = bufnr,
            group = augroup,
            callback = function()
                codelens.refresh()
                local lenses = codelens.get(bufnr)
                codelens.display(lenses, bufnr, client.id)
            end
        })
    end
end

local function inlay_hints(client, bufnr)
    local augroup = vim.api.nvim_create_augroup("LSPInlayHint", {clear = true})
    -- Inlay Hint provider config
    -- Only turn on inlay hints when not in Insert mode
    if client.server_capabilities.inlayHintProvider then
        vim.api.nvim_create_autocmd({"BufEnter", "InsertLeave", "LspAttach"}, {
            buffer = bufnr,
            group = augroup,
            callback = function()
                vim.g.inlay_hints_visible = true
                vim.lsp.inlay_hint.enable(true, {bufnr})
            end
        })
        vim.api.nvim_create_autocmd({"InsertEnter"}, {
            buffer = bufnr,
            group = augroup,
            callback = function()
                vim.g.inlay_hints_visible = false
                vim.lsp.inlay_hint.enable(false, {bufnr})
            end
        })
    else
        print("no inlay hints available")
    end
end

function on_attach(client, bufnr)
    code_lens(client, bufnr)
    inlay_hints(client, bufnr)
    ghost()
end
