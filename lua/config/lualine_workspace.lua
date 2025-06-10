local lualine_require = require('lualine_require')
local M = lualine_require.require('lualine.component'):extend()

local default_options = {style = 'default'}

function M:init(options)
    M.super.init(self, options)
    self.options = vim.tbl_deep_extend('keep', self.options or {},
                                       default_options)
end

function M:update_status()
    local workspaces = vim.lsp.buf.list_workspace_folders()

    return workspaces[1]
end

return M
