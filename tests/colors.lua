local color_utils = require("utils.colors")

assert(color_utils.rgb_to_hex(255, 255, 255) == "#FFFFFF")
assert(color_utils.rgb_to_hex(0, 0, 0) == "#000000")
assert(color_utils.rgb_to_hex(255, 0, 0) == "#FF0000")
assert(color_utils.rgb_to_hex(0, 255, 0) == "#00FF00")
assert(color_utils.rgb_to_hex(0, 0, 255) == "#0000FF")
assert(color_utils.rgb_to_hex(255, 255, 0) == "#FFFF00")
assert(color_utils.rgb_to_hex(255, 0, 255) == "#FF00FF")
assert(color_utils.rgb_to_hex(0, 255, 255) == "#00FFFF")
assert(color_utils.rgb_to_hex(128, 128, 128) == "#808080")
assert(color_utils.rgb_to_hex(255, 128, 0) == "#FF8000")
assert(color_utils.rgb_to_hex(128, 255, 0) == "#80FF00")
assert(color_utils.rgb_to_hex(0, 255, 128) == "#00FF80")
assert(color_utils.rgb_to_hex(0, 128, 255) == "#0080FF")
assert(color_utils.rgb_to_hex(128, 0, 255) == "#8000FF")
assert(color_utils.rgb_to_hex(255, 0, 128) == "#FF0080")
assert(color_utils.rgb_to_hex(128, 255, 255) == "#80FFFF")
assert(color_utils.rgb_to_hex(255, 128, 255) == "#FF80FF")
assert(color_utils.rgb_to_hex(255, 255, 128) == "#FFFF80")
assert(color_utils.rgb_to_hex(128, 128, 255) == "#8080FF")
