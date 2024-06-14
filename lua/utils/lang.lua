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
---@param cond boolean
---@param true_expr T
---@param false_expr? T
---@return T
M.if_else = function(cond, true_expr, false_expr)
  if cond then
    return true_expr
  else
    return false_expr
  end
end

-- Nullish coalescing operator
--
---@generic T : any
---@param val T?
---@return T
M.nullish = function(val)
  if val == nil then
    local tbl = { }
    setmetatable(tbl, { __index = function() return nil end })
    return tbl
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
  if not ok then
    return nil
  end
  return mod
end

return M
