-- Tweaked from:
-- https://github.com/jbyuki/instant.nvim/blob/master/lua/instant/base64.lua

local bit = require("bit")
local bytes_utils = require("utils.bytes")

local b64enc = {}
local b64dec = {}

local b64 = 0
for i = string.byte("A"), string.byte("Z") do
  b64enc[b64] = string.char(i)
  b64 = b64 + 1
end
for i = string.byte("a"), string.byte("z") do
  b64enc[b64] = string.char(i)
  b64 = b64 + 1
end
for i = string.byte("0"), string.byte("9") do
  b64enc[b64] = string.char(i)
  b64 = b64 + 1
end
b64enc[b64] = "+"
b64 = b64 + 1
b64enc[b64] = "/"

local b64i = 0
for c = string.byte("A"), string.byte("Z") do
  b64dec[string.char(c)] = b64i
  b64i = b64i + 1
end
for c = string.byte("a"), string.byte("z") do
  b64dec[string.char(c)] = b64i
  b64i = b64i + 1
end
for c = string.byte("0"), string.byte("9") do
  b64dec[string.char(c)] = b64i
  b64i = b64i + 1
end
b64dec["+"] = b64i
b64i = b64i + 1
b64dec["/"] = b64i

---@param str string
---@return string base64_encoded_string
local function encode(str)
  local bytes = bytes_utils.str_to_bytes(str)

  local result = ""
  for i = 0, #bytes - 3, 3 do
    local b1 = bytes[i + 0 + 1]
    local b2 = bytes[i + 1 + 1]
    local b3 = bytes[i + 2 + 1]

    local c1 = bit.rshift(b1, 2)
    local c2 = bit.lshift(bit.band(b1, 0x3), 4) + bit.rshift(b2, 4)
    local c3 = bit.lshift(bit.band(b2, 0xF), 2) + bit.rshift(b3, 6)
    local c4 = bit.band(b3, 0x3F)

    result = result .. b64enc[c1]
    result = result .. b64enc[c2]
    result = result .. b64enc[c3]
    result = result .. b64enc[c4]
  end

  local rest = #bytes * 8 - #result * 6
  if rest == 8 then
    local b1 = bytes[#bytes]

    local c1 = bit.rshift(b1, 2)
    local c2 = bit.lshift(bit.band(b1, 0x3), 4)

    result = result .. b64enc[c1]
    result = result .. b64enc[c2]
    result = result .. "="
    result = result .. "="
  elseif rest == 16 then
    local b1 = bytes[#bytes - 1]
    local b2 = bytes[#bytes]

    local c1 = bit.rshift(b1, 2)
    local c2 = bit.lshift(bit.band(b1, 0x3), 4) + bit.rshift(b2, 4)
    local c3 = bit.lshift(bit.band(b2, 0xF), 2)

    result = result .. b64enc[c1]
    result = result .. b64enc[c2]
    result = result .. b64enc[c3]
    result = result .. "="
  end

  return result
end

---@param str string base64_encoded_string
---@return string
local function decode(str)
  local bytes = {}
  for j = 1, string.len(str), 4 do
    local new_data = {}
    local padding = 0

    for k = 0, 3 do
      local c = string.sub(str, j + k, j + k)
      if c ~= "=" then
        table.insert(new_data, b64dec[c])
      else
        padding = padding + 1
        table.insert(new_data, 0)
      end
    end

    table.insert(
      bytes,
      bit.bor(
        bit.lshift(new_data[1], 2),
        bit.band(bit.rshift(new_data[2], 4), 0x3)
      )
    )

    if padding <= 1 then
      table.insert(
        bytes,
        bit.bor(
          bit.lshift(bit.band(new_data[2], 0xF), 4),
          bit.rshift(new_data[3], 2)
        )
      )
    end

    if padding == 0 then
      table.insert(
        bytes,
        bit.bor(bit.lshift(bit.band(new_data[3], 0x3), 6), new_data[4])
      )
    end
  end

  return bytes_utils.bytes_to_str(bytes)
end

return {
  encode = encode,
  decode = decode,
}
