local time_utils = require("utils.time")
local debug = require("utils").debug

assert(time_utils.human_readable_diff(os.time()) == "just now")
assert(time_utils.human_readable_diff(os.time() - 60) == "a minute ago")
assert(time_utils.human_readable_diff(os.time() - 60 * 60) == "an hour ago")
assert(time_utils.human_readable_diff(os.time() - 60 * 60 * 24) == "a day ago")
assert(time_utils.human_readable_diff(os.time() - 60 * 60 * 24 * 7) == "a week ago")
assert(time_utils.human_readable_diff(os.time() - 60 * 60 * 24 * 30) == "a month ago")
