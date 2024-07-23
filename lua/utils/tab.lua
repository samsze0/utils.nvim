local tbl_utils = require("utils.table")

local M = {}

---@alias VimTab { tabnr: number, variables: table, windows: number[] }

---@param tab_nr number
---@return VimTab
function M.get_tab_info(tab_nr) return vim.fn.gettabinfo(tab_nr or 0) end

---@return VimTab[]
function M.get_tabs_info()
  return tbl_utils.map(vim.fn.gettabinfo(), function(_, tab) return tab end)
end

return M
