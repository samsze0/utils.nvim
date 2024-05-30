local debug = require("utils").debug
local editor_utils = require("utils.editor")

-- Check if test-file.js exists
local f = io.open("tests/test-file.js", "r")
if f == nil then error("tests/test-file.js does not exist") end

-- Open test-file.js
vim.cmd("edit tests/test-file.js")

-- Double check if test file has the expected content
T.assert_deep_eq(vim.api.nvim_buf_get_lines(0, 0, -1, false), {
  "// 'hypot' is a binary function",
  "const hypot = (x, y) => Math.sqrt(x * x + y * y);",
  "",
  "// 'thunk' is a function that takes no arguments and, when invoked, performs a potentially expensive",
  "// operation (computing a square root, in this example) and/or causes some side-effect to occur",
  "const thunk = () => hypot(3, 4);",
  "",
  "// the thunk can then be passed around without being evaluated...",
  "doSomethingWithThunk(thunk);",
  "",
  "// ...or evaluated",
  "thunk(); // === 5",
})

T.assert(not editor_utils.get_mode().blocking)
T.assert_eq(editor_utils.get_mode().mode, "n")

-- FIX:
-- Due to how editor.to_normal_mode() is broken, we cannot test cases where mode == "n"

-- Select the first line (line select mode)

vim.cmd("normal! gg")
vim.cmd("normal! V")

T.assert_not(editor_utils.get_mode().blocking)
T.assert_eq(editor_utils.get_mode().mode, "V")

local selection = editor_utils.get_visual_selection()
T.assert_deep_eq(selection, { "// 'hypot' is a binary function"} )

-- Select between first and firth line (char select mode)

vim.cmd("normal! 4j6e")
vim.cmd("normal! v")

T.assert_not(editor_utils.get_mode().blocking)
T.assert_eq(editor_utils.get_mode().mode, "v")

local selection = editor_utils.get_visual_selection()
T.assert_deep_eq(selection, {
  "// 'hypot' is a binary function",
  "const hypot = (x, y) => Math.sqrt(x * x + y * y);",
  "",
  "// 'thunk' is a function that takes no arguments and, when invoked, performs a potentially expensive",
  "// operation (computing a square",
})

