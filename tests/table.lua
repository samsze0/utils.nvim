local tbl_utils = require("utils.table")
local debug = require("utils").debug

T.assert_deep_eq(
  tbl_utils.map({ 1, 2, 3 }, function(k, v) return v * 2 end),
  { 2, 4, 6 }
)
local res = tbl_utils.map(
  { a = 1, b = 2, c = 3 },
  function(k, v) return v * 2 end
)
T.assert(tbl_utils.any(res, function(k, v) return v == 2 end))
T.assert(tbl_utils.any(res, function(k, v) return v == 4 end))
T.assert(tbl_utils.any(res, function(k, v) return v == 6 end))
T.assert_deep_eq(
  tbl_utils.map({ 1, 2, 3 }, function(k, v)
    if k ~= 2 then
      return v * 2
    else
      return nil
    end
  end, {}),
  { 2, 6 }
)

T.assert(tbl_utils.contains({ 1, 2, 3 }, 1))
T.assert(tbl_utils.contains({ 1, 2, 3 }, 2))
T.assert(tbl_utils.contains({ 1, 2, 3 }, 3))
T.assert(not tbl_utils.contains({ 1, 2, 3 }, 4))
T.assert(not tbl_utils.contains({ 1, 2, 3 }, {}))
T.assert(not tbl_utils.contains({ 1, 2, 3 }, "a"))
T.assert(not tbl_utils.contains({ 1, 2, 3 }, { "a", "b" }))

T.assert_deep_eq(
  tbl_utils.iter_to_table((function()
    local i = 0
    return function()
      i = i + 1
      if i <= 3 then return i end
    end
  end)()),
  { 1, 2, 3 }
)

T.assert(tbl_utils.is_array({ 1, 2, 3 }))
T.assert(not tbl_utils.is_array({ a = 1, b = 2, c = 3 }))

T.assert(
  tbl_utils.reduce({ 1, 2, 3 }, function(acc, k, v) return acc + v end, 0) == 6
)
T.assert(
  tbl_utils.reduce(
    { a = 1, b = 2, c = 3 },
    function(acc, k, v) return acc + v end,
    0
  ) == 6
)
T.assert(
  tbl_utils.reduce(
    { 1, 2, 3 },
    function(acc, k, v) return acc + v end,
    0,
    { is_array = true }
  ) == 6
)
T.assert(
  tbl_utils.reduce(
    { a = 1, b = 2, c = 3 },
    function(acc, k, v) return acc + v end,
    0,
    { is_array = false }
  ) == 6
)
T.assert(
  tbl_utils.reduce(
    { a = 1, b = 2, c = 3 },
    function(acc, k, v) return acc + v end,
    10,
    { is_array = false }
  ) == 16
)

T.assert_eq(tbl_utils.sum({ }), 0)
T.assert_eq(tbl_utils.sum({ 1, 2, 3 }), 6)
T.assert_eq(tbl_utils.sum({ a = 1, b = 2, c = 3 }), 6)
T.assert_eq(tbl_utils.sum({ 1, 2, 3 }, function(k, v) return v * 2 end), 12)
T.assert(
  tbl_utils.sum({ a = 1, b = 2, c = 3 }, function(k, v) return v * 2 end) == 12
)

T.assert_deep_eq(tbl_utils.filter({}, function(i, v) return v end), {})
T.assert_deep_eq(tbl_utils.filter({1, 2, 3}, function(i, v) return v ~= 2 end), {1, 3})
T.assert_deep_eq(tbl_utils.filter({1, 2, 3}, function(i, v) return i ~= 2 end), {1, 3})
T.assert_deep_eq(tbl_utils.filter({a = 1, b = 2, c = 3}, function(k, v) return v ~= 2 end), {a = 1, c = 3})
T.assert_deep_eq(tbl_utils.filter({a = 1, b = 2, c = 3}, function(k, v) return k ~= "b" end), {a = 1, c = 3})

T.assert_deep_eq(tbl_utils.reverse({1, 2, 3}), {3, 2, 1})
T.assert_deep_eq(tbl_utils.reverse({}), {})

T.assert_deep_eq(tbl_utils.join_first_two_elements({1, 2, 3}, function(a, b) return a + b end), {3, 3})
T.assert_deep_eq(tbl_utils.join_first_two_elements({1, 2, 3}, function(a, b) return a + b end, { error_if_insufficient_length = true }), {3, 3})
T.assert_deep_eq(tbl_utils.join_first_two_elements({1, 2, 3}, function(a, b) return a + b end, { error_if_insufficient_length = false }), {3, 3})
local result = tbl_utils.join_first_two_elements({ 1 }, function(a, b) return a + b end, { error_if_insufficient_length = false })
T.assert_deep_eq(result, { 1 })
T.assert_error(function()
  return tbl_utils.join_first_two_elements({ 1 }, function(a, b) return a + b end, { error_if_insufficient_length = true })
end)