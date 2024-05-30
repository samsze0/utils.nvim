local file_utils = require("utils.files")
local debug = require("utils").debug

local file_strs = {
  "dir1/dir2/file4.js",
  "dir1/dir2/",
  "dir1/file2.txt",
  "dir1/dir2/file6",
  "dir1/dir2/FILE5.rs",
  "file1.lua",
  "dir1/file3.py",
  "dir1/",
}

local file_paths = file_utils.from_strs(file_strs)
T.assert_eq(file_paths[1]:basename(), "file4.js")

local sorted_paths = file_utils.sort(file_paths)
-- for _, p in ipairs(sorted_paths) do
--   print(p:tostring())
-- end
T.assert_deep_eq(sorted_paths, {
  file_paths[8],
  file_paths[6],
  file_paths[2],
  file_paths[3],
  file_paths[7],
  file_paths[1],
  file_paths[5],
  file_paths[4],
})
