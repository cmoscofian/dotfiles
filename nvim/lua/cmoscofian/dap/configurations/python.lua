local ts_utils = require("nvim-treesitter.ts_utils")

local path = nil

--- Return the python executable from the poetry virtual environment if
--- available.
--- @return string | nil
local poetry_exec = function()
	local handle = io.popen("poetry env info -e")
	if handle ~= nil then
		local result = handle:read()
		handle:close()
		return result
	end
	return nil
end

--- Fetch the path of the "nearest" python executable (check for a poetry
--- project, then a virtual environment and finally python3 from $PATH)
--- @return string
local python_path = function()
	if path then
		return path
	end

	local poetry = poetry_exec()
	if poetry and vim.fn.executable(poetry) == 1 then
		path = poetry
		return poetry
	end

	local pwd = vim.fn.getcwd() .. "/.venv/bin/python"
	if vim.fn.executable(pwd) == 1 then
		path = pwd
		return pwd
	end

	return vim.fn.exepath("python3")
end

---Fetch the test method name under the cursor, based on the pattern ^test_*
---@return string | nil
local get_test_method_under_cursor = function()
	local node = ts_utils.get_node_at_cursor(0, true)
	while node and node:type() ~= "function_definition" do
		node = node:parent()
	end
	if not node then
		return nil
	end
	local query = vim.treesitter.query.parse("python", [[
		(function_definition
			(identifier) @testmethod
			(#match? @testmethod "^test")
		)
	]])
	local next = query:iter_captures(node, 0)
	local _, capture = next()
	if not capture then
		vim.notify(
			"No test method found!",
			vim.log.levels.WARN
		)
		return nil
	end
	return vim.treesitter.get_node_text(capture, 0)
end

return {
	{
		type = "python",
		request = "launch",
		name = "Main",
		program = "${file}",
		console = "integratedTerminal",
		justMyCode = false,
		pythonPath = python_path,
	},
	{
		type = "python",
		request = "launch",
		name = "Pytest (default)",
		module = "pytest",
		console = "integratedTerminal",
		justMyCode = false,
		args = { "-vv" },
		pythonPath = python_path,
	},
	setmetatable({
		type = "python",
		request = "launch",
		name = "Pytest (single)",
		module = "pytest",
		console = "integratedTerminal",
		justMyCode = false,
		args = { "${file}", "-vv" },
		pythonPath = python_path,
	}, {
		__call = function(config)
			local method = get_test_method_under_cursor()
			if method then
				table.insert(config.args, "-k" .. method)
			end
			return config
		end,
	}),
}
