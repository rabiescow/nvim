return {
    cmd = {"/usr/lib/elixir-ls/language_server.sh"},
    filetypes = {'elixir', 'eelixir', 'heex', 'surface'},
    root_markers = {'.formatter.exs', 'mix.exs', '.git'},
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
