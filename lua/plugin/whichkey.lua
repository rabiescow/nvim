return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 500
    end,
    opts = {
        mode = "n",
        prefix = "",
        buffer = nil,
        silent = true,
        noremap = true,
        nowait = false,
        expr = false
    },
    plugins = {
        marks = true,
        registers = true,
        spelling = {enabled = true, suggestions = 20},
        presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true
        }
    },
    operators = {gc = "Comments"},
    key_labels = {
        ["<SPACE>"] = "SPACE",
        ["<CR>"] = "RETURN",
        ["<TAB>"] = "TAB",
        ["<C>"] = "CONTROL",
        ["<A>"] = "ALT"
    },
    motions = {count = true},
    icons = {
        breadcrumb = "󰁙 ", -- symbol used in the command line area that shows your active key combo
        separator = "➜ ", -- symbol used between a key and it's label
        group = " " -- symbol prepended to a group
    },
    popup_mappings = {
        scroll_down = "<C-d>", -- binding to scroll down inside the popup
        scroll_up = "<C-u>" -- binding to scroll up inside the popup
    },
    window = {
        border = "single", -- none, single, double, shadow
        position = "top", -- bottom, top
        margin = {1, 0, 1, 0}, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
        padding = {1, 2, 1, 2}, -- extra window padding [top, right, bottom, left]
        winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
        zindex = 1000 -- positive value to position WhichKey above other floating windows.
    },
    layout = {
        height = {min = 4, max = 25}, -- min and max height of the columns
        width = {min = 20, max = 50}, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "center" -- align columns left, center or right
    },
    ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
    hidden = {
        "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua "
    }, -- hide mapping boilerplate
    show_help = true, -- show a help message in the command line for using WhichKey
    show_keys = true, -- show the currently pressed key and its label as a message in the command line
    triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specifiy a list manually
    -- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
    triggers_nowait = {
        -- marks
        "`", "'", "g`", "g'", -- registers
        '"', "<C-r>", -- spelling
        "z="
    },
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for keymaps that start with a native binding
        i = {"j", "k"},
        v = {"j", "k"}
    },
    -- disable the WhichKey popup for certain buf types and file types.
    -- Disabled by default for Telescope
    disable = {buftypes = {}, filetypes = {}}
}
