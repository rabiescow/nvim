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
