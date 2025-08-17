return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")

			dap.configurations.c = {
				{
					name = "Launch",
					type = "gdb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopAtBeginningOfMainSubprogram = false,
				},
				{
					name = "Select and attach to process",
					type = "gdb",
					request = "attach",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					pid = function()
						local name = vim.fn.input("Executable name (filter): ")
						return require("dap.utils").pick_process({ filter = name })
					end,
					cwd = "${workspaceFolder}",
				},
				{
					name = "Attach to gdbserver :1234",
					type = "gdb",
					request = "attach",
					target = "localhost:1234",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
				},
			}

			dap.adapters["local-lua"] = {
				type = "executable",
				command = "node",
				args = {
					vim.fn.environ()["HOME"]
						.. "/.vscode/extensions/tomblind.local-lua-debugger-vscode-0.3.3-universal/extension/debugAdapter.js",
				},
				enrich_config = function(config, on_config)
					if not config["extensionPath"] then
						local c = vim.deepcopy(config)
						-- 💀 If this is missing or wrong you'll see
						-- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
						c.extensionPath = vim.fn.environ()["HOME"]
							.. "/.vscode/extensions/tomblind.local-lua-debugger-vscode-0.3.3-universal/"
						on_config(c)
					else
						on_config(config)
					end
				end,
			}

			dap.adapters.ocamlearlybird = {
				type = "executable",
				command = "ocamlearlybird",
				args = { "debug" },
			}

			dap.configurations.ocaml = {
				{
					name = "OCaml Debug test.bc",
					type = "ocamlearlybird",
					request = "launch",
					program = "${workspaceFolder}/_build/default/test/test.bc",
				},
				{
					name = "OCaml Debug main.bc",
					type = "ocamlearlybird",
					request = "launch",
					program = "${workspaceFolder}/_build/default/bin/main.bc",
				},
			}
		end,
	},
	{
		"miroshQa/debugmaster.nvim",
		config = function()
			local dm = require("debugmaster")
			-- make sure you don't have any other keymaps that starts with "<leader>d" to avoid delay
			vim.keymap.set({ "n", "v" }, "<F2>", dm.mode.toggle, { nowait = true })
			vim.keymap.set("t", "<C-/>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

			vim.api.nvim_set_hl(0, "dCursor", { bg = "#FF2C2C" })
		end,
	},
}
