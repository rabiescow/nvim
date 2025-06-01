return {
    cmd = {"haskell-language-server-wrapper", "--lsp"},
    filetypes = {"haskell", "lhaskell"},
    root_markers = {
        "hie.yaml", "stack.yaml", "cabal.project", "*.cabal", "package.yaml"
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
