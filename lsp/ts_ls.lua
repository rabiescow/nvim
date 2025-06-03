return {
    init_options = {hostInfo = "neovim"},
    cmd = {"typescript-language-server", "--stdio"},
    filetypes = {
        "javascript", "javascriptreact", "javascript.jsx", "typescript",
        "typescriptreact", "typescript.tsx"
    },
    root_markers = {"tsconfig.json", "jsconfig.json", "package.json", ".git"},
    single_file_support = true,
    capabilities = get_complete_capabilities(),
    on_attach = function(client, bufnr)
        code_lens(client, bufnr)
        inlay_hints(client, bufnr)
    end
}
