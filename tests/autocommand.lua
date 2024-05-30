local autocmd_utils = require("utils.autocommand")
local debug = require("utils").debug

local group = autocmd_utils.create_group("Test")
local autocmd = autocmd_utils.create({
  group = group,
  events = { autocmd_utils.Event.FileType },
  description = "Test autocmd",
  lua_callback = function() T.assert(true) end,
  once = true,
})

local match_autocmds = autocmd_utils.get({
  group = group,
  events = autocmd_utils.Event.FileType,
})
T.assert_eq(#match_autocmds, 1)
local c = match_autocmds[1]
T.assert_not(c.buffer_local)
T.assert_eq(c.description, "Test autocmd")
T.assert_eq(c.group_name, "Test")
T.assert_eq(c.id, autocmd)

vim.bo.filetype = "javascript"