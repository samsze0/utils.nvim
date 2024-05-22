local MiniTest = require("mini.test")

local expect, eq = MiniTest.expect, MiniTest.expect.equality

local test_set = MiniTest.new_set({})

test_set["base64 encode"] = function()
	local base64_utils = require("utils.base64")
	local encoded = base64_utils.encode("Hello, World!")
	eq(encoded, "SGVsbG8sIFdvcmxkIQ==")
end

test_set["base64 decode"] = function()
	local base64_utils = require("utils.base64")
	local decoded = base64_utils.decode("SGVsbG8sIFdvcmxkIQ==")
	eq(decoded, "Hello, World!")
end

return test_set
