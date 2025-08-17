local M = {}

---@param c boolean
---@return string
function M.get_rocks_paths(c)
	local status_ok = false
	local rocks_paths = ""
	if c then
		status_ok, rocks_paths = pcall(vim.fn.system, "luarocks path --lr-cpath")
	else
		status_ok, rocks_paths = pcall(vim.fn.system, "luarocks path --lr-path")
	end
	if status_ok and rocks_paths then
		return rocks_paths
	else
		return ""
	end
end

---@param list table<any>
---@param element any
---@return boolean
function M.contains(list, element)
	for _, elem in ipairs(list) do
		if element == elem then
			return true
		end
	end
	return false
end

--- @param path string
--- @return string data
function M.readfile(path)
	local f = assert(vim.uv.fs_open(path, "r", 438))
	local size = assert(vim.uv.fs_fstat(f)).size
	local data = assert(vim.uv.fs_read(f, size, 0))
	assert(vim.uv.fs_close(f))
	return data
end

--- @param exe string
--- @return string
function M.executable_path(exe)
	local ok, path = pcall(vim.fn.system, "which " .. exe)
	if ok then
		return vim.trim(path)
	else
		return ""
	end
end

--- @return lualine.Components
function M.lualine_workspace()
	local lualine_require = require("lualine_require")
	local C = lualine_require.require("lualine.component"):extend()

	local default_options = { style = "default" }

	function C:init(options)
		C.super.init(self, options)
		self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
	end

	function C:update_status()
		local workspaces = vim.lsp.buf.list_workspace_folders()

		return workspaces[1]
	end

	return C
end

--- @return integer, integer
function M.get_editor_dimensions()
	local statusline_height = 0
	local laststatus = vim.opt.laststatus:get()
	if laststatus == 2 or laststatus == 3 or (laststatus == 1 and #vim.api.nvim_tabpage_list_wins(0) > 1) then
		statusline_height = 1
	end

	local height = vim.opt.lines:get() - (statusline_height + vim.opt.cmdheight:get())
	local width = vim.opt.columns:get()
	return width, height
end

---@param diagnosticsHeight integer
---@return integer
function M.get_diagnostics_position(diagnosticsHeight)
	local display_top = nil
	local first_line = vim.fn.line("w0")
	local current_line = vim.api.nvim_win_get_cursor(0)[1]

	_, row_max = M.get_editor_dimensions()
	local window_pos = vim.api.nvim_win_get_position(0)
	local cursor_pos = window_pos[1] + (current_line - first_line)

	if (row_max / 2) < cursor_pos then
		display_top = true
	else
		display_top = false
	end

	if display_top then
		return 0
	else
		return math.floor(math.abs(row_max - diagnosticsHeight - 2))
	end
end

return M
