return {
    cmd = {"yaml-language-server", "--stdio"},
    filetypes = {"yaml"},
    settings = {
        yaml = {
            -- Using the schemastore plugin for schemas.
            schemastore = {enable = false, url = ''},
            schemas = require('schemastore').yaml.schemas()
        }
    },
    single_file_support = true,
    capabilities = get_complete_capabilities(),
    on_attach = function(client, bufnr)
        code_lens(client, bufnr)
        inlay_hints(client, bufnr)
    end
}
