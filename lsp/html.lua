return {
    cmd = {'vscode-html-language-server', '--stdio'},
    filetypes = {'html'},
    embeddedLanguages = {css = true, javascript = true},
    single_file_support = true,
    capabilities = get_complete_capabilities(),
    on_attach = function(client, bufnr)
        code_lens(client, bufnr)
        inlay_hints(client, bufnr)
    end
}
