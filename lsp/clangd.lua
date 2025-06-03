return {
    cmd = {
        'clangd', '--clang-tidy', '--header-insertion=iwyu',
        '--completion-style=detailed', '--fallback-style=none',
        '--function-arg-placeholders=false'
    },
    filetypes = {"c", "cpp", "objc", "objcpp", "cuda", "proto"},
    root_markers = {
        ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json",
        "compile_flags.txt", "configure.ac", ".git"
    },
    single_file_support = true,
    on_new_config = function(new_config, new_root_dir)
        if vim.fn.filereadable(vim.fs.joinpath(new_root_dir, "zls.json")) ~= 0 then
            new_config.cmd = {"zls", "--config-path", "zls.json"}
        end
    end,
    capabilities = get_complete_capabilities(),
    on_attach = function(client, bufnr)
        code_lens(client, bufnr)
        inlay_hints(client, bufnr)
    end
}
