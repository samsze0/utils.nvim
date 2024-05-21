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
		if val == case then
			return expr
		end
	end

	if not default then
		error("No default case provided")
	end
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
		if val == case then
			return expr(val)
		end
	end

	if not default then
		error("No default case provided")
	end
	return default(val)
end

return M
