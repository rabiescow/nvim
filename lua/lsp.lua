vim.lsp.enable({
    "gopls", "lua_ls", "ocamllsp", "clangd", "elixirls", "erlangls", "fish_lsp",
    "hls", "html", "jsonls", "rustanalyzer", "taplo", "yamlls", "zls"
    -- , "eslint", "fortls", "hyprls", "pyright", "ts_ls"
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
    virtual_lines = false
})
