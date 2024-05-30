local cmd_utils = require("utils.command")
local tbl_utils = require("utils.table")

cmd_utils.create("TestCommand", "echo 'Hello, World!'", {
  description = "Test command",
})

local cmd_list = cmd_utils.list()
T.assert(
  tbl_utils.any(cmd_list, function(_, cmd) return cmd.name == "TestCommand" end)
)
