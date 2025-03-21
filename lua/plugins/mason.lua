return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  init = function()
    vim.api.nvim_set_var("enfocado_plugins", { "mason" })
  end,
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜ ",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "ocamllsp",
        "clangd",
        "elmls",
        "elixirls",
        "erlangls",
        "fortls",
        "gopls",
        "hls",
        "jsonls",
        "lua_ls",
        "pylsp",
        "serve_d",
        "sqlls",
        "sqls",
        "biome",
        "lemminx",
        "zls",
      },
      -- auto-install configured servers (with lspconfig)
      automatic_installation = true,
    })
  end,
}
