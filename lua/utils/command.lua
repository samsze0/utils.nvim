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

return M
