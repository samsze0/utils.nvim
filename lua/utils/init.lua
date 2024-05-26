local M = {}

---@type SemanticVersion
M.version = {
  major = 0,
  minor = 1,
  patch = 0,
}

---@alias UtilsOptions {}
---@param opts? UtilsOptions
M.setup = function(opts) end

-- Return the full path to the currently executing lua script
-- Note that this function is not callable. Please just copy and paste the definition into where you need it.
--
---@deprecated
---@return string
M.current_lua_script_path = function()
  error("Not callable")
  return debug.getinfo(1).source:match("@?(.*/)")
end

-- Print and return value
--
---@generic T : any
---@param x T
---@return T
M.debug = function(x)
  print(vim.inspect(x))
  return x
end

return M
