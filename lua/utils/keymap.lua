local M = {}

---@alias VimMode "n" | "v" | "i"

---@param mode VimMode | VimMode[]
---@param lhs string
---@param rhs string | function
---@param opts? { silent?: boolean, noremap?: boolean, expr?: boolean }
function M.create(mode, lhs, rhs, opts)
  return vim.keymap.set(mode, lhs, rhs, opts or {})
end

return M
