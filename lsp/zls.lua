return {
    cmd = {"zls"},
    filetypes = {'zig', 'zir'},
    root_markers = {"zls.json", "build.zig", ".git"},
    single_file_support = true,
    on_new_config = function(new_config, new_root_dir)
        if vim.fn
            .filereadable(vim.fs.joinpath(new_root_dir, "zls.json")) ~=
            0 then
            new_config.cmd = {"zls", "--config-path", "zls.json"}
        end
    end,
    capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("blink.cmp").get_lsp_capabilities(),
        {
            fileOperations = {
                didRename = true,
                willRename = true,
            },
        }
    ),
    on_attach = function(client, bufnr)
        code_lens(client, bufnr)
        inlay_hints(client, bufnr)
        inline_float_diagnostics(client, bufnr)
    end,
}
