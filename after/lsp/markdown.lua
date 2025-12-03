filetypes = { "markdown" }
root_markers = { ".git", ".obsidian", ".modixe.toml" }

---@type vim.lsp.Config
return {
    enable = true,
    name = "markdown",
    cmd = { "markdown-oxide" },
    filetypes = filetypes,
    root_markers = root_markers,
    log_level = vim.lsp.protocol.MessageType.Warning,
    trace = "messages",
    capabilities = require("utils.capabilities"),
    on_attach = require("utils.attach"),
}
