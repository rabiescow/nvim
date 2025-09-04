---@return string: returns the version
function luarocks_version()
	local status_ok, version =
		pcall(vim.fn.system, "luarocks | rg 'Version' | sed 's/.*\\(Version.*:\\) \\(.*\\)/\\2/'")
	if status_ok then
		return vim.trim(version)
	else
		return ""
	end
end

local root_markers = {
	".git",
	".gitignore",
	".luacheckrc",
	".luarc.json",
	".luarc.jsonc",
	".stylua.toml",
	"selene.toml",
	"selene.yml",
	"stylua.toml",
	"lazy-lock.json",
}
local filetypes = { "lua" }

---@type vim.lsp.Config
return {
	enable = true,
	name = "lua-language-server",
	cmd = { "lua-language-server" },
	filetypes = filetypes,
	root_markers = root_markers,
	root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1]),
	log_level = vim.lsp.protocol.MessageType.Warning,
	trace = "messages",
	single_file_support = true,
	capabilities = require("utils.capabilities").complete(),
	on_attach = require("utils.attach").on,
	on_new_config = nil,
	settings = {
		Lua = {
			telemetry = { enable = false },
			completion = {
				enable = true,
				callSnippet = "Replace",
				displayContext = 2,
				keywordSnippet = "Both",
				workspaceWord = true,
			},
			format = { enable = true },
			codelens = { enable = true },
			hint = {
				enable = true,
				arrayIndex = "Enable",
				setType = true,
				semicolon = "All",
			},
			diagnostics = {
				enable = true,
				disable = { "lowercase-global" },
				globals = { "vim", "require" },
			},
			hover = {
				enumsLimit = 10,
				expandAlias = true,
				previewFields = 50,
				viewNumber = true,
				viewString = true,
				viewStringMax = 200,
			},
			misc = {
				parameters = {},
				executablePath = "/usr/bin/lua-language-server",
			},
			runtime = {
				version = "LuaJIT",
				path = { "?.lua", "?/init.lua", "../init.lua", "lua/?.lua", "lua/?/init.lua" },
				pathStrict = true,
				unicodeName = true,
			},
			workspace = {
				checkThirdParty = "ApplyInMemory",
				library = {
					vim.fn.environ()["HOME"] .. "/.luarocks/share/lua/" .. luarocks_version() .. "/",
					vim.fn.environ()["HOME"] .. "/.luarocks/share/lua/" .. luarocks_version() .. "/busted/",
					vim.fn.environ()["HOME"] .. "/.luarocks/share/lua/" .. luarocks_version() .. "/cliargs/",
					vim.fn.environ()["HOME"] .. "/.luarocks/share/lua/" .. luarocks_version() .. "/luassert/",
					vim.fn.environ()["HOME"] .. "/.luarocks/share/lua/" .. luarocks_version() .. "/pl/",
					vim.fn.environ()["HOME"] .. "/.luarocks/share/lua/" .. luarocks_version() .. "/system/",
					vim.fn.environ()["HOME"] .. "/.luarocks/share/lua/" .. luarocks_version() .. "/term/",
					"${3rd}/luv/library",
					"${3rd}/busted/library",
					"${3rd}/lpeg/library",
					"${3rd}/lfs/library",
					"${3rd}/json/library",
					vim.fn.expand(vim.env.VIMRUNTIME),
				},
				ignoreDir = { ".git", ".vscode", "bin", "test", "spec" },
				ignoreSubModules = true,
				useGitIgnore = true,
				maxPreload = 1000,
				preloadFileSize = 1000,
				disableIndexFiles = false,
				index = {
					incremental = true,
					version = "Lua 5.4",
				},
			},
		},
	},
}
