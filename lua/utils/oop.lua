local tbl_utils = require("utils.table")

local M = {}

---@param BaseClass? any
---@return any new_class
M.new_class = function(BaseClass)
  local NewClass = {}
  NewClass.__index = NewClass
  NewClass.__is_class = true
  setmetatable(NewClass, { __index = BaseClass })

  return NewClass
end

-- Check if an object is an instance of a class
--
-- If the `is_parent` option is set to true, it will only check if the object is a parent of the class, rather
-- than checking if it is a descendant.
--
---@param o any
---@param class any
---@param opts? { is_parent: boolean }
M.is_instance = function(o, class, opts)
  opts = opts or {}

  error("Not implemented")

  if
    type(o) ~= "table"
    or type(class) ~= "table"
    or not o.__is_class
    or not class.__is_class
  then
    return false
  end

  if opts.is_parent then return getmetatable(o) == class end

  while o do
    if getmetatable(o) == class then return true end
    o = getmetatable(o)
  end

  return false
end

return M
