local tbl_utils = require("utils.table")

local M = {}

-- Extension of `tbl_extend`
--
---@vararg table?
---@return table
M.extend = function(...)
  local args = { ... }
  return tbl_utils.tbl_extend(
    { mode = "force" },
    unpack(tbl_utils.map(args, function(_, tbl) return tbl or {} end))
  )
end

-- Extension of `tbl_deep_extend`
--
---@vararg table?
---@return table
M.deep_extend = function(...)
  local args = { ... }
  return tbl_utils.tbl_deep_extend(
    { mode = "force" },
    unpack(tbl_utils.map(args, function(_, tbl) return tbl or {} end))
  )
end

return M

