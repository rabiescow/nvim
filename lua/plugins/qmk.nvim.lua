return {
    "codethread/qmk.nvim",
    config = function()
        ---@type qmk.UserConfig
        local conf = {
            name = 'LAYOUT_preonic_grid', -- identify your layout name
            comment_preview = {
                keymap_overrides = {
                    HERE_BE_A_LONG_KEY = 'Magic' -- replace any long key codes
                }
            },
            layout = {
                '_ x x x x x x _ x x x x x x', '_ x x x x x x _ x x x x x x',
                '_ x x x x x x _ x x x x x x', '_ x x x x x x _ x x x x x x',
                '_ x x x x x x _ x x x x x x'
            }
        }
        require('qmk').setup(conf)
    end
}
