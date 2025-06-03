return {
    cmd = {"fish-lsp", "start"},
    cmd_env = {fish_lsp_show_client_popups = false},
    filetypes = {"fish"},
    single_file_support = true,
    capabilities = get_complete_capabilities(),
    on_attach = function(client, bufnr)
        code_lens(client, bufnr)
        inlay_hints(client, bufnr)
    end
}
