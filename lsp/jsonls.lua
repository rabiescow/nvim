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
    on_attach = function(client, bufnr)
        code_lens(client, bufnr)
        inlay_hints(client, bufnr)
    end
}
