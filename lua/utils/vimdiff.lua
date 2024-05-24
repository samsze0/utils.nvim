local opts_utils = require("utils.opts")

local M = {}

-- Calling `diffthis` on all input buffers
--
---@vararg number buffers
M.diff_bufs = function(...)
  local bufs = { ... }
  for _, buf in ipairs(bufs) do
    vim.api.nvim_buf_call(buf, function() vim.cmd("diffthis") end)
  end
end

-- Opening files in a new tab and diffing them
-- If `filetype` is not given, it will be inferred from files.
-- Use the `cursor_at` option to specify which window to focus on immediately after opening the files.
--
---@param opts { show_in_current_tab?: boolean, filetype?: string | nil, cursor_at?: number | nil }
---@vararg { filepath_or_content: string | string[], readonly?: boolean }
---@return integer[] buffers, integer[] windows
M.show_diff = function(opts, ...)
  local entries = { ... }

  opts = opts_utils.extend({
    show_in_current_tab = false,
  }, opts)

  if opts.cursor_at and not entries[opts.cursor_at] then
    error("Invalid cursor_at")
  end

  if not opts.show_in_current_tab then
    vim.api.nvim_command("tabnew")
  else
    vim.cmd("only") -- Close all other windows in current tab
  end

  local filetype = nil

  local windows = {}
  local buffers = {}

  for i, e in ipairs(entries) do
    if i > 1 then vim.cmd("vsplit") end

    if type(e.filepath_or_content) == "string" then
      vim.cmd(("e %s"):format(e.filepath_or_content))
      if vim.bo.filetype ~= "" then filetype = vim.bo.filetype end
    else
      local content = e.filepath_or_content
      ---@cast content string[]
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
      vim.bo[buf].readonly = e.readonly
    end

    table.insert(buffers, vim.api.nvim_get_current_buf())
    table.insert(windows, vim.api.nvim_get_current_win())

    vim.cmd("diffthis")
  end

  -- Overwrite filetype if it is given
  if opts.filetype then filetype = opts.filetype end

  -- Sync all buffers' filetype
  if filetype then
    for _, buf in ipairs(buffers) do
      vim.bo[buf].filetype = filetype
    end
  end

  -- Goto the window specified by `opts.window`
  if opts.cursor_at then
    vim.api.nvim_set_current_win(windows[opts.cursor_at])
  end

  return buffers, windows
end

return M
