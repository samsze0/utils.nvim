local base64_utils = require("utils.base64")

assert(base64_utils.encode("Hello, World!") == "SGVsbG8sIFdvcmxkIQ==")
assert(base64_utils.decode("SGVsbG8sIFdvcmxkIQ==") == "Hello, World!")
