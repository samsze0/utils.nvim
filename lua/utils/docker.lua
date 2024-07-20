local opts_utils = require("utils.opts")
local terminal_utils = require("utils.terminal")

local M = {}

---@class DockerImage
---@field Containers string
---@field CreatedAt string
---@field CreatedSince string
---@field Digest string
---@field ID string
---@field Repository string
---@field SharedSize string
---@field Size string
---@field Tag string
---@field UniqueSize string
---@field VirtualSize string

---@class DockerContainer
---@field Command string
---@field CreatedAt string
---@field ID string
---@field Image string
---@field Labels string
---@field LocalVolumes string
---@field Mounts string
---@field Names string
---@field Networks string
---@field Ports string
---@field RunningFor string
---@field Size string
---@field Controller string
---@field Status string

-- Get docker images
--
---@alias GetDodckerImagesOptions { all?: boolean }
---@param opts? GetDodckerImagesOptions
---@return DockerImage[]
function M.images(opts)
  if vim.fn.executable("docker") ~= 1 then
    error("Docker executable not found")
  end

  opts = opts_utils.extend({
    all = false,
  }, opts)

  local args = {
    ["-a"] = opts.all,
    ["--format"] = "json",
  }

  local result = terminal_utils.system_unsafe(
    "docker image ls " .. terminal_utils.shell_opts_tostring(args),
    { trim_endline = true }
  )
  result = vim.trim(result)
  local images = vim.json.decode(result)
  ---@cast images DockerImage[]

  return images
end

-- Get docker containers
--
---@alias GetDodckerContainersOptions { all?: boolean }
---@param opts? GetDodckerContainersOptions
---@return DockerContainer[]
function M.containers(opts)
  if vim.fn.executable("docker") ~= 1 then
    error("Docker executable not found")
  end

  opts = opts_utils.extend({
    all = false,
  }, opts)

  local args = {
    ["-a"] = opts.all,
    ["--format"] = "json",
  }

  local result = terminal_utils.system_unsafe(
    "docker container ls " .. terminal_utils.shell_opts_tostring(args),
    { trim_endline = true }
  )
  result = vim.trim(result)
  local containers = vim.json.decode(result)
  ---@cast containers DockerContainer[]

  return containers
end

return M
