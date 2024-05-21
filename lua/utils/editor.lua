local M = {}

-- Get current visual selection. If not in visual mode, get the last visual selection.
--
---@param opts? {}
---@return string[]
function M.get_visual_selection(opts)
  opts = opts or {}

	local start_pos, end_pos
	local mode = vim.api.nvim_get_mode().mode
	if mode ~= "v" then
		start_pos = vim.fn.getpos("'<")
		end_pos = vim.fn.getpos("'>")
	else
		local selection_anchor = vim.fn.getpos("v")
		local cursor_pos = vim.fn.getpos(".")
		if cursor_pos[2] > selection_anchor[2] or cursor_pos[3] > selection_anchor[3] then
			start_pos = selection_anchor
			end_pos = cursor_pos
		else
			start_pos = cursor_pos
			end_pos = selection_anchor
		end
	end

	local lines = vim.fn.getline(start_pos[2], end_pos[2])
	if #lines == 0 then
		return {}
	end

	-- Caution: must trim off end first because trim off start will affect the pos
	lines[#lines] = string.sub(lines[#lines], 0, end_pos[3]) -- Trim off end
	lines[1] = string.sub(lines[1], start_pos[3], string.len(lines[1])) -- Trim off start
	return lines
end

return M
