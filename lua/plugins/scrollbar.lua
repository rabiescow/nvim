return {
    "petertriho/nvim-scrollbar",
    dependencies = {},
    config = function()
        require("scrollbar").setup({
            handle = {color = "#545468"},
            marks = {
                Search = {color = "#131343"},
                Error = {color = "#B83434"},
                Warn = {color = "#B87834"},
                Info = {color = "#B3A3C3"},
                Hint = {color = "#3434B8"},
                Misc = {color = "#232323"}
            }
        })
    end
}
