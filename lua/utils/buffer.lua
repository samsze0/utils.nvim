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

---@param buf? integer
---@param opts { on_lines?: (fun(lines: string[])), on_bytes?: (fun(bytes: string[])) }
function M.attach(buf, opts)
  local ok = vim.api.nvim_buf_attach(buf or 0, false, {
    on_lines = opts.on_lines and function(lines) opts.on_lines(lines) end,
    on_bytes = opts.on_bytes and function(bytes) opts.on_bytes(bytes) end,
  })
  if not ok then error("Failed to attach to buffer") end
end

return M
