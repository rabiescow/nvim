return {
    cmd = {'vscode-eslint-language-server', '--stdio'},
    filetypes = {
        'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
        'graphql'
    },
    root_markers = {
        '.eslintrc', '.eslintrc.js', '.eslintrc.json', 'eslint.config.js',
        'eslint.config.mjs'
    },
    settings = {
        validate = 'on',
        packageManager = nil,
        useESLintClass = false,
        experimental = {useFlatConfig = false},
        codeActionOnSave = {enable = false, mode = 'all'},
        format = false,
        quiet = false,
        onIgnoredFiles = 'off',
        options = {},
        rulesCustomizations = {},
        run = 'onType',
        problems = {shortenToSingleLine = false},
        nodePath = '',
        workingDirectory = {mode = 'location'},
        codeAction = {
            disableRuleComment = {enable = true, location = 'separateLine'},
            showDocumentation = {enable = true}
        }
    },
    before_init = function(params, config)
        -- Set the workspace folder setting for correct search of tsconfig.json files etc.
        config.settings.workspaceFolder = {
            uri = params.rootPath,
            name = vim.fn.fnamemodify(params.rootPath, ':t')
        }
    end,
    ---@type table<string, lsp.Handler>
    handlers = {
        ['eslint/openDoc'] = function(_, params)
            vim.ui.open(params.url)
            return {}
        end,
        ['eslint/probeFailed'] = function()
            vim.notify('LSP[eslint]: Probe failed.', vim.log.levels.WARN)
            return {}
        end,
        ['eslint/noLibrary'] = function()
            vim.notify('LSP[eslint]: Unable to load ESLint library.',
                       vim.log.levels.WARN)
            return {}
        end
    },
    single_file_support = true,
    capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol
                                           .make_client_capabilities(),
                                       require("blink.cmp").get_lsp_capabilities(),
                                       {
        fileOperations = {didRename = true, willRename = true}
    }),
    on_attach = function(client, bufnr)
        code_lens(client, bufnr)
        inlay_hints(client, bufnr)
        inline_float_diagnostics(client, bufnr)
    end
}
