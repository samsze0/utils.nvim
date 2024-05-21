local M = {}

-- Converts an RGB color to a hex string
--
---@param r number
---@param g number
---@param b number
M.rgb_to_hex = function(r, g, b) return ("#%02X%02X%02X"):format(r, g, b) end

return M
