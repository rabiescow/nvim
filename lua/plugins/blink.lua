return {
  "Saghen/blink.cmp",
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = "*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = 'default' },
    appearance = {
      nerd_font_variant = "mono",
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = {
      implementation = "prefer_rust_with_warning",
      prebuilt_binaries = {
        download = true,
        ignore_version_mismatch = true,
      }
    },
  },
  opts_extend = { "sources.default" }
}
