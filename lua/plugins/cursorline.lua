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
        min_length = 5,
        hl = {
          underline = false,
          bold = true,
          italic = false,
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
