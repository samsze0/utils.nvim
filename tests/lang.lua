local lang_utils = require("utils.lang")

assert(lang_utils.match(1, {
  [1] = "one",
  [2] = "two",
  [3] = "three",
}, "default") == "one")
assert(lang_utils.match(2, {
  [1] = "one",
  [2] = "two",
  [3] = "three",
}, "default") == "two")
assert(lang_utils.match(4, {
  [1] = "one",
  [2] = "two",
  [3] = "three",
}, "default") == "default")

assert(lang_utils.switch(1, {
  [1] = function() return "one" end,
  [2] = function() return "two" end,
  [3] = function() return "three" end,
}, function() return "default" end) == "one")
assert(lang_utils.switch(1, {
  [1] = function(match) return tostring(match) .. "one" end,
  [2] = function(match) return tostring(match) .. "two" end,
  [3] = function(match) return tostring(match) .. "three" end,
}, function() return "default" end) == "1one")
assert(lang_utils.switch(4, {
  [1] = function() return "one" end,
  [2] = function() return "two" end,
  [3] = function() return "three" end,
}, function(match) return tostring(match) .. "default" end) == "4default")

