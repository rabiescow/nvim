vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = "*",
    callback = function(args)
        local servers = {
            go = "gopls",
            lua = "lua_ls",
            ocaml = "ocamllsp",
            c = "clangd",
            elixir = "elixirls",
            erlang = "erlangls",
            fish = "fish_lsp",
            haskell = "hls",
            html = "html",
            json = "jsonls",
            rust = "rustanalyzer",
            toml = "taplo",
            yaml = "yamlls",
            zig = "zls",
            typescript = "ts_ls",
            javascript = "typescript_ls",
            markdown = "marksman",
            fortran = "fortls",
            hypr = "hyprls",
            python = "pyright",
            php = "intelephense",
            cpp = "clangd",
            objc = "clangd",
            objcpp = "clangd"
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
