local base64_utils = require("utils.base64")

T.assert_eq(base64_utils.encode("Hello, World!"), "SGVsbG8sIFdvcmxkIQ==")
T.assert_eq(base64_utils.decode("SGVsbG8sIFdvcmxkIQ=="), "Hello, World!")
