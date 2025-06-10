return {
    cmd = {
        "fortls", "--incremental_sync", "--notify_init",
        "--recursion_limit 1000", "--lowercase_intrinsics",
        "--use_signature_help", "--variable_hover", "--hover_signature",
        "--hover_language=fortran", "--enable_code_actions"
    },
    single_file_support = true,
    capabilities = get_complete_capabilities(),
    on_attach = function(client, bufnr)
        code_lens(client, bufnr)
        inlay_hints(client, bufnr)
    end
}
