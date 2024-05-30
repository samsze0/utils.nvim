local lang_utils = require("utils.lang")

T.assert_eq(lang_utils.match(1, {
  [1] = "one",
  [2] = "two",
  [3] = "three",
}, "default"), "one")
T.assert_eq(lang_utils.match(2, {
  [1] = "one",
  [2] = "two",
  [3] = "three",
}, "default"), "two")
T.assert_eq(lang_utils.match(4, {
  [1] = "one",
  [2] = "two",
  [3] = "three",
}, "default"), "default")

T.assert_eq(lang_utils.switch(1, {
  [1] = function() return "one" end,
  [2] = function() return "two" end,
  [3] = function() return "three" end,
}, function() return "default" end), "one")
T.assert_eq(lang_utils.switch(1, {
  [1] = function(match) return tostring(match) .. "one" end,
  [2] = function(match) return tostring(match) .. "two" end,
  [3] = function(match) return tostring(match) .. "three" end,
}, function() return "default" end), "1one")
T.assert_eq(lang_utils.switch(4, {
  [1] = function() return "one" end,
  [2] = function() return "two" end,
  [3] = function() return "three" end,
}, function(match) return tostring(match) .. "default" end), "4default")

