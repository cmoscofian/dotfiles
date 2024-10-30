local M = {}

M.trim = function(s)
	if not s then
		return ""
	end
	return s:gsub("^%s*(.-)%s*$", "%1")
end

return M
