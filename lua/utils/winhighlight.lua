local opts_utils = require("utils.opts")
local str_utils = require("utils.string")
local tbl_utils = require("utils.table")

local M = {}

---@alias WinHighlights table<string, string>

---@param str string
---@return WinHighlights
M.from_str = function(str)
  if str == nil then return {} end

  local values = vim.split(str, ",")
  return tbl_utils.reduce(values, function(acc, _, v)
    local parts = vim.split(v, ":")
    acc[parts[1]] = parts[2]
    return acc
  end, {})
end

---@param highlights WinHighlights
---@return string
M.to_str = function(highlights)
  return table.concat(tbl_utils.reduce(highlights, function(acc, k, v)
    table.insert(acc, ("%s:%s"):format(k, v))
    return acc
  end, {}), ",")
end

return M