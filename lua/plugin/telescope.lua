return {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
        {"nvim-lua/plenary.nvim"}, {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function() return vim.fn.executable("make") == 1 end
        }, {"nvim-tree/nvim-web-devicons"},
        {"nvim-telescope/telescope-ui-select.nvim"},
        {"mrloop/telescope-git-branch.nvim"},
        {"nvim-telescope/telescope-media-files.nvim"},
        {"ghassan0/telescope-glyph.nvim"},
        {"Slotos/telescope-lsp-handlers.nvim"},
        {"jvgrootveld/telescope-zoxide"}, {"nvim-lua/popup.nvim"},
        {"nvim-lua/plenary.nvim"}, {"j-hui/fidget.nvim"}
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local key = vim.keymap.set

        telescope.setup({
            defaults = {
                path_display = {"truncate "},
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-j>"] = actions.move_selection_next, -- move to next result
                        ["<C-q>"] = actions.send_selected_to_qflist +
                            actions.open_qflist
                    }
                }
            },
            extensions = {
                ["ui-select"] = {require("telescope.themes").get_dropdown()}

            }
        })

        telescope.load_extension("glyph")
        telescope.load_extension("media_files")
        telescope.load_extension("git_branch")
        telescope.load_extension("fzf")
        telescope.load_extension("ui-select")
        telescope.load_extension("zoxide")
        telescope.load_extension("fidget")

        -- See `:help telescope.builtin`
        local builtin = require("telescope.builtin")
        key("n", "<leader>sy", "<CMD>Telescope glyph<CR>",
            {desc = "[S]earch Gl[y]ph"})
        key("n", "<leader>sm", "<CMD>Telescope media_files<CR>",
            {desc = "[S]earch [M]edia Files"})
        key("n", "<leader>si", "<CMD>Telescope git_branch<CR>",
            {desc = "[S]earch G[i]t Branch"})
        key("n", "<leader>sh", builtin.help_tags, {desc = "[S]earch [H]elp"})
        key("n", "<leader>sk", builtin.keymaps, {desc = "[S]earch [K]eymaps"})
        key("n", "<leader>sf", builtin.find_files, {desc = "[S]earch [F]iles"})
        key("n", "<leader>ss", builtin.builtin,
            {desc = "[S]earch [S]elect Telescope"})
        key("n", "<leader>sw", builtin.grep_string,
            {desc = "[S]earch current [W]ord"})
        key("n", "<leader>sg", builtin.live_grep, {desc = "[S]earch by [G]rep"})
        key("n", "<leader>sd", builtin.diagnostics,
            {desc = "[S]earch [D]iagnostics"})
        key("n", "<leader>sr", builtin.resume, {desc = "[S]earch [R]esume"})
        key("n", "<leader>s.", builtin.oldfiles,
            {desc = '[S]earch Recent Files ("." for repeat)'})
        key("n", "<leader><leader>", builtin.buffers,
            {desc = "[ ] Find existing buffers"})

        -- Slightly advanced example of overriding default behavior and theme
        key("n", "<leader>/", function()
            -- You can pass additional configuration to telescope to change theme, layout, etc.
            builtin.current_buffer_fuzzy_find(
                require("telescope.themes").get_dropdown({
                    winblend = 10,
                    previewer = false
                }))
        end, {desc = "[/] Fuzzily search in current buffer"})

        -- Also possible to pass additional configuration options.
        --  See `:help telescope.builtin.live_grep()` for information about particular keys
        key("n", "<leader>s/", function()
            builtin.live_grep({
                grep_open_files = true,
                prompt_title = "Live Grep in Open Files"
            })
        end, {desc = "[S]earch [/] in Open Files"})

        -- Shortcut for searching your neovim configuration files
        key("n", "<leader>sn", function()
            builtin.find_files({cwd = vim.fn.stdpath("config")})
        end, {desc = "[S]earch [N]eovim files"})
    end
}
