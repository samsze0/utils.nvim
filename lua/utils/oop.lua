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

-- Check if an object is an instance of a class
--
---@param o any
---@param class any
M.is_instance = function(o, class)
  return type(o) == "table" and o.__is_class and getmetatable(o) == class
end

return M
