local semver_utils = require("utils.semantic_versioning")

local ok, _ = pcall(
  function()
    semver_utils.satisfy(
      { major = 1, minor = 1, patch = 1 },
      { major = { 2, 1 } }
    )
  end
)
assert(not ok)

assert(
  semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 1, nil } }
  )
)
assert(
  semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 1, 2 } }
  )
)
assert(
  semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 1, 2 }, minor = { 1, nil } }
  )
)
assert(
  semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 1, 2 }, minor = { nil, 4 } }
  )
)
assert(
  semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 1, 2 }, minor = { 1, 4 }, patch = { 1, nil } }
  )
)
assert(
  semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 1, 2 }, minor = { 1, 4 }, patch = { nil, 2 } }
  )
)
assert(
  not semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 2, nil } }
  )
)
assert(
  semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 0, 1 } }
  )
)
assert(
  not semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 0, 1 }, minor = { nil, 0 } }
  )
)
assert(
  not semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 0, 1 }, minor = { 0, 1 }, patch = { nil, 0 } }
  )
)
