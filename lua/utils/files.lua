local tbl_utils = require("utils.table")
local terminal_utils = require("utils.terminal")
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
---@param opts? { read_content?: boolean, content?: string[] }
M.get_filetype = function(filepath, opts)
  opts = opts or {}

  local content = nil
  if opts.content then
    content = opts.content
  elseif opts.read_content then
    content = M.read_file(filepath, { binary = true })
  end

  local filename = vim.fn.fnamemodify(filepath, ":t")
  return vim.filetype.match({
    filename = filename,
    contents = content,
  })
end

-- Read the content of a file using vim.fn.readfile
--
---@param filepath string
---@param opts? { binary?: boolean, max?: number }
---@return string[]
M.read_file = function(filepath, opts)
  opts = opts or {}

  ---@type string?
  local flags = ""
  if opts.binary then flags = flags .. "b" end

  if flags == "" then flags = nil end

  -- If nil is supplied as the max argument, then readfile will simply return {} (treat max = 0)
  if opts.max ~= nil then
    return vim.fn.readfile(filepath, flags, opts.max)
  else
    return vim.fn.readfile(filepath, flags)
  end
end

-- Write content to a file using vim.fn.writefile
--
---@param lines string[]
---@param filepath string
---@param opts? { binary?: boolean, append?: boolean, delete?: boolean, fsync?: boolean }
M.write_file = function(lines, filepath, opts)
  opts = opts or {}

  ---@type string?
  local flags = ""
  if opts.binary then flags = flags .. "b" end
  if opts.append then flags = flags .. "a" end
  if opts.delete then flags = flags .. "D" end
  if opts.fsync then flags = flags .. "s" end

  if flags == "" then flags = nil end

  vim.fn.writefile(lines, filepath, flags)
end

-- Check if a file is binary using `file --mime`
--
---@param filepath string
---@return boolean
M.is_binary = function(filepath)
  return M.get_mime_encoding(filepath) == "binary"
end

-- Check if a file is text (or json) using `file --mime`
--
---@param filepath string
---@return boolean
M.is_text = function(filepath)
  local mime_type = M.get_mime_type(filepath)
  return mime_type:match("^text/") or mime_type:match("^application/json")
end

-- Get the mime type of a file using `file --mime-type`
-- https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
--
---@param filepath string
---@return string
M.get_mime_type = function(filepath)
  local output = terminal_utils.system_unsafe(
    ("file --mime-type -F %s '%s'"):format(terminal_utils.nbsp, filepath)
  )
  return vim.trim(vim.split(output, terminal_utils.nbsp)[2])
end

-- Get the mime encoding of a file using `file --mime-encoding`
--
---@param filepath string
---@return string
M.get_mime_encoding = function(filepath)
  local output = terminal_utils.system_unsafe(
    ("file --mime-encoding -F %s '%s'"):format(terminal_utils.nbsp, filepath)
  )
  return vim.trim(vim.split(output, terminal_utils.nbsp)[2])
end

-- Count the number of lines in a file using `wc -l`
--
---@param filepath string
---@return number
M.count_lines = function(filepath)
  local num_of_lines = terminal_utils.system_unsafe("wc -l < " .. filepath)
  num_of_lines = tonumber(vim.trim(num_of_lines)) ---@diagnostic disable-line: cast-local-type
  if not num_of_lines then
    error("Failed to get number of lines for " .. filepath)
  end
  return num_of_lines
end

-- Write content to a temporary file and return its path
--
---@param content string | string[]
---@return string
M.write_to_tmpfile = function(content)
  local tmp = vim.fn.tempname()
  vim.fn.writefile(
    type(content) == "string" and vim.split(content, "\n") or content,
    tmp
  )
  return tmp
end

return M
