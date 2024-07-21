local opts_utils = require("utils.opts")
local terminal_utils = require("utils.terminal")
local dbg = require("utils").debug
local tbl_utils = require("utils.table")

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
---@field State string

-- On ApiVersion 1.45

-- Get docker images
--
---@alias GetDockerImagesOptions { all?: boolean }
---@param opts? GetDockerImagesOptions
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

  local result = terminal_utils.systemlist_unsafe(
    "docker image ls " .. terminal_utils.shell_opts_tostring(args),
    { trim_endline = true, trim = true, keepempty = false }
  )
  if #result == 0 then return {} end
  local images = tbl_utils.map(
    result,
    function(i, e) return vim.json.decode(e) end
  )
  ---@cast images DockerImage[]

  return images
end

-- Get docker containers
--
---@alias GetDockerContainersOptions { all?: boolean }
---@param opts? GetDockerContainersOptions
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

  local result = terminal_utils.systemlist_unsafe(
    "docker container ls " .. terminal_utils.shell_opts_tostring(args),
    { trim_endline = true, keepempty = false, trim = true }
  )
  if #result == 0 then return {} end
  local containers = tbl_utils.map(
    result,
    function(i, e) return vim.json.decode(e) end
  )
  ---@cast containers DockerContainer[]

  return containers
end

return M
