local tbl_utils = require("utils.table")

local M = {}

---@alias VimBuffer { bufnr: number, changed: boolean, changedtick: number, hidden: boolean, lastused: number, listed: boolean, lnum: number, linecount: number, loaded: boolean, name: string, signs: { id: string, lnum: number, name: string }, variables: table, windows: number[] }

---@param opts? { buflisted?: boolean, bufloaded?: boolean, bufmodified?: boolean }
---@return VimBuffer[]
function M.get_bufs_info(opts)
  local bufs_info = vim.fn.getbufinfo(opts or {})
  if not bufs_info then return {} end

  return tbl_utils.map(bufs_info, function(_, buf)
    buf.changed = buf.changed == 1 ---@diagnostic disable-line assign-type-mismatch
    buf.hidden = buf.hidden == 1 ---@diagnostic disable-line assign-type-mismatch
    buf.listed = buf.listed == 1 ---@diagnostic disable-line assign-type-mismatch
    buf.loaded = buf.loaded == 1 ---@diagnostic disable-line assign-type-mismatch
    return buf
  end)
end

return M
