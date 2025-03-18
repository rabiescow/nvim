return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        ocaml = { "ocamlformat" },
        rust = { "rustfmt" },
        sql = { "sql_formatter" },
        zig = { "zigfmt" },
        xml = { "xmlformat" },
        json = { "jq" },
        yaml = { "yamlfmt" },
        lua = { "stylua" },
        python = { "isort", "black" },
        go = { "gofmt" },
        elm = { "elm_format" },
        dart = { "dart_format" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      })
    end, {
      desc = "Format file or range (in visual mode)",
    })
  end,
}
