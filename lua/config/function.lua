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

function inline_float_diagnostics(client, bufnr)
    -- Hover Provider config
    if client.server_capabilities.hoverProvider then
        local augroup = vim.api.nvim_create_augroup("LspDiagnostics",
                                                    {clear = true})
        local event = {"BufEnter", "CursorHold"}
        vim.api.nvim_create_autocmd(event, {
            buffer = bufnr,
            group = augroup,

            callback = function()
                local currentWidth, _ = Get_editor_dimensions()
                local diagnosticsWidth = math.floor(math.abs(currentWidth / 2))
                local diagnosticsHeight = 8
                local diagnosticsColumn = currentWidth - (diagnosticsWidth + 3)
                local diagnosticsRow = Get_diagnostics_position(
                                           diagnosticsHeight)
                local hoverOpts = {
                    focusable = false,
                    close_events = {
                        "BufLeave", "CursorMoved", "InsertEnter", "FocusLost"
                    },
                    scope = "line",
                    header = "Line diagnostics:",
                    width = diagnosticsWidth,
                    height = diagnosticsHeight,
                    max_heigth = diagnosticsHeight
                }
                local secondaryOpts = {
                    focusable = false,
                    close_events = {
                        "BufLeave", "CursorMoved", "InsertEnter", "FocusLost"
                    },
                    source = "always"
                }
                local dialog = {
                    relative = "win",
                    win = vim.api.nvim_get_current_win(),
                    anchor = "NW",
                    row = diagnosticsRow,
                    col = diagnosticsColumn,
                    focusable = false,
                    title = "Line Diagnostics",
                    title_pos = "center",
                    fixed = true,
                    border = "rounded"
                }
                local _, windownr = vim.diagnostic.open_float(hoverOpts,
                                                              secondaryOpts)
                if windownr ~= nil then
                    local config = vim.api.nvim_win_get_config(windownr)
                    config = vim.tbl_extend("force", config, dialog)
                    vim.api.nvim_win_set_config(windownr, config)
                end
            end
        })
    end
end

function code_lens(client, bufnr)
    local augroup_lens = vim.api.nvim_create_augroup("LSPCodeLens",
                                                     {clear = true})
    local codelens = require("config.codelens")

    -- Code Lens provider config
    if client.server_capabilities.codeLensProvider then
        vim.api
            .nvim_create_autocmd( -- {"BufEnter", "InsertLeave", "LspAttach"}, {
        {"SafeState"}, {
            buffer = bufnr,
            group = augroup_lens,
            callback = function()
                codelens.refresh()
                local lenses = codelens.get(bufnr)
                codelens.display(lenses, bufnr, client.id)
            end
        })
    end
end

function inlay_hints(client, bufnr)
    local augroup_inlay = vim.api.nvim_create_augroup("LSPInlayHint",
                                                      {clear = true})
    -- Inlay Hint provider config
    -- Only turn on inlay hints when not in Insert mode
    if client.server_capabilities.inlayHintProvider then
        vim.api.nvim_create_autocmd({"BufEnter", "InsertLeave", "LspAttach"}, {
            buffer = bufnr,
            group = augroup_inlay,
            callback = function()
                vim.g.inlay_hints_visible = true
                vim.lsp.inlay_hint.enable(true, {bufnr})
            end
        })
        vim.api.nvim_create_autocmd({"InsertEnter"}, {
            buffer = bufnr,
            group = augroup_inlay,
            callback = function()
                vim.g.inlay_hints_visible = false
                vim.lsp.inlay_hint.enable(false, {bufnr})
            end
        })
    else
        print("no inlay hints available")
    end
end
