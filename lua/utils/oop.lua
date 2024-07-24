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
-- If the `is_parent` option is set to true, it will only check if the object is a parent of the class, rather
-- than checking if it is a descendant.
--
---@param o any
---@param class any
---@param opts? { is_parent: boolean }
M.is_instance = function(o, class, opts)
  opts = opts or {}

  if type(o) ~= "table" or not o.__is_class then return false end

  if opts.is_parent then return getmetatable(o) == class end

  while o do
    if o == class then return true end

    o = getmetatable(o)
    if o == o then break end -- Prevent infinite loop
  end

  return false
end

return M
