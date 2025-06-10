return {
    "mfussenegger/nvim-lint",
    event = {"BufWritePost", "BufReadPost", "InsertLeave"},
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            erlang = {"elvis"},
            elixir = {"credo"},
            fortran = {"fortitude"},
            haskell = {"hlint"},
            javascript = {"eslint_d"},
            -- lua = {"luacheck", args = {"--read-globals vim require"}},
            python = {"pylint"},
            rust = {"clippy"},
            typescript = {"eslint_d"},
            sh = {"shellcheck"},
            bash = {"shellcheck"},
            yaml = {"yamllint"},
            markdown = {"markdownlint"}
        }
        vim.api.nvim_create_autocmd({"BufWritePost", "BufEnter", "InsertLeave"},
                                    {
            group = vim.api.nvim_create_augroup("linting", {clear = true}),
            callback = function() lint.try_lint() end
        })
    end
}
