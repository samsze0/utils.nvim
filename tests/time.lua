local time_utils = require("utils.time")

T.assert_eq(time_utils.human_readable_diff(os.time()), "just now")
T.assert_eq(time_utils.human_readable_diff(os.time() - 60), "a minute ago")
T.assert_eq(time_utils.human_readable_diff(os.time() - 60 * 60), "an hour ago")
T.assert_eq(time_utils.human_readable_diff(os.time() - 60 * 60 * 24), "a day ago")
T.assert_eq(time_utils.human_readable_diff(os.time() - 60 * 60 * 24 * 7), "a week ago")
T.assert_eq(time_utils.human_readable_diff(os.time() - 60 * 60 * 24 * 30), "a month ago")
