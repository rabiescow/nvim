return {
    cmd = {'vscode-json-language-server', '--stdio'},
    filetypes = {'json', 'jsonc'},
    settings = {
        json = {
            validate = {enable = true},
            schemas = require('schemastore').json.schemas()
        }
    },
    single_file_support = true,
    capabilities = get_complete_capabilities(),
    on_attach = on_attach
}
