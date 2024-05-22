local MiniTest = require("mini.test")

local expect, eq = MiniTest.expect, MiniTest.expect.equality

local child = MiniTest.new_child_neovim()

local T = MiniTest.new_set({
	hooks = {
		pre_case = function()
			child.restart({ "-c", "set rtp+=." })
			child.lua("M = require('utils.base64')")
		end,
		post_once = function()
			child.stop()
		end,
	},
})

T["base64 encode"] = function()
	local encoded = child.lua_get([[M.encode("Hello, World!")]])
	eq(encoded, "SGVsbG8sIFdvcmxkIQ==")
end

T["base64 decode"] = function()
	local decoded = child.lua_get([[M.decode("SGVsbG8sIFdvcmxkIQ==")]])
	eq(decoded, "Hello, World!")
end

return T
