local autocmd_utils = require("utils.autocommand")

local M = {}

---@alias EditorCursorPos { row: number, col: number, buf: number }
---@alias EditorMode { mode: string, blocking: boolean }

-- Get the current cursor position
--
---@return EditorCursorPos
function M.get_cursor_pos()
	local pos = vim.fn.getpos(".")
	return { row = pos[2], col = pos[3], buf = pos[1] }
end

-- Get selection anchor position
--
---@return EditorCursorPos
function M.get_selection_anchor_pos()
	local pos = vim.fn.getpos("v")
	return { row = pos[2], col = pos[3], buf = pos[1] }
end

---@pram mark: string
---@param opts? { buffer?: integer }
---@return EditorCursorPos
function M.get_mark_pos(mark, opts)
	opts = opts or {}

	local pos = vim.api.nvim_buf_get_mark(opts.buffer or 0, mark)
	return {
		row = pos[1],
		col = pos[2],
		buf = opts.buffer or 0,
	}
end

-- Get previous selection anchor positions
--
---@return EditorCursorPos start_pos, EditorCursorPos end_pos
function M.get_last_selection_anchor_pos()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	return { row = start_pos[2], col = start_pos[3], buf = start_pos[1] }, {
		row = end_pos[2],
		col = end_pos[3],
		buf = end_pos[1],
	}
end

-- Get the current mode
--
---@return EditorMode
function M.get_mode()
	return vim.api.nvim_get_mode()
end

-- Escape to normal mode
function M.to_normal_mode()
	-- FIX:
	-- Both implementations messes up vim.api.get_mode()
	-- My guess is vim would only consider updating the mode after it parses some user input

	error("Need fix")

	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", false)
	if vim.v.errmsg ~= "" then
		error(vim.v.errmsg)
	end

	-- vim.api.nvim_input("<Esc>")
	-- if vim.v.errmsg ~= "" then
	-- 	error(vim.v.errmsg)
	-- end
end

-- Get current visual selection. If not in visual mode, get the last visual selection.
--
---@param opts? {}
---@return string[]
function M.get_visual_selection(opts)
	opts = opts or {}

	if M.get_mode().blocking then
		error("Not implemented for block mode")
	end

	---@type EditorCursorPos
	local start_pos
	---@type EditorCursorPos
	local end_pos

	local mode = M.get_mode().mode

	if mode == "V" then -- Line select mode
		local selection_anchor = M.get_selection_anchor_pos()
		local cursor_pos = M.get_cursor_pos()
		if cursor_pos.row > selection_anchor.row then
			start_pos = selection_anchor
			end_pos = cursor_pos
		else
			start_pos = cursor_pos
			end_pos = selection_anchor
		end
	elseif mode == "v" then
		local selection_anchor = M.get_selection_anchor_pos()
		local cursor_pos = M.get_cursor_pos()
		if
			cursor_pos.row > selection_anchor.row
			or (cursor_pos.col == selection_anchor.row and cursor_pos.col > selection_anchor.col)
		then
			start_pos = selection_anchor
			end_pos = cursor_pos
		else
			start_pos = cursor_pos
			end_pos = selection_anchor
		end
	else
		start_pos, end_pos = M.get_last_selection_anchor_pos()
	end

	local lines = vim.fn.getline(start_pos.row, end_pos.row)
	if #lines == 0 then
		return {}
	end

	if mode == "V" then
		return lines
	end

	-- Caution: must trim off end first because trim off start will
	-- affect the pos if the selection only span a single line
	lines[#lines] = lines[#lines]:sub(0, end_pos.col) -- Trim off end
	lines[1] = lines[1]:sub(start_pos.col, lines[1]:len()) -- Trim off start
	return lines
end

return M
