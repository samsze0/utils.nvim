local M = {}

---@generic T : any
---@generic U : any
---@param tbl table<any, T> | T[]
---@param func fun(k: any, v: T): U
---@param opts? { is_array?: boolean | nil }
---@return U[]
M.map = function(tbl, func, opts)
  opts = vim.tbl_extend("force", {
    is_array = nil, -- If nil, auto-detect if tbl is array
  }, opts or {})

  local new_tbl = {}
  if opts.is_array or (opts.is_array == nil and M.is_array(tbl)) then
    for i, v in ipairs(tbl) do
      local result = func(i, v)
      table.insert(new_tbl, result)
    end
    return new_tbl
  else
    for k, v in pairs(tbl) do
      local result = func(k, v)
      table.insert(new_tbl, result)
    end
  end

  return new_tbl
end

---@generic T : any
---@param tbl table<any, T>
---@return T[]
M.values = function(tbl)
  return M.map(tbl, function(_, v) return v end)
end

---@generic T : any
---@param tbl table<any, T>
---@param elem T
---@return boolean
M.contains = function(tbl, elem)
  return M.any(tbl, function(_, v) return v == elem end)
end

-- Convert an iterator to a table
-- Be careful of what you are passing in as arg. Because it can potentially cause an infinite loop
--
---@generic T : any
---@param iter fun(): T
---@return T[]
function M.iter_to_table(iter)
  local tbl = {}
  for v in iter do
    table.insert(tbl, v)
  end
  return tbl
end

---@param t table<any, any> | any[]
---@return boolean
M.is_array = function(t) return #t > 0 and t[1] ~= nil end

---@generic T : any
---@generic U: any
---@param tbl table<any, T> | T[]
---@param fn fun(acc?: U, k: any, v: T): any
---@param opts? { is_array?: boolean | nil }
---param init? U
M.reduce = function(tbl, fn, init, opts)
  opts = vim.tbl_extend("force", {
    is_array = nil, -- If nil, auto-detect if tbl is array
  }, opts or {})

  local acc = init
  if opts.is_array or (opts.is_array == nil and M.is_array(tbl)) then
    for i, v in ipairs(tbl) do
      acc = fn(acc, i, v)
    end
  else
    for k, v in pairs(tbl) do
      acc = fn(acc, k, v)
    end
  end
  return acc
end

---@generic T : any
---@generic V : any
---@param tbl table<any, T> | T[]
---@param fn? fun(k: any, v: T): number
---@param opts? { is_array?: boolean | nil }
---@return V
M.sum = function(tbl, fn, opts)
  opts = vim.tbl_extend("force", {
    is_array = nil, -- If nil, auto-detect if tbl is array
  }, opts or {})

  return M.reduce(
    tbl,
    function(acc, i, v)
      if not fn then
        return acc + v
      else
        return acc + fn(i, v)
      end
    end,
    0,
    {
      is_array = opts.is_array,
    }
  )
end

---@generic T : any
---@param tbl T
---@param fn fun(k: any, v: any): boolean
---@param opts? { is_array?: boolean | nil }
---@return T
M.filter = function(tbl, fn, opts)
  opts = vim.tbl_extend("force", {
    is_array = nil, -- If nil, auto-detect if tbl is array
  }, opts or {})

  local result = {}
  if opts.is_array or (opts.is_array == nil and M.is_array(tbl)) then
    for i, v in ipairs(tbl) do
      if fn(i, v) then table.insert(result, v) end
    end
  else
    for k, v in pairs(tbl) do
      if fn(k, v) then result[k] = v end
    end
  end
  return result
end

---@generic T: any[]
---@param list T
---@return T
M.reverse = function(list)
  local reversed = {}
  for i = #list, 1, -1 do
    table.insert(reversed, list[i])
  end
  return reversed
end

---@generic T: any[]
---@param list T
---@param join_fn fun(a: any, b: any): any
---@param opts? { error_if_insufficient_length?: boolean }
---@return T
M.join_first_two_elements = function(list, join_fn, opts)
  opts = vim.tbl_extend(
    "force",
    { error_if_insufficient_length = false },
    opts or {}
  )

  if #list < 2 then
    if opts.error_if_insufficient_length then
      error("Insufficient length")
    else
      return list
    end
  end

  local first = table.remove(list, 1)
  local second = table.remove(list, 1)
  table.insert(list, 1, join_fn(first, second))
  return list
end

---@generic T : any
---@param tbl table<any, T> | T[]
---@param fn fun(k: any, v: T): boolean
---@param opts? { is_array?: boolean | nil }
---@return any | nil, T | nil
M.find = function(tbl, fn, opts)
  opts = vim.tbl_extend("force", {
    is_array = nil, -- If nil, auto-detect if tbl is array
  }, opts or {})

  if opts.is_array or (opts.is_array == nil and M.is_array(tbl)) then
    for i, v in ipairs(tbl) do
      if fn(i, v) then return i, v end
    end
  else
    for k, v in pairs(tbl) do
      if fn(k, v) then return k, v end
    end
  end
  return nil, nil
end

---@generic T : any
---@param tbl table<any, T> | T[]
---@param fn fun(k: any, v: T): boolean
---@param opts? { is_array?: boolean | nil }
---@return any, T
M.find_unsafe = function(tbl, fn, opts)
  local k, v = M.find(tbl, fn, opts)
  if k == nil then error("Not found") end
  return k, v
end

---@generic T : any
---@param tbl table<T, any> | T[]
---@return T[]
M.keys = function(tbl)
  local keys = {}
  for k, _ in pairs(tbl) do
    table.insert(keys, k)
  end
  return keys
end

---@generic T : any
---@generic U : any
---@param tbl table<any, T> | T[]
---@param opts? { is_array?: boolean, init?: U, fn?: (fun(k: any, v: T): U) }
---@return U?
M.max = function(tbl, opts)
  opts = vim.tbl_extend("force", {
    is_array = nil, -- If nil, auto-detect if tbl is array
    fn = function(k, v) return v end,
  }, opts or {})

  local max = opts.init
  if opts.is_array or (opts.is_array == nil and M.is_array(tbl)) then
    for i, v in ipairs(tbl) do
      local value = opts.fn(i, v)
      if max == nil or value > max then max = value end
    end
  else
    for k, v in pairs(tbl) do
      local value = opts.fn(k, v)
      if max == nil or value > max then max = value end
    end
  end

  return max
end

---@generic T : any
---@generic U : any
---@param tbl table<any, T> | T[]
---@param opts? { is_array?: boolean, init?: U, fn?: (fun(k: any, v: T): U) }
---@return U
M.max_unsafe = function(tbl, opts)
  local max = M.max(tbl, opts)
  if max == nil then error("No elements in list") end
  return max
end

-- Sort a table
--
-- If the table is an array, the sorted array is returned.
-- If the table is a map, the sorted keys are returned.
-- The original table is not modified.
--
---@generic T : any
---@param tbl table<any, T> | T[]
---@param compare_fn fun(a: T, b: T): boolean
---@param opts? { is_array?: boolean }
---@return any[] | T[]
M.sort = function(tbl, compare_fn, opts)
  opts = vim.tbl_extend("force", {
    is_array = nil, -- If nil, auto-detect if tbl is array
  }, opts or {})

  local keys = M.keys(tbl)
  table.sort(keys, function(a, b) return compare_fn(tbl[a], tbl[b]) end)
  if opts.is_array or (opts.is_array == nil and M.is_array(tbl)) then
    local sorted = {}
    for _, k in ipairs(keys) do
      table.insert(sorted, tbl[k])
    end
    return sorted
  else
    return keys
  end
end

-- Slice an array
--
---@generic T : any
---@param list T[]
---@param opts? { first?: number, last?: number, step?: number }
---@return T[]
M.slice = function(list, opts)
  opts = opts or {}

  local sliced = {}

  for i = opts.first or 1, opts.last or #list, opts.step or 1 do
    sliced[#sliced + 1] = list[i]
  end

  return sliced
end

-- Extend a list
--
---@generic T : any
---@vararg T[]
---@return T[]
M.list_extend = function(...)
  local args = { ... }
  local result = {}
  for _, list in ipairs(args) do
    for _, v in ipairs(list) do
      table.insert(result, v)
    end
  end
  return result
end

-- Check if any element in the table satisfies the condition
--
---@generic T : any
---@param tbl table<any, T>
---@param fn fun(k: any, v: T): boolean
---@param opts? { is_array?: boolean }
M.any = function(tbl, fn, opts)
  opts = vim.tbl_extend("force", {
    is_array = nil, -- If nil, auto-detect if tbl is array
  }, opts or {})

  if opts.is_array or (opts.is_array == nil and M.is_array(tbl)) then
    for i, v in ipairs(tbl) do
      if fn(i, v) then return true end
    end
  else
    for k, v in pairs(tbl) do
      if fn(k, v) then return true end
    end
  end

  return false
end

---@param target table
---@param k any key
---@param v any value
---@param mode "force" | "keep" | "error"
local function _tbl_extend(target, k, v, mode)
  if mode == "keep" then
    if target[k] == nil then target[k] = v end
  elseif mode == "force" then
    target[k] = v
  else -- opts.mode == "error"
    if target[k] ~= nil then error(("Key %s already exists"):format(k)) end
    target[k] = v
  end
end

-- Same as `vim.tbl_extend` but does not mutate the input args
--
---@alias TblExtendOpts { mode: "force" | "keep" | "error" }
---@param opts TblExtendOpts
---@vararg table
---@return table
M.tbl_extend = function(opts, ...)
  local result = {}
  local args = { ... }
  for _, tbl in ipairs(args) do
    for k, v in pairs(tbl) do
      _tbl_extend(result, k, v, opts.mode)
    end
  end

  return result
end

---@param target table
---@param source table
---@param mode "force" | "keep" | "error"
local function _tbl_deep_extend(target, source, mode)
  for k, v in pairs(source) do
    if type(v) ~= "table" then
      _tbl_extend(target, k, v, mode)
    elseif getmetatable(v) ~= nil then
      _tbl_extend(target, k, v, mode)
    elseif v["__is_module"] == true then
      _tbl_extend(target, k, v, mode)
    elseif M.is_array(v) then
      _tbl_extend(target, k, v, mode)
    else
      if target[k] == nil then target[k] = {} end
      _tbl_deep_extend(target[k], v, mode)
    end
  end
end

-- Same as `vim.tbl_deep_extend` but does not mutate the input args
--
---@alias TblDeepExtendOpts { mode: "force" | "keep" | "error" }
---@param opts TblDeepExtendOpts
---@vararg table
---@return table
M.tbl_deep_extend = function(opts, ...)
  local result = {}
  local args = { ... }
  for _, tbl in ipairs(args) do
    _tbl_deep_extend(result, tbl, opts.mode)
  end

  return result
end

-- Filter out nil values from a table
--
---@generic T : table
---@return T
M.non_nil = function(tbl)
  return M.filter(tbl, function(_, v) return v ~= nil end)
end

-- Filter out nil or false values from a table
--
---@generic T : table
---@return T
M.non_falsey = function(tbl)
  return M.filter(tbl, function(_, v) return v ~= nil and v ~= false end)
end

-- Filter out nil or empty string values from a table
--
---@generic T : table<any, string> | string[]
---@param tbl T
---@return T
M.non_empty = function(tbl)
  return M.filter(tbl, function(_, v) return v ~= nil and v ~= "" end)
end

return M
