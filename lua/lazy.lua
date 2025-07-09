local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	root = vim.fn.stdpath("data") .. "/lazy",
	defaults = {
		lazy = false,
		version = nil,
		cond = nil,
	},
	spec = {
		{ import = "plugin" },
		{ import = "theme" },
	},
	lock_file = vim.fn.stdpath("config") .. "/lazy-lock.json",
	concurrency = tonumber(vim.fn.system("nproc")),
	git = {
		log = { "-8" },
		timeout = 120,
		url_format = "https://www.github.com/%s.git",
		filter = true,
		throttle = {
			enabled = false,
			rate = 2, -- max 2 ops every 5 seconds
			duration = 5 * 1000, -- in ms
		},
		cooldown = 0,
	},
	pkg = {
		enabled = true,
		root = vim.fn.stdpath("state") .. "/lazy/.pkg-cache.lua",
		server = "https://nvim-neorocks.github.io/rocks-binaries/",
		hererocks = nil,
	},
	dev = {
		path = "~/dev/lua/nvim",
		patterns = {},
		fallback = false,
	},
	install = {
		missing = true,
		colorscheme = { "catppuccin", "tokyonight", "habamax" },
	},
	ui = {
		size = { width = 0.9, height = 0.9 },
		wrap = true,
		border = "single",
		backdrop = 60,
		title = "Lazy Plugin Manager",
		title_pos = "center",
		pills = true,

		icons = {
			cmd = " ",
			config = "",
			debug = "● ",
			event = " ",
			favorite = " ",
			ft = " ",
			init = " ",
			import = " ",
			keys = " ",
			lazy = "󰒲 ",
			loaded = "●",
			not_loaded = "○",
			plugin = " ",
			runtime = " ",
			require = "󰢱 ",
			source = " ",
			start = " ",
			task = "✔ ",
			list = {
				"●",
				"➜",
				"★",
				"‒",
			},
		},
	},
	browser = nil,
	throttle = 1000 / 30,
	custom_keys = {

		["<localleader>l"] = {
			function(plugin)
				require("lazy.util").float_term({ "lazygit", "log" }, {
					cwd = plugin.dir,
				})
			end,
			desc = "Open lazygit log",
		},

		["<localleader>i"] = {
			function(plugin)
				Util.notify(vim.inspect(plugin), {
					title = "Inspect " .. plugin.name,
					lang = "lua",
				})
			end,
			desc = "Inspect Plugin",
		},

		["<localleader>t"] = {
			function(plugin)
				require("lazy.util").float_term(nil, {
					cwd = plugin.dir,
				})
			end,
			desc = "Open terminal in plugin dir",
		},
	},
	headless = {
		process = true,
		log = true,
		task = true,
		colors = true,
	},
	diff = {
		cmd = "git",
	},
	checker = {
		enabled = true,
		concurrency = nil,
		notify = true,
		frequency = 3600,
		check_pinned = false,
	},
	change_detection = { enabled = false, notify = true },
	performace = {
		cache = { enabled = true },
		reset_packpath = true,
		rtp = {
			reset = true,
			paths = {},
			disabled_plugins = {},
		},
	},
	readme = {
		enabled = true,
		root = vim.fn.stdpath("state") .. "/lazy/readme",
		files = { "README.md", "lua/**/README.md" },
		skip_if_doc_exists = true,
	},
	state = vim.fn.stdpath("state") .. "/lazy/state.json",
	profiling = {
		loader = false,
		require = false,
	},
})

vim.o.background = "dark"
vim.cmd.colorscheme("catppuccin")
