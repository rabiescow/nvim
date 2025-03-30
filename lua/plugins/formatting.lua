return {
  "stevearc/conform.nvim",
  event = { "BufWritePre", "BufReadPre", "BufNewFile" },
  cmd = { "ConformInfo" },
  keys = {
    {
      -- Customize or remove this keymap to your liking
      "<leader>f",
      function()
        require("conform").format({ async = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- config = function()
    -- require("conform").setup({
    formatters_by_ft = {
      ocaml = { "ocamlformat" },
      rust = { "rustfmt", lsp_format = "fallback" },
      sql = { "sql_formatter" },
      zig = { "zigfmt" },
      xml = { "xmlformat" },
      json = { "jq" },
      yaml = { "yamlfmt" },
      lua = { "stylua" },
      python = { "isort", "black" },
      go = { "goimports", "gofmt" },
      elm = { "elm_format" },
      dart = { "dart_format" },
    },
    format_on_save = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 500,
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
  }
  -- )

  -- vim.keymap.set({ "n", "v" }, "<leader>f", function()
  --   conform.format({
  --     lsp_fallback = true,
  --     async = true,
  --     timeout_ms = 500,
  --   })
  -- end, {
  --   desc = "Format file or range (in visual mode)",
  -- })
  -- end,
}
