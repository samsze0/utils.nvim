local tbl_utils = require("utils.table")

local M = {}

---@param BaseClass? any
---@return any new_class
M.new_class = function(BaseClass)
  local NewClass = {}
  NewClass.__index = NewClass
  NewClass.__is_class = true
  setmetatable(NewClass, { __index = BaseClass ~= nil and BaseClass or nil })

  return NewClass
end

return M
