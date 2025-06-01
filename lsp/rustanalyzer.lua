return {
    cmd = {'rust-analyzer'},
    filetypes = {'rust'},
    root_markers = {'Cargo.toml', 'rust-project.json'},
    settings = {
        ['rust-analyzer'] = {
            inlayHints = {
                -- These are a bit too much.
                chainingHints = {enable = false}
            }
        }
    },
    capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol
                                           .make_client_capabilities(),
                                       require("blink.cmp").get_lsp_capabilities(),
                                       {
        fileOperations = {didRename = true, willRename = true}
    }),
    on_attach = function(client, bufnr)
        code_lens(client, bufnr)
        inlay_hints(client, bufnr)
        inline_float_diagnostics(client, bufnr)
    end
}
