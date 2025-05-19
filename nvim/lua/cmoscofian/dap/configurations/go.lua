local ts_utils = require("nvim-treesitter.ts_utils")

---Focus on the test methods under the cursor, based on the nearest
---`^Describe.*` pattern.
---@return string | nil
local get_ginkgo_nearest_describe_name = function()
	local node = ts_utils.get_node_at_cursor(0, true)
	while node and node:type() ~= "function_definition" do
		node = node:parent()
	end
	if not node then
		return nil
	end
	local query = vim.treesitter.query.parse("python", [[
		(call_expression
			(identifier) @testmethod
			(#match? @testmethod "^It\(")
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

---Fetch the test method name under the cursor, based on the pattern `^Context.*`
---@return string | nil
local get_ginkgo_nearest_context_name = function()
	local node = ts_utils.get_node_at_cursor(0, true)
	while node and node:type() ~= "function_definition" do
		node = node:parent()
	end
	if not node then
		return nil
	end
	local query = vim.treesitter.query.parse("python", [[
		(call_expression
			(identifier) @testmethod
			(#match? @testmethod "^Context\(")
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

---Fetch the test method name under the cursor, based on the pattern `^It.*`
---@return string | nil
local get_ginkgo_nearest_it_name = function()
	local node = ts_utils.get_node_at_cursor(0, true)
	while node and node:type() ~= "function_definition" do
		node = node:parent()
	end
	if not node then
		return nil
	end
	local query = vim.treesitter.query.parse("python", [[
		(call_expression
			(identifier) @testmethod
			(#match? @testmethod "^It\(")
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
		type = "go",
		name = "Main",
		request = "launch",
		program = "${file}",
	},
	{
		type = "go",
		name = "Go test (file)",
		request = "launch",
		mode = "test",
		program = "${file}",
	},
	{
		type = "go",
		name = "Go test (package)",
		request = "launch",
		mode = "test",
		program = "./${relativeFileDirname}",
	},
	setmetatable({
		type = "go",
		name = "Ginkgo 'Describe' focus",
		request = "launch",
		mode = "test",
		program = "./${relativeFileDirname}",
	}, {
		__call = function(config)
			local test_name = get_ginkgo_nearest_describe_name()
			if test_name then
				table.insert(config.args, { "-ginkgo.v", "-ginkgo.focus", test_name })
			end
			return config
		end,
	}),
	setmetatable({
		type = "go",
		name = "Ginkgo 'Context' focus",
		request = "launch",
		mode = "test",
		program = "./${relativeFileDirname}",
	}, {
		__call = function(config)
			local test_name = get_ginkgo_nearest_context_name()
			if test_name then
				table.insert(config.args, { "-ginkgo.v", "-ginkgo.focus", test_name })
			end
			return config
		end,
	}),
	setmetatable({
		type = "go",
		name = "Ginkgo 'It' focus",
		request = "launch",
		mode = "test",
		program = "./${relativeFileDirname}",
	}, {
		__call = function(config)
			local test_name = get_ginkgo_nearest_it_name()
			if test_name then
				table.insert(config.args, { "-ginkgo.v", "-ginkgo.focus", test_name })
			end
			return config
		end,
	}),
}
