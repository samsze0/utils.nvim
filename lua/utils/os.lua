local uv_utils = require("utils.uv")

local M = {}

M.OS = vim.loop.os_uname().sysname
M.IS_MAC = M.OS == "Darwin"
M.IS_LINUX = M.OS == "Linux"

-- Return the shell command to send data to a named pipe
--
---@param name string
---@param data string
---@return string
M.write_to_named_pipe_cmd = function(name, data)
  if M.IS_MAC then
    if vim.fn.executable("nc") ~= 1 then error("nc command not found") end

    return ([[cat <<EOF | nc -U %s
%s
EOF
]]):format(name, data)
  elseif M.IS_LINUX then
    if vim.fn.executable("socat") ~= 1 then error("socat command not found") end

    return ([[cat <<EOF | socat - UNIX-CONNECT:%s
%s
EOF
]]):format(name, data)
  else
    error("Unsupported OS")
  end
end

-- Write data to a unix socket
--
---@param name string
---@param data string | string[]
---@return nil
M.write_to_named_pipe = function(name, data)
  local sock, err = vim.loop.new_pipe(false)
  assert(sock, err)
  local success, err = sock:connect(name)
  assert(success, err)
  sock:write(data)
  sock:close()
end

-- Return shell cmd for sending data to a tcp server
--
---@param host string
---@param port number
---@param data string
---@return string
M.write_to_tcp_cmd = function(host, port, data)
  if vim.fn.executable("nc") ~= 1 then error("nc command not found") end

  if M.IS_MAC then
    return ([[cat <<EOF | nc %s %s
%s
EOF
]]):format(host, port, data)
  elseif M.IS_LINUX then
    error("Not implemented")
  else
    error("Unsupported OS")
  end
end

-- Find an available OS port
--
---@return number
M.find_available_port = function()
  local tcp_server = uv_utils.create_tcp_server("127.0.0.1", function(message)
  end)
  local port = tcp_server.port
  tcp_server.close()
  return port
end

return M
