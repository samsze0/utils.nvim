local tbl_utils = require("utils.table")
local opts_utils = require("utils.opts")

local M = {}

-- Convert shell opts to string
--
---@alias ShellOpts table<string, string | boolean | (string | boolean)[]>
---@param shell_opts ShellOpts
---@return string
M.shell_opts_tostring = function(shell_opts)
  local result = {}
  for k, v in pairs(shell_opts) do
    if type(v) == "string" then
      if #v > 0 then
        table.insert(result, k .. "=" .. v)
      else
        table.insert(result, k)
      end
    elseif type(v) == "table" then
      if not tbl_utils.is_array(v) then error("Unexpected type") end
      for _, val in ipairs(v) do
        table.insert(result, k .. "=" .. val)
      end
    elseif type(v) == "boolean" then
      if v then table.insert(result, k) end
    elseif type(v) == "number" then
      table.insert(result, k .. "=" .. tostring(v))
    else
      error("Unexpected type")
    end
  end
  return table.concat(result, " ")
end

-- Tweaked from:
-- https://github.com/ibhagwan/fzf-lua/blob/main/lua/fzf-lua/utils.lua
--
---@alias AnsiColor fun(str: string): string
---@type { clear: AnsiColor, bold: AnsiColor, italic: AnsiColor, underline: AnsiColor, black: AnsiColor, red: AnsiColor, green: AnsiColor, yellow: AnsiColor, blue: AnsiColor, magenta: AnsiColor, cyan: AnsiColor, white: AnsiColor, grey: AnsiColor, dark_grey: AnsiColor }
M.ansi = {}

-- Ansi escape sequences
--
-- the "\x1b" esc sequence causes issues
-- with older Lua versions
-- clear    = "\x1b[0m",
M.ansi_escseq = {
  clear = "[0m",
  bold = "[1m",
  italic = "[3m",
  underline = "[4m",
  black = "[0;30m",
  red = "[0;31m",
  green = "[0;32m",
  yellow = "[0;33m",
  blue = "[0;34m",
  magenta = "[0;35m",
  cyan = "[0;36m",
  white = "[0;37m",
  grey = "[0;90m",
  dark_grey = "[0;97m",
}
for color, escseq in pairs(M.ansi_escseq) do
  M.ansi[color] = function(str)
    if type(str) ~= "string" then
      error("Expected string, got " .. type(str))
    end

    if str:len() == 0 then return "" end
    return escseq .. str .. M.ansi_escseq.clear
  end
end

-- Remove ansi escape sequences from string
--
---@param str string
---@return string
function M.strip_ansi_codes(str)
  local x, count = str:gsub("\x1b%[[%d:;]*[mK]", "")
  return x or str
end

-- From:
-- https://github.com/ibhagwan/fzf-lua/blob/main/lua/fzf-lua/utils.lua
--
-- Sets an invisible unicode character as icon separator
-- the below was reached after many iterations, a short summary of everything
-- that was tried and why it failed:
--
-- nbsp, U+00a0: the original separator, fails with files that contain nbsp
-- nbsp + zero-width space (U+200b): works only with `sk` (`fzf` shows <200b>)
-- word joiner (U+2060): display works fine, messes up fuzzy search highlights
-- line separator (U+2028), paragraph separator (U+2029): created extra space
-- EN space (U+2002): seems to work well
--
-- For more unicode SPACE options see:
-- http://unicode-search.net/unicode-namesearch.pl?term=SPACE&.submit=Search
M.nbsp = "\xe2\x80\x82" -- "\u{2002}"

-- vim.fn.system wrapper
-- Run a shell command and return the output as a string
--
---@alias TerminalSystemOptions { input?: any, trim_endline?: boolean }
---@param cmd string
---@param opts? TerminalSystemOptions
---@return string? result, number exit_status, string? err
M.system = function(cmd, opts)
  opts = opts_utils.extend({
    trim_endline = false,
  }, opts)

  local result = vim.fn.system(cmd, opts.input)
  if vim.v.shell_error ~= 0 then return nil, vim.v.shell_error, result end

  if opts.trim_endline and result:match("\n$") then
    result = result:sub(1, -2)
  end

  return result, vim.v.shell_error, nil
end

-- vim.fn.system wrapper
-- Run a shell command and return the output as a string
--
---@param cmd string
---@param opts? TerminalSystemOptions
---@return string result
M.system_unsafe = function(cmd, opts)
  local result, status, err = M.system(cmd, opts)
  assert(status == 0, err)
  return result or ""
end

-- vim.fn.systemlist wrapper
-- Run a shell command and return the output as a list of strings
--
---@alias TerminalSystemlistOptions { trim?: boolean, input?: any, keepempty?: boolean, trim_endline?: boolean }
---@param cmd string
---@param opts? TerminalSystemlistOptions
---@return string[]? result, number exit_status, string? err
M.systemlist = function(cmd, opts)
  opts = opts_utils.extend({
    trim = false,
    keepempty = true,
    trim_endline = false,
  }, opts)

  local result = vim.fn.systemlist(cmd, opts.input, opts.keepempty)
  if vim.v.shell_error ~= 0 then
    local err_msg = table.concat(result, "\n")
    return nil, vim.v.shell_error, err_msg
  end

  if
    opts.trim_endline
    and type(result[#result]) == "string"
    and result[#result] == "\n"
  then
    result[#result] = nil
  end

  if opts.trim then
    for i, v in ipairs(result) do
      result[i] = vim.trim(v)
    end
    if not opts.keepempty then
      result = tbl_utils.filter(result, function(_, v) return v ~= "" end)
    end
  end

  return result, vim.v.shell_error, nil
end

-- vim.fn.system wrapper
-- Run a shell command and return the output as a string
--
---@param cmd string
---@param opts? TerminalSystemlistOptions
---@return string[] result
M.systemlist_unsafe = function(cmd, opts)
  local result, status, err = M.systemlist(cmd, opts)
  assert(status == 0, err)
  return result or {}
end

return M
