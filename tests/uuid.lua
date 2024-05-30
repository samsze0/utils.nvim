local uuid_utils = require("utils.uuid")

local v4_uuid = uuid_utils.v4()
T.assert(v4_uuid:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x"))