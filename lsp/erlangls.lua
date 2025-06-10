return {
    cmd = {"erlang_ls"},
    filetypes = {"erlang"},
    root_markers = {'rebar.config', 'erlang.mk', '.git'},
    capabilities = get_complete_capabilities(),
    on_attach = on_attach
}
