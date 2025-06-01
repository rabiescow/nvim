return {
    cmd = {'taplo', 'lsp', 'stdio'},
    filetypes = {'toml'},
    root_markers = {'.git'},

    settings = {
        taplo = {
            configFile = {enabled = true},
            schema = {
                enabled = true,
                catalogs = {'https://www.schemastore.org/api/json/catalog.json'},
                cache = {memoryExpiration = 60, diskExpiration = 600}
            }
        }
    },
    single_file_support = true,
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
