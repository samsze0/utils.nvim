local tbl_utils = require("utils.table")
local opts_utils = require("utils.opts")

local M = {}

-- -- Split string using lua regular expression
-- --
-- ---@param inputstr string
-- ---@param sep? string
-- ---@return string[]
-- M.split_string = function(inputstr, sep)
--   if sep == nil then sep = "%s" end
--   local t = {}
--   for str in inputstr:gmatch("([^" .. sep .. "]+)") do
--     table.insert(t, str)
--   end
--   return t
-- end

---@param str string
---@param length number
---@return string
M.pad = function(str, length) return string.format("%-" .. length .. "s", str) end

local nbsp = "\xe2\x80\x82" -- "\u{2002}"

-- Split a string into parts
--
---@alias StringSplitOpts { count?: number, sep?: string, include_remaining?: boolean, discard_empty?: boolean, trim?: boolean }
---@param str string
---@param opts? StringSplitOpts
---@return string[]
M.split = function(str, opts)
  opts = opts_utils.extend(
    { sep = "%s+", include_remaining = true, discard_empty = true },
    opts
  )
  ---@cast opts StringSplitOpts

  local result = {}

  -- TODO: handle error gracefully

  -- Lua doesn't support multi-char-negative-lookahead
  -- So we cannot just use Lua regex (because it won't support multi-char sep)

  -- We perform split by first replacing all occurrences of sep with nbsp,
  -- then we `vim.split` by nbsp

  str = str:gsub(opts.sep, nbsp, opts.count)
  result =
    vim.split(str, nbsp, { trimempty = opts.discard_empty, plain = false })
  if opts.count ~= nil and #result ~= opts.count + 1 then
    error(M.fmt("Expected", opts.count + 1, "parts, but got", result))
  end
  if not opts.include_remaining then table.remove(result, #result) end

  if opts.trim then
    for i, v in ipairs(result) do
      result[i] = vim.trim(v)
    end
  end

  return result
end

-- Truncate or pad a string to a certain width
--
---@param str string
---@param width number The width to truncate or pad to
---@param opts? { pad_character?: string, elipses?: string }
---@return string
M.trunc_or_pad_to_width = function(str, width, opts)
  opts = opts_utils.extend({
    pad_character = " ",
    elipses = "...",
  }, opts)

  if width < 0 then error("Width must be at least 0") end

  if #str > width then
    return str:sub(1, width - #opts.elipses) .. opts.elipses
  else
    return str .. opts.pad_character:rep(width - #str)
  end
end

local function _fmt(args)
  local tbl = tbl_utils.map(args, function(_, arg)
    if type(arg) ~= "string" then
      return vim.inspect(arg)
    else
      return arg
    end
  end)
  return tbl
end

---@vararg any
---@return string
M.fmt = function(...)
  local args = { ... }
  return table.concat(_fmt(args), " ")
end

-- Same as `fmt`, but joins the arguments with `\n`
--
---@vararg any
---@return string
M.fmt_multiline = function(...)
  local args = { ... }
  return table.concat(_fmt(args), "\n")
end

-- Join tbl/array as string with custom fn
--
---@generic T : any
---@generic U : any
---@param tbl table<any, T> | T[]
---@param fn fun(k: any, v: T): U
---@param opts? { delimiter?: string }
---@return string
M.join = function(tbl, fn, opts)
  opts = opts_utils.extend({ delimiter = " " }, opts)

  return M.reduce(tbl, function(acc, i, v)
    if i == 1 then
      return fn(i, v)
    else
      return acc .. opts.delimiter .. fn(i, v)
    end
  end, "")
end

---@param str string
---@return string[] chars_array
M.chars = function(str)
  local t = {}
  for i = 1, #str do
    t[i] = str:sub(i, i)
  end
  return t
end

-- Count the number of times a substring appears in a string
--
---@param str string
---@param substr string
---@return number
M.count = function(str, substr)
  local count = 0
  for _ in string.gmatch(str, substr) do
    count = count + 1
  end
  return count
end

return M
