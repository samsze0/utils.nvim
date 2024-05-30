local bytes_utils = require("utils.bytes")

T.assert_eq(
  bytes_utils.bytes_to_str({
    72,
    101,
    108,
    108,
    111,
    44,
    32,
    87,
    111,
    114,
    108,
    100,
    33,
  }), "Hello, World!"
)
T.assert_deep_eq(
  bytes_utils.str_to_bytes("Hello, World!"),
  { 72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33 }
)
