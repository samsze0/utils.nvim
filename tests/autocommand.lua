local autocmd_utils = require("utils.autocommand")
local debug = require("utils").debug

local group = autocmd_utils.create_group("Test")
local autocmd = autocmd_utils.create({
  group = group,
  events = { autocmd_utils.Event.FileType },
  description = "Test autocmd",
  lua_callback = function() assert(true) end,
  once = true,
})

local match_autocmds = autocmd_utils.get({
  group = group,
  events = autocmd_utils.Event.FileType,
})
assert(#match_autocmds == 1)
local c = match_autocmds[1]
assert(c.buffer_local == false)
assert(c.description == "Test autocmd")
assert(c.group_name == "Test")
assert(c.id == autocmd)

vim.bo.filetype = "javascript"