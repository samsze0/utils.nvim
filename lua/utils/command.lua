local M = {}

---@param name string
---@param command string | function
---@param opts? { }
function M.create(name, command, opts)
	opts = opts or {}
  ---@cast opts table<string, any>

	return vim.api.nvim_create_user_command(name, command, opts)
end

return M
