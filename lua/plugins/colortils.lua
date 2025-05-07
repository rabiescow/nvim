return {
    "max397574/colortils.nvim",
    config = function()
        require("colortils").setup({
            register = "unnamedplus",
            color_preview = "█████ %s",
            default_format = "hex",
            default_color = "#000000",
            border = "rounded",
            mappings = {
                increment = "l",
                decrement = "h",
                increment_big = "L",
                decrement_big = "H",
                min_value = "0",
                max_value = "$",
                set_register_default_format = "<cr>",
                set_register_choose_format = "g<cr>",
                replace_default_format = "<m-cr>",
                replace_choose_format = "g<m-cr>",
                export = "E",
                set_value = "c",
                transparency = "T",
                choose_background = "B",
                quit_window = {"q", "<esc>"}
            }
        })
    end
}
