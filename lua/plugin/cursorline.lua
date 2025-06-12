return {
    "yamatsum/nvim-cursorline",
    config = function()
        require("nvim-cursorline").setup({
            cursorline = {enable = true, timeout = 300, number = true},
            cursorword = {
                enable = true,
                min_length = 5,
                hl = {
                    underline = false,
                    undercurl = false,
                    underdouble = false,
                    underdotted = false,
                    underdashed = false,
                    strikethrough = false,
                    bold = true,
                    italic = false,
                    bg = "#A6E3A1",
                    fg = "#313244",
                    sp = "#94e2d5",
                    blend = 60,
                    reverse = true,
                    standout = false,
                    -- font = "altfont",
                    nocombine = true
                    -- font = "VictorMono Nerd Font Propo"
                }
            }
        })
    end
}
