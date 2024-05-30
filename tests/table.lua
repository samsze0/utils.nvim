local tbl_utils = require("utils.table")
local debug = require("utils").debug

assert(
  vim.deep_equal(
    tbl_utils.map({ 1, 2, 3 }, function(k, v) return v * 2 end),
    { 2, 4, 6 }
  )
)
local res = tbl_utils.map(
  { a = 1, b = 2, c = 3 },
  function(k, v) return v * 2 end
)
assert(tbl_utils.any(res, function(k, v) return v == 2 end))
assert(tbl_utils.any(res, function(k, v) return v == 4 end))
assert(tbl_utils.any(res, function(k, v) return v == 6 end))
assert(vim.deep_equal(
  tbl_utils.map({ 1, 2, 3 }, function(k, v)
    if k ~= 2 then
      return v * 2
    else
      return nil
    end
  end, {}),
  { 2, 6 }
))

assert(tbl_utils.contains({ 1, 2, 3 }, 1))
assert(tbl_utils.contains({ 1, 2, 3 }, 2))
assert(tbl_utils.contains({ 1, 2, 3 }, 3))
assert(not tbl_utils.contains({ 1, 2, 3 }, 4))
assert(not tbl_utils.contains({ 1, 2, 3 }, {}))
assert(not tbl_utils.contains({ 1, 2, 3 }, "a"))
assert(not tbl_utils.contains({ 1, 2, 3 }, { "a", "b" }))

assert(vim.deep_equal(
  tbl_utils.iter_to_table((function()
    local i = 0
    return function()
      i = i + 1
      if i <= 3 then return i end
    end
  end)()),
  { 1, 2, 3 }
))

assert(tbl_utils.is_array({ 1, 2, 3 }))
assert(not tbl_utils.is_array({ a = 1, b = 2, c = 3 }))

assert(
  tbl_utils.reduce({ 1, 2, 3 }, function(acc, k, v) return acc + v end, 0) == 6
)
assert(
  tbl_utils.reduce(
    { a = 1, b = 2, c = 3 },
    function(acc, k, v) return acc + v end,
    0
  ) == 6
)
assert(
  tbl_utils.reduce(
    { 1, 2, 3 },
    function(acc, k, v) return acc + v end,
    0,
    { is_array = true }
  ) == 6
)
assert(
  tbl_utils.reduce(
    { a = 1, b = 2, c = 3 },
    function(acc, k, v) return acc + v end,
    0,
    { is_array = false }
  ) == 6
)
assert(
  tbl_utils.reduce(
    { a = 1, b = 2, c = 3 },
    function(acc, k, v) return acc + v end,
    10,
    { is_array = false }
  ) == 16
)

assert(tbl_utils.sum({ }) == 0)
assert(tbl_utils.sum({ 1, 2, 3 }) == 6)
assert(tbl_utils.sum({ a = 1, b = 2, c = 3 }) == 6)
assert(tbl_utils.sum({ 1, 2, 3 }, function(k, v) return v * 2 end) == 12)
assert(
  tbl_utils.sum({ a = 1, b = 2, c = 3 }, function(k, v) return v * 2 end) == 12
)

assert(vim.deep_equal(tbl_utils.filter({}, function(i, v) return v end), {}))
assert(vim.deep_equal(tbl_utils.filter({1, 2, 3}, function(i, v) return v ~= 2 end), {1, 3}))
assert(vim.deep_equal(tbl_utils.filter({1, 2, 3}, function(i, v) return i ~= 2 end), {1, 3}))
assert(vim.deep_equal(tbl_utils.filter({a = 1, b = 2, c = 3}, function(k, v) return v ~= 2 end), {a = 1, c = 3}))
assert(vim.deep_equal(tbl_utils.filter({a = 1, b = 2, c = 3}, function(k, v) return k ~= "b" end), {a = 1, c = 3}))

assert(vim.deep_equal(tbl_utils.reverse({1, 2, 3}), {3, 2, 1}))
assert(vim.deep_equal(tbl_utils.reverse({}), {}))

assert(vim.deep_equal(tbl_utils.join_first_two_elements({1, 2, 3}, function(a, b) return a + b end), {3, 3}))
assert(vim.deep_equal(tbl_utils.join_first_two_elements({1, 2, 3}, function(a, b) return a + b end, { error_if_insufficient_length = true }), {3, 3}))
assert(vim.deep_equal(tbl_utils.join_first_two_elements({1, 2, 3}, function(a, b) return a + b end, { error_if_insufficient_length = false }), {3, 3}))
local ok, result, _ = pcall(function()
  return tbl_utils.join_first_two_elements({ 1 }, function(a, b) return a + b end, { error_if_insufficient_length = false })
end)
assert(ok)
assert(vim.deep_equal(result, { 1 }))
local ok, _ = pcall(function()
  return tbl_utils.join_first_two_elements({ 1 }, function(a, b) return a + b end, { error_if_insufficient_length = true })
end)
assert(not ok)