local bytes_utils = require("utils.bytes")

assert(bytes_utils.bytes_to_str({ 72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33 }) == "Hello, World!")
assert(
	vim.deep_equal(
		bytes_utils.str_to_bytes("Hello, World!"),
		{ 72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33 }
	)
)
