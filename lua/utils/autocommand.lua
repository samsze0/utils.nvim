local tbl_utils = require("utils.table")
local opts_utils = require("utils.opts")

local M = {}

-- Took from:
-- https://github.com/MunifTanjim/nui.nvim/blob/main/lua/nui/utils/autocmd.lua

---@enum AutocmdEvent
local Event = {
  -- after adding a buffer to the buffer list
  BufAdd = "BufAdd",
  -- deleting a buffer from the buffer list
  BufDelete = "BufDelete",
  -- after entering a buffer
  BufEnter = "BufEnter",
  -- after renaming a buffer
  BufFilePost = "BufFilePost",
  -- before renaming a buffer
  BufFilePre = "BufFilePre",
  -- just after buffer becomes hidden
  BufHidden = "BufHidden",
  -- before leaving a buffer
  BufLeave = "BufLeave",
  -- after the 'modified' state of a buffer changes
  BufModifiedSet = "BufModifiedSet",
  -- after creating any buffer
  BufNew = "BufNew",
  -- when creating a buffer for a new file
  BufNewFile = "BufNewFile",
  -- read buffer using command
  BufReadCmd = "BufReadCmd",
  -- after reading a buffer
  BufReadPost = "BufReadPost",
  -- before reading a buffer
  BufReadPre = "BufReadPre",
  -- just before unloading a buffer
  BufUnload = "BufUnload",
  -- after showing a buffer in a window
  BufWinEnter = "BufWinEnter",
  -- just after buffer removed from window
  BufWinLeave = "BufWinLeave",
  -- just before really deleting a buffer
  BufWipeout = "BufWipeout",
  -- write buffer using command
  BufWriteCmd = "BufWriteCmd",
  -- after writing a buffer
  BufWritePost = "BufWritePost",
  -- before writing a buffer
  BufWritePre = "BufWritePre",
  -- info was received about channel
  ChanInfo = "ChanInfo",
  -- channel was opened
  ChanOpen = "ChanOpen",
  -- command undefined
  CmdUndefined = "CmdUndefined",
  -- command line was modified
  CmdlineChanged = "CmdlineChanged",
  -- after entering cmdline mode
  CmdlineEnter = "CmdlineEnter",
  -- before leaving cmdline mode
  CmdlineLeave = "CmdlineLeave",
  -- after entering the cmdline window
  CmdWinEnter = "CmdwinEnter",
  -- before leaving the cmdline window
  CmdWinLeave = "CmdwinLeave",
  -- after loading a colorscheme
  ColorScheme = "ColorScheme",
  -- before loading a colorscheme
  ColorSchemePre = "ColorSchemePre",
  -- after popup menu changed
  CompleteChanged = "CompleteChanged",
  -- after finishing insert complete
  CompleteDone = "CompleteDone",
  -- idem, before clearing info
  CompleteDonePre = "CompleteDonePre",
  -- cursor in same position for a while
  CursorHold = "CursorHold",
  -- idem, in Insert mode
  CursorHoldI = "CursorHoldI",
  -- cursor was moved
  CursorMoved = "CursorMoved",
  -- cursor was moved in Insert mode
  CursorMovedI = "CursorMovedI",
  -- diffs have been updated
  DiffUpdated = "DiffUpdated",
  -- directory changed
  DirChanged = "DirChanged",
  -- after changing the 'encoding' option
  EncodingChanged = "EncodingChanged",
  -- before exiting
  ExitPre = "ExitPre",
  -- append to a file using command
  FileAppendCmd = "FileAppendCmd",
  -- after appending to a file
  FileAppendPost = "FileAppendPost",
  -- before appending to a file
  FileAppendPre = "FileAppendPre",
  -- before first change to read-only file
  FileChangedRO = "FileChangedRO",
  -- after shell command that changed file
  FileChangedShell = "FileChangedShell",
  -- after (not) reloading changed file
  FileChangedShellPost = "FileChangedShellPost",
  -- read from a file using command
  FileReadCmd = "FileReadCmd",
  -- after reading a file
  FileReadPost = "FileReadPost",
  -- before reading a file
  FileReadPre = "FileReadPre",
  -- new file type detected (user defined)
  FileType = "FileType",
  -- write to a file using command
  FileWriteCmd = "FileWriteCmd",
  -- after writing a file
  FileWritePost = "FileWritePost",
  -- before writing a file
  FileWritePre = "FileWritePre",
  -- after reading from a filter
  FilterReadPost = "FilterReadPost",
  -- before reading from a filter
  FilterReadPre = "FilterReadPre",
  -- after writing to a filter
  FilterWritePost = "FilterWritePost",
  -- before writing to a filter
  FilterWritePre = "FilterWritePre",
  -- got the focus
  FocusGained = "FocusGained",
  -- lost the focus to another app
  FocusLost = "FocusLost",
  -- if calling a function which doesn't exist
  FuncUndefined = "FuncUndefined",
  -- after starting the GUI
  GUIEnter = "GUIEnter",
  -- after starting the GUI failed
  GUIFailed = "GUIFailed",
  -- when changing Insert/Replace mode
  InsertChange = "InsertChange",
  -- before inserting a char
  InsertCharPre = "InsertCharPre",
  -- when entering Insert mode
  InsertEnter = "InsertEnter",
  -- just after leaving Insert mode
  InsertLeave = "InsertLeave",
  -- just before leaving Insert mode
  InsertLeavePre = "InsertLeavePre",
  -- just before popup menu is displayed
  MenuPopup = "MenuPopup",
  -- after changing the mode
  ModeChanged = "ModeChanged",
  -- after setting any option
  OptionSet = "OptionSet",
  -- after :make, :grep etc.
  QuickFixCmdPost = "QuickFixCmdPost",
  -- before :make, :grep etc.
  QuickFixCmdPre = "QuickFixCmdPre",
  -- before :quit
  QuitPre = "QuitPre",
  -- upon string reception from a remote vim
  RemoteReply = "RemoteReply",
  -- when the search wraps around the document
  SearchWrapped = "SearchWrapped",
  -- after loading a session file
  SessionLoadPost = "SessionLoadPost",
  -- after ":!cmd"
  ShellCmdPost = "ShellCmdPost",
  -- after ":1,2!cmd", ":w !cmd", ":r !cmd".
  ShellFilterPost = "ShellFilterPost",
  -- after nvim process received a signal
  Signal = "Signal",
  -- sourcing a Vim script using command
  SourceCmd = "SourceCmd",
  -- after sourcing a Vim script
  SourcePost = "SourcePost",
  -- before sourcing a Vim script
  SourcePre = "SourcePre",
  -- spell file missing
  SpellFileMissing = "SpellFileMissing",
  -- after reading from stdin
  StdinReadPost = "StdinReadPost",
  -- before reading from stdin
  StdinReadPre = "StdinReadPre",
  -- found existing swap file
  SwapExists = "SwapExists",
  -- syntax selected
  Syntax = "Syntax",
  -- a tab has closed
  TabClosed = "TabClosed",
  -- after entering a tab page
  TabEnter = "TabEnter",
  -- before leaving a tab page
  TabLeave = "TabLeave",
  -- when creating a new tab
  TabNew = "TabNew",
  -- after entering a new tab
  TabNewEntered = "TabNewEntered",
  -- after changing 'term'
  TermChanged = "TermChanged",
  -- after the process exits
  TermClose = "TermClose",
  -- after entering Terminal mode
  TermEnter = "TermEnter",
  -- after leaving Terminal mode
  TermLeave = "TermLeave",
  -- after opening a terminal buffer
  TermOpen = "TermOpen",
  -- after setting "v:termresponse"
  TermResponse = "TermResponse",
  -- text was modified
  TextChanged = "TextChanged",
  -- text was modified in Insert mode(no popup)
  TextChangedI = "TextChangedI",
  -- text was modified in Insert mode(popup)
  TextChangedP = "TextChangedP",
  -- after a yank or delete was done (y, d, c)
  TextYankPost = "TextYankPost",
  -- after UI attaches
  UIEnter = "UIEnter",
  -- after UI detaches
  UILeave = "UILeave",
  -- user defined autocommand
  User = "User",
  -- whenthe user presses the same key 42 times
  UserGettingBored = "UserGettingBored",
  -- after starting Vim
  VimEnter = "VimEnter",
  -- before exiting Vim
  VimLeave = "VimLeave",
  -- before exiting Vim and writing ShaDa file
  VimLeavePre = "VimLeavePre",
  -- after Vim window was resized
  VimResized = "VimResized",
  -- after Nvim is resumed
  VimResume = "VimResume",
  -- before Nvim is suspended
  VimSuspend = "VimSuspend",
  -- after closing a window
  WinClosed = "WinClosed",
  -- after entering a window
  WinEnter = "WinEnter",
  -- before leaving a window
  WinLeave = "WinLeave",
  -- when entering a new window
  WinNew = "WinNew",
  -- after scrolling a window
  WinScrolled = "WinScrolled",

  -- alias for `BufAdd`
  BufCreate = "BufAdd",
  -- alias for `BufReadPost`
  BufRead = "BufReadPost",
  -- alias for `BufWritePre`
  BufWrite = "BufWritePre",
  -- alias for `EncodingChanged`
  FileEncoding = "EncodingChanged",
}

M.Event = Event

---@alias Autocmd { id: number, events: AutocmdEvent[] | AutocmdEvent, description?: string, group_id?: number, group_name?: string, pattern?: string, buffer?: number, buffer_local: boolean, lua_callback: AutocmdCallback, once: boolean, nested?: boolean, vim_command?: string }

---@alias AutocmdCallback fun(context: { id: number, event: AutocmdEvent, group?: number, match: string, buf: number, file: string, data: any })
---@param opts { events: AutocmdEvent[] | AutocmdEvent, description?: string, group?: string | number, pattern?: string, buffer?: number, lua_callback: AutocmdCallback, once?: boolean, nested?: boolean, vim_command?: string }
---@return number autocmd_id
function M.create(opts)
  opts = opts or {}

  if opts.pattern and opts.buffer then
    error("Cannot specify both pattern and buffer option")
  end

  if opts.vim_command and opts.lua_callback then
    error("Cannot specify both vim_command and lua_callback option")
  end

  return vim.api.nvim_create_autocmd(opts.events, {
    group = opts.group,
    pattern = opts.pattern,
    desc = opts.description,
    callback = opts.lua_callback,
    once = opts.once,
    nested = opts.nested,
    buffer = opts.buffer,
    command = opts.vim_command,
  })
end

---@param name string
---@param opts? { clear?: boolean }
---@return number group_id
function M.create_group(name, opts)
  opts = opts_utils.extend({ clear = false }, opts)

  return vim.api.nvim_create_augroup(name, opts)
end

---@param opts { group?: number | string, events?: AutocmdEvent[] | AutocmdEvent, pattern?: string, buffer?: number }
---@return Autocmd[] autocmds
function M.get(opts)
  opts = opts or {}

  if opts.pattern ~= nil and opts.buffer ~= nil then
    error("Cannot specify both pattern and buffer option")
  end

  local autocmds = vim.api.nvim_get_autocmds({
    group = opts.group,
    event = opts.events,
    pattern = opts.pattern,
    buffer = opts.buffer,
  })

  return tbl_utils.map(
    autocmds,
    function(_, cmd)
      return {
        id = cmd.id,
        events = cmd.event,
        description = cmd.desc,
        group_id = cmd.group,
        group_name = cmd.group_name,
        pattern = cmd.pattern,
        buffer = cmd.buffer,
        buffer_local = cmd.buflocal,
        lua_callback = cmd.callback,
        once = cmd.once,
        nested = cmd.nested,
        vim_command = cmd.command,
      }
    end
  )
end

---@param autocmd_id number
function M.delete(autocmd_id) vim.api.nvim_del_autocmd(autocmd_id) end

---@param group string | number
function M.delete_group(group)
  if type(group) == "string" then
    vim.api.nvim_del_augroup_by_name(group)
  elseif type(group) == "number" then
    vim.api.nvim_del_augroup_by_id(group)
  end

  error("Invalid group type")
end

return M
