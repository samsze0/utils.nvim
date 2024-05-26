local M = {}

-- https://semver.org/

---@alias SemanticVersion { major: number, minor: number, patch: number, prerelease?: string }
---@alias SemanticVersionRange { major: { [1]: number?, [2]: number? }, minor?: { [1]: number?, [2]: number? }, patch?: { [1]: number?, [2]: number? } }

-- Check if a version satisfies a range
--
---@param version SemanticVersion
---@param range SemanticVersionRange
---@return boolean
function M.satisfy(version, range)
  local major, minor, patch = version.major, version.minor, version.patch

  local min, max = range.major[1], range.major[2]
  if min ~= nil and max ~= nil and min > max then error("Invalid range") end
  if min and major < min then return false end
  if max and major > max then return false end

  if major == max and range.minor ~= nil then
    min, max = range.minor[1], range.minor[2]
    if min ~= nil and max ~= nil and min > max then error("Invalid range") end
    if min and minor < min then return false end
    if max and minor > max then return false end

    if minor == max and range.patch ~= nil then
      min, max = range.patch[1], range.patch[2]
      if min ~= nil and max ~= nil and min > max then error("Invalid range") end
      if min and patch < min then return false end
      if max and patch > max then return false end
    end
  end

  return true
end

return M
