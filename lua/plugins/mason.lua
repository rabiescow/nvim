return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    mason.setup({
      ui = {
        icons = {
          package_installed = "",
          package_pending = "",
          package_uninstalled = "",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "asm_lsp",
        "ast_grep",
        "awk_ls",
        "bashls",
        "biome",
        "clangd",
        "clojure_lsp",
        "cmake",
        "cssls",
        -- "dartls",
        "elmls",
        "elixirls",
        "erlangls",
        -- "fish_lsp",
        "fortls",
        "gopls",
        "hls",
        "hyprls",
        -- "java_language_server",
        "jsonls",
        "lemminx",
        "lua_ls",
        "marksman",
        "ocamllsp",
        "pylsp",
        -- "r_language_server",
        "serve_d",
        "sqlls",
        "sqls",
        "ts_ls",
        -- "uiua",
        "vimls",
        "yamlls",
        "zls",
      },
      -- auto-install configured servers (with lspconfig)
      automatic_installation = true,
    })
  end,
}
