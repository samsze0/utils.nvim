local tbl_utils = require("utils.table")
local Path = require("pathlib")

local M = {}

-- Sort a list of files by a special order by which files at lower depth comes first. If
-- the depth is the same, then sort by alphabetical order (case insensitive).
--
---@param paths PathlibPath[]
---@return PathlibPath[]
M.sort = function(paths)
  return tbl_utils.sort(paths, function(a, b)
    local a_depth = a:depth()
    local b_depth = b:depth()

    if a_depth == b_depth then
      if a:is_dir() and not b:is_dir() then
        return true
      elseif not a:is_dir() and b:is_dir() then
        return false
      end

      return a:lower() < b:lower()
    else
      return a_depth < b_depth
    end
  end)
end

-- Convert a list of path strings to a list of Path objects
--
---@param paths string[]
---@return PathlibPath[]
M.from_strs = function(paths)
  return tbl_utils.map(paths, function(_, p) return Path.new(p) end)
end

-- Get filetype using `vim.filetype`
--
---@param filepath string
---@param opts? { read_content?: boolean }
M.get_filetype = function(filepath, opts)
  opts = opts or {}

  local filename = vim.fn.fnamemodify(filepath, ":t")
  return vim.filetype.match({
    filename = filename,
    contents = opts.read_content and vim.fn.readfile(filepath) or nil,
  })
end

return M
