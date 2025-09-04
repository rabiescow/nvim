return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "rcarriga/nvim-dap-ui", dependencies = "nvim-neotest/nvim-nio" },
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dap.adapters.gdb = {
				type = "executable",
				command = "gdb",
				args = { "-i", "dap" },
			}
			dap.adapters.delve = {
				type = "server",
				port = "${port}",
				executable = {
					command = "dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
				},
			}
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = "codelldb",
					args = { "--port", "${port}" },
				},
			}
			dap.adapters.python = {
				type = "executable",
				command = "python",
				args = { "-m", "debugpy.adapter" },
			}
			dap.adapters.elixir = {
				type = "executable",
				command = "bash",
				args = { vim.fn.stdpath("data") .. "/mason/packages/elixir-ls/launch.sh" },
			}
			dap.adapters.ruby = {
				type = "executable",
				command = "rdbg",
				args = { "--open", "--", "bundle", "exec", "rdebug-ide" },
			}
			dap.adapters.perl = {
				type = "executable",
				command = "perl",
				args = { "-d:Camelcadedb", "-e", "0" },
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

			local function get_program()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end

			dap.configurations.c = {
				{
					name = "Launch",
					type = "gdb",
					request = "launch",
					program = get_program,
					cwd = "${workspaceFolder}",
					stopAtBeginningOfMainSubprogram = false,
				},
			}
			dap.configurations.cpp = dap.configurations.c
			dap.configurations.fortran = dap.configurations.c
			dap.configurations.zig = dap.configurations.c

			dap.configurations.rust = {
				{
					name = "Launch",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input(
							"Path to executable (e.g. target/debug/<bin-name>): ",
							"target/debug/",
							"file"
						)
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}
			dap.configurations.go = {
				{
					type = "delve",
					name = "Launch",
					request = "launch",
					program = "${fileDirname}",
					cwd = "${workspaceFolder}",
				},
			}
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					pythonPath = function()
						return vim.fn.exepath("python")
					end,
				},
			}
			dap.configurations.ruby = {
				{
					type = "ruby",
					name = "Launch",
					request = "launch",
					program = vim.fn.expand("%:p"),
					cwd = vim.fn.expand("%:p:h"),
					stopOnEntry = true,
				},
			}
			dap.configurations.perl = {
				{
					type = "perl",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					stopOnEntry = true,
				},
			}
			dap.configurations.elixir = {
				{
					type = "elixir",
					request = "launch",
					name = "Launch",
					projectDir = vim.fn.getcwd(),
					task = "test", -- or "run", "phx.server", etc.
					-- taskArgs = {"--trace"},
				},
			}
			dap.configurations.erlang = dap.configurations.elixir
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
			dap.configurations.lua = {
				{
					type = "local-lua",
					request = "launch",
					name = "Launch file",
					program = {
						path = "${file}",
					},
					cwd = "${workspaceFolder}",
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

			vim.api.nvim_set_hl(0, "dCursor", { bg = "#F38BA8" })
		end,
	},
}
