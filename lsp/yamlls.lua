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
