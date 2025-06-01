local function unpack_results(server_data, client_id)
  local client = vim.lsp.get_client_by_id(client_id)
  local results = nil
  local error = nil

  if server_data == nil and client then
    error = "Server for client \"" .. client.name .. "\" not yet ready!"
  elseif type(server_data) == "table" and server_data.err ~= nil and client then
    error = "Server of client \"" .. client.name .. "\" returned error: "
    if type(server_data.err) == "string" then
      error = error .. server_data.err
  elseif type(server_data.err) == "table" and server_data.err.message then
      error = error .. server_data.err.message
  else
    error = error .. "Unknown error"
    end
  elseif type(server_data) == "table" and server_data.result then
    result = server_data.result
  else result = server_data
  end

  return result, error
end

local function request_actions(client_id, parameters)
  local method = "textDocument/codeAction"
  local client = vim.lsp.get_client_by_id(client_id)
  if client and not client:supports_method(method)
  then return {}
  end
  
  local resp = client:request_sync(method, params)
  local actions, err = unpack_result
end

function code_actions()
    local clients = vim.lsp.get_clients()
    if clients
      for _, cl in pairs(clients) do
        local client = vim.lsp.get_client_by_id(cl.id)
        local sync = client:request_sync("textDocument/codeAction", {})
        
        
end
