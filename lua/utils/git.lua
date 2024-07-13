local opts_utils = require("utils.opts")
local tbl_utils = require("utils.table")
local terminal_utils = require("utils.terminal")
local str_utils = require("utils.string")

local M = {}

-- Return the shell command for retrieving the list of Git-aware files
--
---@param git_dir string
---@return string cmd
M.files_cmd = function(git_dir)
  -- TODO: support for filtering out git submodules / unreadable files
  -- Option 1: `--exclude-from`
  -- GIT_TEMP=$(mktemp); git submodule --quiet foreach 'echo $path' > $GIT_TEMP; git ls-files --full-name --no-recurse-submodules --exclude-standard --exclude-from $GIT_TEMP
  -- Option2: xargs (very slow)
  -- cmd = cmd .. " | xargs -I {} bash -c 'if [[ ! -d {} ]]; then echo {}; fi'"

  return ([[{ echo "$(git -C %s ls-files --full-name --exclude-standard)"; echo "$(git -C %s ls-files --full-name --others --exclude-standard)"; }]]):format(
    git_dir,
    git_dir
  )
end

-- Return the list of Git-aware files
--
---@alias GitUtilsFilesOptions { filter_unreadable?: boolean }
---@param git_dir string
---@param opts? GitUtilsFilesOptions
---@return string[]
M.files = function(git_dir, opts)
  if vim.fn.executable("git") ~= 1 then error("git is not installed") end

  opts = opts_utils.extend({
    filter_unreadable = false, -- Whether or not remove unreadable files
  }, opts)
  ---@cast opts GitUtilsFilesOptions

  local files, status, err = terminal_utils.systemlist(M.files_cmd(git_dir), {
    keepempty = false,
  })
  assert(files and status == 0, err)

  if opts.filter_unreadable then
    files = tbl_utils.filter(
      files,
      function(i, e) return vim.fn.filereadable(git_dir .. "/" .. e) == 1 end
    )
  end

  -- Filter out empty lines
  return tbl_utils.filter(
    files,
    function(i, e) return vim.trim(e):len() > 0 end
  )
end

-- Return the shell command for retrieving current git directory
M.current_dir_cmd = function() return [[git rev-parse --show-toplevel]] end

---@param opts? { }
---@return string? git_dir
M.current_dir = function(opts)
  if vim.fn.executable("git") ~= 1 then error("git is not installed") end

  opts = opts_utils.extend({}, opts)

  local path, status, err = terminal_utils.system(M.current_dir_cmd())
  if not path then return nil end
  return vim.trim(path)
end

---@param filepath string
---@param opts? { git_dir?: string, include_git_dir?: boolean }
---@return string gitpath
M.convert_filepath_to_gitpath = function(filepath, opts)
  if vim.fn.executable("git") ~= 1 then error("git is not installed") end

  opts = opts_utils.extend({
    git_dir = M.current_dir(),
  }, opts)

  filepath = vim.fn.fnamemodify(filepath, ":p")
  if not filepath then error("Invalid filepath") end
  local git_dir = vim.fn.fnamemodify(opts.git_dir, ":p")

  if filepath:sub(1, #git_dir) ~= git_dir then
    error(
      ("The filepath %s is not inside the git directory %s"):format(
        filepath,
        git_dir
      )
    )
  end

  local path = vim.fn.fnamemodify(filepath, ":~" .. git_dir .. ":.")
  if not path then error("Invalid filepath") end
  path = path:match("/(.*)")
  if not path then -- If filepath happens to be the git_dir
    path = ""
  end
  return path
end

-- Checkout a file at previous commit
--
-- Return the result of `git show HEAD`
--
---@param gitpath string
---@param opts? { git_dir?: string }
M.show_head = function(gitpath, opts)
  if vim.fn.executable("git") ~= 1 then error("git is not installed") end

  opts = opts_utils.extend({
    git_dir = M.current_dir(),
  }, opts)

  return terminal_utils.systemlist_unsafe(
    ("git -C '%s' show HEAD:'%s'"):format(opts.git_dir, gitpath)
  )
end

-- Checkout a file at staging area
--
-- Return the result of `git show`
--
---@param gitpath string
---@param opts? { git_dir?: string }
M.show_staged = function(gitpath, opts)
  if vim.fn.executable("git") ~= 1 then error("git is not installed") end

  opts = opts_utils.extend({
    git_dir = M.current_dir(),
  }, opts)

  return terminal_utils.systemlist_unsafe(
    ("git -C '%s' show :'%s'"):format(opts.git_dir, gitpath)
  )
end

-- Stash files
--
---@param opts? { git_dir?: string, message?: string, gitpaths: string[], stash_staged?: boolean }
M.stash = function(opts)
  if vim.fn.executable("git") ~= 1 then error("git is not installed") end

  opts = opts_utils.extend({
    git_dir = M.current_dir(),
    message = "wip",
  }, opts)

  if opts.gitpaths then
    local paths = str_utils.join(opts.gitpaths, function(_, x)
      return "'" .. x .. "'"
    end)
    terminal_utils.system_unsafe(
      ([[git -C '%s' stash push -m '%s' -- %s]]):format(
        opts.git_dir,
        opts.message,
        paths
      )
    )
  end

  if opts.stash_staged then
    terminal_utils.system_unsafe(
      ([[git -C '%s' stash push -m '%s' --staged]]):format(
        opts.git_dir,
        opts.message
      )
    )
  end

  error("Incorrect usage of git.stash")
end

-- Retrieve the diff statistics
--
-- Return the result of `git diff --stat`
-- By defeault, it shows the diff stat between worktree and previous commit (HEAD)
--
---@param opts? { git_dir?: string, ref?: string }
---@return string
M.diff_stat = function(opts)
  if vim.fn.executable("git") ~= 1 then error("git is not installed") end

  opts = opts_utils.extend({
    git_dir = M.current_dir(),
    ref = "HEAD",
  }, opts)

  local stat = terminal_utils.system_unsafe(([[git -C '%s' diff --stat %s | tail -1]]):format(opts.git_dir, opts.ref))
  return vim.trim(stat)
end

-- Retrieve the diff statistics for a stash
--
-- Return the result of `git stash show --stat`
--
---@param ref string
---@param opts? { git_dir?: string }
---@return string
M.stash_diff_stat = function(ref, opts)
  if vim.fn.executable("git") ~= 1 then error("git is not installed") end

  opts = opts_utils.extend({
    git_dir = M.current_dir(),
  }, opts)

  local stat = terminal_utils.system_unsafe(([[git -C '%s' stash show --stat %s | tail -1]]):format(opts.git_dir, ref))
  return vim.trim(stat)
end

-- Retrieve the list of stashes
--
---@param opts? { git_dir?: string }
---@return string[]
M.list_stash = function(opts)
  if vim.fn.executable("git") ~= 1 then error("git is not installed") end

  opts = opts_utils.extend({
    git_dir = M.current_dir(),
  }, opts)

  local command = ([[git -C '%s' stash list]]):format(opts.git_dir)
  local stash = terminal_utils.systemlist_unsafe(command, {
    keepempty = false,
    trim_endline = true
  })

  return stash
end

-- Checkout a file at specific stash
--
-- Return the result of `git show stash:file`
--
---@param gitpath string
---@param opts? { git_dir?: string }
M.show_stash_file = function(gitpath, opts)
  if vim.fn.executable("git") ~= 1 then error("git is not installed") end

  opts = opts_utils.extend({
    git_dir = M.current_dir(),
  }, opts)

  local stash = terminal_utils.systemlist_unsafe(
    ([[git -C '%s' show stash:'%s']]):format(M.current_dir(), gitpath)
  )
  return stash
end

return M
