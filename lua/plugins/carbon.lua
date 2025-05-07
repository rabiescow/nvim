return {
    "ellisonleao/carbon-now.nvim",
    lazy = true,
    cmd = "CarbonNow",
    config = function()
        require("carbon-now").setup({
            base_url = "https://carbon.now.sh/",
            options = {
                bg = "black",
                drop_shadow = true,
                drop_shadow_blur = "70px",
                drop_shadow_offset_y = "20px",
                font_family = "Space Mono",
                font_size = "20px",
                line_height = "150%",
                line_numbers = true,
                theme = "Darcula Pro",
                titlebar = "RabiesCow: NeoVim Code Snippet",
                watermark = false,
                width = "680",
                window_theme = "sharp"
            }
        })
    end
}
