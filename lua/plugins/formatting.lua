return {
  "stevearc/conform.nvim",
  event = { "BufWritePre", "BufReadPre", "BufNewFile" },
  cmd = { "ConformInfo" },
  keys = {
    {
      -- Customize or remove this keymap to your liking
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    ft_parsers = {
      jsonc = "json",
    },
    formatters_by_ft = {
      dart = { "dart_format" },
      dune = { "format-dune-file" },
      elm = { "elm_format" },
      fish = { "fish_indent" },
      go = { "goimports", "gofmt", "golines" },
      haskell = { "hindent" },
      html = { "html_beautify" },
      java = { "google-java-format" },
      json = { "fixjson", "jq" },
      lua = { "lua-format", "stylua" },
      markdown = { "markdownfmt", "markdownlint" },
      ocaml = { "ocp-indent", "ocamlformat" },
      python = { "isort", "black" },
      rust = { "rustfmt", lsp_format = "fallback" },
      sql = { "sql_formatter" },
      xml = { "xmlformatter", "xmllint" },
      yaml = { "yamlfix", "yamlfmt" },
      zig = { "zigfmt" },
    },
    default_format_opts = {
      lsp_format = "fallback",
      stop_after_first = true,
    },
    format_on_save = {
      lsp_format = "fallback",
      timeout_ms = 500,
    },
    format_after_save = {
      lsp_format = "fallback",
    },
    notify_on_error = true,
    notify_no_formatters = true,
    formatters = {
      ocamlformat = {
        prepend_args = {
          "--if-then-else",
          "--vertical",
          "--break-cases",
          "fit-or-vertical",
          "--type-decl",
          "--sparse",
        },
      },
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require.'conform'.formatexpr()"
  end
}
