-- Start up individual LSP servers when the corresponding filetype is detected
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = "*",
	callback = function(args)
		local servers = {
			bash = "bashls",
			c = "clangd",
			cpp = "clangd",
			dart = "dart",
			elixir = "elixirls",
			erlang = "erlangls",
			fish = "fish_lsp",
			fortran = "fortls",
			go = "gopls",
			haskell = "hls",
			html = "html",
			hypr = "hyprls",
			javascript = "ts_ls",
			json = "jsonls",
			lua = "lua_ls",
			markdown = "marksman",
			ocaml = "ocamllsp",
			python = "pyright",
			qml = "qmlls",
			rust = "rustanalyzer",
			toml = "taplo",
			typescript = "ts_ls",
			yaml = "yamlls",
			zig = "zls",
		}
		local filetype = args.match
		local server = servers[filetype]
		if server then
			vim.notify("Detected filetype: " .. filetype .. ", server: " .. server)
			vim.lsp.enable(server, true)
		end
	end,
})

-- Shut down clients when neovim closes
vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
	group = vim.api.nvim_create_augroup("LspShutdown", { clear = true }),
	pattern = "*",
	desc = "Shuts down all active LSP servers",
	callback = function()
		local active_clients = vim.lsp.get_clients()
		if vim.tbl_isempty(active_clients) then
			return
		end
		for _, client in ipairs(active_clients) do
			vim.lsp.enable(client.name, false)
		end
		vim.wait(200)
	end,
})

-- Display settings for LSP diagnostics messages
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
		},
	},
	virtual_text = false,
	virtual_lines = false,
})
