return {
    cmd = {
        'clangd', '--clang-tidy', '--header-insertion=iwyu',
        '--completion-style=detailed', '--fallback-style=none',
        '--function-arg-placeholders=false'
    },
    filetypes = {"c", "cpp", "objc", "objcpp", "cuda"},
    root_markers = {
        ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json",
        "compile_flags.txt", "configure.ac", ".git", "CMakeList.txt", "CMake*"
    },
    single_file_support = true,
    capabilities = get_complete_capabilities(),
    on_attach = attach
}
