local semver_utils = require("utils.semantic_versioning")

T.assert_error(function()
  semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 2, 1 } }
  )
end)

T.assert(
  semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 1, nil } }
  )
)
T.assert(
  semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 1, 2 } }
  )
)
T.assert(
  semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 1, 2 }, minor = { 1, nil } }
  )
)
T.assert(
  semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 1, 2 }, minor = { nil, 4 } }
  )
)
T.assert(
  semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 1, 2 }, minor = { 1, 4 }, patch = { 1, nil } }
  )
)
T.assert(
  semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 1, 2 }, minor = { 1, 4 }, patch = { nil, 2 } }
  )
)
T.assert(
  not semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 2, nil } }
  )
)
T.assert(
  semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 0, 1 } }
  )
)
T.assert(
  not semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 0, 1 }, minor = { nil, 0 } }
  )
)
T.assert(
  not semver_utils.satisfy(
    { major = 1, minor = 1, patch = 1 },
    { major = { 0, 1 }, minor = { 0, 1 }, patch = { nil, 0 } }
  )
)
