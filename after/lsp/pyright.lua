local filetypes = { "python" }
local root_markers = { "pyvenv.cfg", ".git", "CACHEDIR.TAG", ".gitignore" }

---@type vim.lsp.Config
return {
	enable = true,
	name = "pyright",
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = filetypes,
	root_markers = root_markers,
	log_level = vim.lsp.protocol.MessageType.Warning,
	trace = "messages",
	single_file_support = true,
	capabilities = require("utils.capabilities").complete(),
	on_attach = require("utils.attach").on,
	on_new_config = function(new_config)
		local get_pipenv_venv_path = function()
			local pipenv_venv = vim.fn.trim(vim.fn.system("pipenv --venv"))
			if pipenv_venv == "" then
				return nil
			end
			local split = vim.split(pipenv_venv, "\n")
			for _, line in ipairs(split) do
				if string.match(line, "^/") ~= nil then
					if vim.fn.isdirectory(line) then
						return line
					end
				end
			end

			return nil
		end
		local get_python_path = function()
			local venv_path = get_pipenv_venv_path()
			if venv_path ~= nil then
				return venv_path .. "/bin/python"
			else
				return vim.fn.trim(vim.fn.system("python -c 'import sys; print(sys.executable)'"))
			end
		end
		local python_path = get_python_path()
		if python_path ~= nil then
			new_config.settings.python.pythonPath = python_path
		end
	end,
	settings = {
		pyright = {
			disableOrganizeImports = false,
			analysis = {
				useLibraryCodeForTypes = true,
				autoSearchPaths = true,
				diagnosticMode = "workspace",
				autoImportCompletions = true,
			},
		},
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "workspace",
			},
		},
	},
}
