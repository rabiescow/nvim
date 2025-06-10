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
    capabilities = get_complete_capabilities(),
    on_attach = on_attach
}
