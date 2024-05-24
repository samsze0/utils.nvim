local tbl_utils = require("utils.table")
local str_utils = require("utils.string")

local M = {}

-- Sort a list of files by a special order by which lower nested files come first. If
-- the nested level is the same, then sort by alphabetical order (case insensitive).
--
---@param paths string[]
---@param transformer? fun(path: string): string
---@return string[]
M.sort = function(paths, transformer)
  if not transformer then transformer = function(path) return path end end

  return tbl_utils.sort(paths, function(a, b)
    a = transformer(a)
    b = transformer(b)

    local a_level = str_utils.count(a, "/")
    local b_level = str_utils.count(b, "/")

    if a_level == b_level then
      return a:lower() < b:lower()
    else
      return a_level < b_level
    end
  end)
end

return M
