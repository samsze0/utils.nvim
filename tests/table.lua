local tbl_utils = require("utils.table")

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

local i, v = tbl_utils.find({ "a", "b", "c" }, function(i, v) return v == "b" end)
T.assert_eq(i, 2)
T.assert_eq(v, "b")
local i, v = tbl_utils.find({ 1, 2, 3 }, function(i, v) return v == 4 end)
T.assert_eq(i, nil)
T.assert_eq(v, nil)
local i, v = tbl_utils.find({ a = "a", b = "b", c = "c" }, function(k, v) return v == "b" end)
T.assert_eq(i, "b")
T.assert_eq(v, "b")
T.assert_error(function()
  return tbl_utils.find_unsafe({ 1, 2, 3 }, function(i, v) return v == 4 end)
end)
local i, v = tbl_utils.find_unsafe({ 1, 2, 3 }, function(i, v) return v == 3 end)
T.assert_eq(i, 3)
T.assert_eq(v, 3)

local result = tbl_utils.keys({ a = 1, b = 2, c = 3 })
T.assert_contains(result, "a")
T.assert_contains(result, "b")
T.assert_contains(result, "c")
T.assert_eq(#result, 3)

T.assert_eq(tbl_utils.max({ 1, 2, 3 }), 3)
T.assert_eq(tbl_utils.max({ a = 1, b = 2, c = 3 }), 3)
T.assert_eq(tbl_utils.max({ 1, 2, 3 }, { init = 10 }), 10)
T.assert_eq(tbl_utils.max({ 1, 2, 3 }, { fn = function(i, v)
  return -v
end }), -1)
T.assert_error(function()
  return tbl_utils.max_unsafe({ })
end)

T.assert_deep_eq(tbl_utils.sort({ 3, 1, 2 }, function(a, b)
  return a < b
end), { 1, 2, 3 })
T.assert_deep_eq(tbl_utils.sort({ a = 3, b = 1, c = 2 }, function(a, b)
  return a < b
end), { "b", "c", "a" })
T.assert_deep_eq(tbl_utils.sort({ 3, 1, 2 }, function(a, b)
  return a > b
end), { 3, 2, 1 })
T.assert_deep_eq(tbl_utils.sort({ a = 3, b = 1, c = 2 }, function(a, b)
  return a > b
end), { "a", "c", "b" })

T.assert_deep_eq(tbl_utils.slice({ 1, 2, 3 }, {
  first = 1,
}), { 1, 2, 3 })
T.assert_deep_eq(tbl_utils.slice({ 1, 2, 3 }, {
  first = 2,
}), { 2, 3 })
T.assert_deep_eq(tbl_utils.slice({ 1, 2, 3 }, {
  first = 3,
}), { 3 })
T.assert_deep_eq(tbl_utils.slice({ 1, 2, 3 }, {
  first = 4,
}), { })
T.assert_deep_eq(tbl_utils.slice({ 1, 2, 3 }, {
  first = 1,
  last = 1,
}), { 1 })
T.assert_deep_eq(tbl_utils.slice({ 1, 2, 3 }, {
  first = 1,
  last = 2,
}), { 1, 2 })
T.assert_deep_eq(tbl_utils.slice({ 1, 2, 3 }, {
  first = 1,
  last = 3,
}), { 1, 2, 3 })
T.assert_deep_eq(tbl_utils.slice({ 1, 2, 3 }, {
  first = 1,
  last = 4,
}), { 1, 2, 3 })

T.assert_deep_eq(tbl_utils.list_extend({ 1, 2, 3 }, { 4, 5, 6 }), { 1, 2, 3, 4, 5, 6 })
T.assert_deep_eq(tbl_utils.list_extend({ 1, 2, 3 }, { 4, 5, 6 }, { 7, 8, 9 }), { 1, 2, 3, 4, 5, 6, 7, 8, 9 })
T.assert_deep_eq(tbl_utils.list_extend({ 1, 2, 3 }, { }), { 1, 2, 3 })

T.assert(tbl_utils.any({ 1, 2, 3 }, function(i, v) return v == 2 end))
T.assert(not tbl_utils.any({ 1, 2, 3 }, function(i, v) return v == 4 end))
T.assert(tbl_utils.any({ a = 1, b = 2, c = 3 }, function(k, v) return v == 2 end))

T.assert_deep_eq(tbl_utils.tbl_extend({
  mode = "force"
}, { a = 1, b = 2 }, { c = 3 }), { a = 1, b = 2, c = 3 })
T.assert_deep_eq(tbl_utils.tbl_extend({
  mode = "force"
},
{ a = 1, b = 2 }, { a = 3 }), { a = 3, b = 2 })
T.assert_deep_eq(tbl_utils.tbl_extend({
  mode = "force"
}, { a = 1, b = 2 }, { a = 3, b = 4 }), { a = 3, b = 4 })
T.assert_deep_eq(tbl_utils.tbl_extend({
  mode = "force"
}, { a = 1, b = 2 }, { a = 3, b = 4 }, { a = 5, b = 6 }), { a = 5, b = 6 })
T.assert_error(function()
  return tbl_utils.tbl_extend({
    mode = "error"
  }, { a = 1, b = 2 }, { a = 3 })
end)
T.assert_deep_eq(tbl_utils.tbl_extend({
  mode = "error"
}, { a = 1, b = 2 }, { c = 3, d = 4 }), { a = 1, b = 2, c = 3, d = 4 })
T.assert_deep_eq(tbl_utils.tbl_extend({
  mode = "keep"
}, { a = 1, b = 2 }, { a = 3 }), { a = 1, b = 2 })

T.assert_deep_eq(tbl_utils.tbl_deep_extend({
  mode = "force"
}, { [1] = { a = 1 }, [2] = { b = 2 } }, { [1] = { c = 3 } }), { [1] = { a = 1, c = 3 }, [2] = { b = 2 } })
T.assert_deep_eq(tbl_utils.tbl_deep_extend({
  mode = "force"
}, { [1] = { a = 1 }, [2] = { b = 2 } }, { [1] = { a = 3 } }), { [1] = { a = 3 }, [2] = { b = 2 } })

T.assert_deep_eq(tbl_utils.non_empty({ "a", "", "b", "", "c" }), { "a", "b", "c" })
T.assert_deep_eq(tbl_utils.non_empty({ a = "a", b = "", c = "c" }), { a = "a", c = "c" })

T.assert_deep_eq(tbl_utils.non_false({ "a", false, "b", false, "c" }), { "a", "b", "c" })
T.assert_deep_eq(tbl_utils.non_false({ a = "a", b = false, c = "c" }), { a = "a", c = "c" })