local M = {}

-- Match expression
--
---@generic T : any
---@generic U : any
---@param val T
---@param arms table<T, U>
---@param default U?
---@return U
M.match = function(val, arms, default)
  for case, expr in pairs(arms) do
    if val == case then return expr end
  end

  if not default then error("No default case provided") end
  return default
end

-- Switch statement/expression
--
---@generic T : any
---@generic U : any
---@param val T
---@param switches table<T, fun(val: T): U>
---@param default (fun(val: T): U)?
---@return U
M.switch = function(val, switches, default)
  for case, expr in pairs(switches) do
    if val == case then return expr(val) end
  end

  if not default then error("No default case provided") end
  return default(val)
end

-- If else expression
--
---@generic T : any
---@param cond any
---@param true_expr T
---@param false_expr? T
---@return T
M.if_else = function(cond, true_expr, false_expr)
  if cond ~= nil or cond ~= false then
    return true_expr
  else
    return false_expr
  end
end

-- Recursive nullish coalescing
--
---@generic T : any
---@param val T?
---@return T
M.nullish = function(val)
  local function create_null_obj()
    local tbl = { __is_null = true }
    setmetatable(tbl, {
      __index = function() return create_null_obj() end,
      __call = function(args) return create_null_obj() end,
    })
    return tbl
  end

  if val == nil or (type(val) == "table" and val.__is_null) then
    return create_null_obj()
  end
  return val
end

-- Safe require by wrapping the require call in pcall
-- To get proper typing support on the resulting module, use luals's `@module` annotation
--
---@param module string
---@return any?
M.safe_require = function(module)
  local ok, mod = pcall(require, module)
  if not ok then return nil end
  return mod
end

return M
