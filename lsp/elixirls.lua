return {
    cmd = {"elixir-ls"},
    -- cmd_env = {
    --     ELS_LOCAL = 1,
    --     ELS_INSTALL_PREFIX = "/usr/lib/elixir-ls",
    --     ASDF_DIR = "$HOME/.asdf"
    -- },
    filetypes = {"elixir", "eelixir", "heex", "surface"},
    root_dir = function(fname)
        local matches = vim.fs.find({'mix.exs'},
                                    {upward = true, limit = 2, path = fname})
        local child_or_root_path, maybe_umbrella_path = unpack(matches)
        local root_dir = vim.fs.dirname(maybe_umbrella_path or
                                            child_or_root_path)
        return root_dir
    end,
    root_markers = {".formatter.exs", ".elixir_ls", "mix.exs", ".git"},
    settings = {
        autoBuild = true,
        dialyzerEnabled = true,
        incrementalDialyzer = true,
        dialyzerWarnOpts = {
            "error_handling", "no_behaviours", "no_contracts", "no_fail_call",
            "no_fun_app", "no_improper_lists", "no_match", "no_missing_calls",
            "no_opaque", "no_return", "no_undefined_callbacks", "no_underspecs",
            "no_unknown", "no_unused", "underspecs", "unknown",
            "unmatched_returns", "overspecs", "specdiffs",
            "overlapping_contract", "extra_return", "no_extra_return",
            "missing_return", "no_missing_return", "opaque_union"
        },
        dialyzerFormat = "dialyxir_long",
        envVariables = "",
        mixEnv = "dev",
        mixTarget = "dev",
        projectDir = "dev",
        stdlibSrcDir = "",
        useCurrentRootFolderAsProjectDir = true,
        fetchDeps = true,
        suggestSpecs = true,
        trace = {server = "off"},
        autoInsertRequiredAlias = false,
        signatureAfterComplete = true,
        enableTestLenses = false,
        additionalWatchedExtensions = {},
        languageServerOverridePath = ""
    },
    single_file_support = true,
    capabilities = get_complete_capabilities(),
    on_attach = function(client, bufnr)
        code_lens(client, bufnr)
        inlay_hints(client, bufnr)
    end
}
