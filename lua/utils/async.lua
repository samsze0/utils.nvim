-- Tweaked from:
-- https://github.com/ms-jpq/lua-async-await/blob/neo/lua/async.lua

local co = coroutine

-- Something to be injected into a thunk. This function when called with a coroutine,
-- will create the coroutine and advances it by one step.
-- If the coroutine is still alive after that, it will advance the coroutine again by
-- calling the function yielded by the coroutine.
--
---@param func function
---@param callback function
local pong = function (func, callback)
  assert(type(func) == "function", "type error :: expected func")
  local thread = co.create(func)

  local function step(...)
    local ok, val = co.resume(thread, ...)
    assert(ok, val)
    if co.status(thread) == "dead" then
      if callback then
        callback(val)
      end
    else
      assert(co.status(thread) == "running", "coroutine error :: expected running")

      assert(type(val) == "function", "type error :: expected func")
      val(step)
    end
  end

  step()
end

-- Return a factory that wrap a thunk with extra args
-- To be used with `pong`; To inject `pong` into some arbitrary thunk.
--
---@generic T: any
---@generic U: any
---@generic V: any
---@param func fun(args: T): U
---@return fun(extra_args: V): (fun(args: any): U) thunk_factory
local wrap = function (func)
  assert(type(func) == "function", "type error :: expected func")

  local factory = function (...)
    local params = {...}
    local thunk = function (step)
      table.insert(params, step)
      return func(unpack(params))
    end
    return thunk
  end
  return factory
end

-- Join many thunks into one
--
---@param thunks function[]
---@return function thunk
local join = function (thunks)
  local len = #thunks
  local done = 0
  local acc = {}

  local wrapper = function (step)
    if len == 0 then
      return step()
    end

    for i, thunk in ipairs(thunks) do
      assert(type(thunk) == "function", "thunk must be function")

      local callback = function (...)
        acc[i] = {...}
        done = done + 1
        if done == len then
          step(unpack(acc))
        end
      end
      thunk(callback)
    end
  end
  return wrapper
end

-- Sugar over coroutine
--
---@param defer function
local await = function (defer)
  assert(type(defer) == "function", "type error :: expected func")
  return co.yield(defer)
end

-- Sugar over coroutine
--
---@param defers function[]
local await_all = function (defers)
  assert(type(defers) == "table", "type error :: expected table")
  return co.yield(join(defers))
end

return {
  async = wrap(pong),
  await = await,
  await_all = await_all,
  wrap = wrap,
}