return {
  "yamatsum/nvim-cursorline",
  config = function()
    require("nvim-cursorline").setup({
      cursorline = {
        enable = true,
        timeout = 300,
        number = false,
      },
      cursorword = {
        enable = true,
        min_length = 6,
        hl = {
          underline = false,
          bold = false,
          italic = true,
          bg = "#393552",
          fg = "#4DB853",
          sp = "#393552",
          blend = 60,
          reverse = false,
        },
      },
    })
  end,
}
