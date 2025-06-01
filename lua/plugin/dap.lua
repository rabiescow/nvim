return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require "dap"

            dap.configurations.c = {
                {
                    name = "Launch",
                    type = "gdb",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to executable: ',
                                            vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtBeginningOfMainSubprogram = false
                }, {
                    name = "Select and attach to process",
                    type = "gdb",
                    request = "attach",
                    program = function()
                        return vim.fn.input('Path to executable: ',
                                            vim.fn.getcwd() .. '/', 'file')
                    end,
                    pid = function()
                        local name = vim.fn.input('Executable name (filter): ')
                        return
                            require("dap.utils").pick_process({filter = name})
                    end,
                    cwd = '${workspaceFolder}'
                }, {
                    name = 'Attach to gdbserver :1234',
                    type = 'gdb',
                    request = 'attach',
                    target = 'localhost:1234',
                    program = function()
                        return vim.fn.input('Path to executable: ',
                                            vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}'
                }
            }

            dap.adapters.haskell = {
                type = 'executable',
                command = 'haskell-debug-adapter',
                args = {'--hackage-version=0.0.33.0'}
            }
            dap.configurations.haskell = {
                {
                    type = 'haskell',
                    request = 'launch',
                    name = 'Debug',
                    workspace = '${workspaceFolder}',
                    startup = "${file}",
                    stopOnEntry = true,
                    logFile = vim.fn.stdpath('data') .. '/haskell-dap.log',
                    logLevel = 'WARNING',
                    ghciEnv = vim.empty_dict(),
                    ghciPrompt = "λ: ",
                    -- Adjust the prompt to the prompt you see when you invoke the stack ghci command below 
                    ghciInitialPrompt = "λ: ",
                    ghciCmd = "stack ghci --test --no-load --no-build --main-is TARGET --ghci-options -fprint-evld-with-show"
                }
            }

            dap.adapters["local-lua"] = {
                type = "executable",
                command = "node",
                args = {
                    "/absolute/path/to/local-lua-debugger-vscode/extension/debugAdapter.js"
                },
                enrich_config = function(config, on_config)
                    if not config["extensionPath"] then
                        local c = vim.deepcopy(config)
                        -- 💀 If this is missing or wrong you'll see 
                        -- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
                        c.extensionPath =
                            "/absolute/path/to/local-lua-debugger-vscode/"
                        on_config(c)
                    else
                        on_config(config)
                    end
                end
            }

            dap.adapters.ocamlearlybird = {
                type = 'executable',
                command = 'ocamlearlybird',
                args = {'debug'}
            }

            dap.configurations.ocaml = {
                {
                    name = 'OCaml Debug test.bc',
                    type = 'ocamlearlybird',
                    request = 'launch',
                    program = '${workspaceFolder}/_build/default/test/test.bc'
                }, {
                    name = 'OCaml Debug main.bc',
                    type = 'ocamlearlybird',
                    request = 'launch',
                    program = '${workspaceFolder}/_build/default/bin/main.bc'
                }
            }
        end
    }, {
        "miroshQa/debugmaster.nvim",
        config = function()
            local dm = require("debugmaster")
            -- make sure you don't have any other keymaps that starts with "<leader>d" to avoid delay
            vim.keymap.set({"n", "v"}, "<F2>", dm.mode.toggle, {nowait = true})
            vim.keymap.set("t", "<C-/>", "<C-\\><C-n>",
                           {desc = "Exit terminal mode"})

            vim.api.nvim_set_hl(0, "dCursor", {bg = "#FF2C2C"})
        end
    }
}
