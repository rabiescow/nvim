-- return {}
return {
    "numToStr/Comment.nvim",
    event = {"BufEnter"},
    dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
            require("ts_context_commentstring").setup({enable_autocmd = false})
        end
    },
    config = function()
        -- import comment plugin safely
        require("Comment").setup({
            -- Add a space between comment and line
            padding = true,
            -- Line or Block comments
            toggler = {line = "gcc", block = "gbc"},
            opleader = {line = "gc", block = "gb"},
            extra = {above = "gco", below = "gcu", eol = "gce"},
            mappings = {basic = true, extra = true},
            -- function to call before (un)comment
            pre_hook = require(
                "ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            -- function to call after (un)comment
            post_hook = function(_) end,
            sticky = false,
            ignore = "just random stupid string$"
        })
    end
}
