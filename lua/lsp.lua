vim.lsp.enable({
    "gopls", "lua_ls", "ocamllsp", "clangd", "elixirls", "erlangls", "eslint",
    "fish_lsp", "fortls", "hls", "html", "hyprls", "jsonls", "pyright",
    "rustanalyzer", "taplo", "ts_ls", "yamlls", "zls"
})

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = "󰠠 "
        }
    },
    virtual_text = false,
    virtual_lines = true
})
