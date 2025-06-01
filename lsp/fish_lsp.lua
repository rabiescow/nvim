return {

    cmd = {"fish-lsp", "start"},
    cmd_env = {fish_lsp_show_client_popups = false},
    filetypes = {"fish"},
    root_dir = function(fname)
        return vim.fs.dirname(
                   vim.fs.find(".git", {path = fname, upward = true})[1])
    end,
    single_file_support = true,
    capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol
                                           .make_client_capabilities(),
                                       require("blink.cmp").get_lsp_capabilities(),
                                       {
        fileOperations = {didRename = true, willRename = true}
    }),
    on_attach = function(client, bufnr)
        code_lens(client, bufnr)
        inlay_hints(client, bufnr)
        inline_float_diagnostics(client, bufnr)
    end
}
