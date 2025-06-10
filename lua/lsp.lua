vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = "*",
    callback = function(args)
        local servers = {
            go = "gopls",
            lua = "lua_ls",
            ocaml = "ocamllsp",
            c = "clangd",
            cpp = "clangd",
            elixir = "elixirls",
            erlang = "erlangls",
            fish = "fish_lsp",
            fortran = "fortls",
            haskell = "hls",
            html = "html",
            hypr = "hyprls",
            javascript = "eslint",
            json = "jsonls",
            markdown = "marksman",
            php = "intelephense",
            python = "pyright",
            rust = "rustanalyzer",
            toml = "taplo",
            typescript = "ts_ls",
            yaml = "yamlls",
            zig = "zls"
        }
        local filetype = args.match
        local server = servers[filetype]
        if server then vim.lsp.enable(server, {bufnr = args.buf}) end
    end
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
