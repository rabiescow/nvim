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
                    underdotted = true,
                    underdashed = false,
                    strikethrough = false,
                    bold = false,
                    italic = false,
                    bg = "#32333B",
                    fg = "#E6E7A3",
                    sp = "#479FFA",
                    blend = 60,
                    reverse = false,
                    standout = false,
                    -- font = "altfont",
                    nocombine = true
                    -- font = "VictorMono Nerd Font Propo"
                }
            }
        })
    end
}
