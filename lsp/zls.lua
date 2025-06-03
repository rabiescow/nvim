return {
    cmd = {"zls"},
    filetypes = {'zig', 'zir'},
    root_markers = {"zls.json", "build.zig", ".git"},
    single_file_support = true,
    on_new_config = function(new_config, new_root_dir)
        if vim.fn.filereadable(vim.fs.joinpath(new_root_dir, "zls.json")) ~= 0 then
            new_config.cmd = {"zls", "--config-path", "zls.json"}
        end
    end,
    settings = {
        zls = {
            enable_build_on_save = false,
            semantic_tokens = "partial",
            zig_exe_path = "/usr/bin/zig"
        }
    },
    capabilities = get_complete_capabilities(),
    on_attach = function(client, bufnr)
        code_lens(client, bufnr)
        inlay_hints(client, bufnr)
    end
}
