local tbl_utils = require("utils.table")

local M = {}

---@param name string
---@param command string | function
---@param opts? { description?: string, force?: boolean }
function M.create(name, command, opts)
  opts = opts or {}
  ---@cast opts table<string, any>

  return vim.api.nvim_create_user_command(name, command, {
    desc = opts.description,
    force = opts.force,
  })
end

---@alias VimCommand { name: string }
---@param opts? { }
function M.list(opts)
  local commands = vim.api.nvim_get_commands({ builtin = false })
  return tbl_utils.map(commands, function (name, cmd)
    return {
      name = name,
    }
  end)
end

return M
