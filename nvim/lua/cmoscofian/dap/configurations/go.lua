local ts_utils = require("nvim-treesitter.ts_utils")

local leaf_node_query = vim.treesitter.query.parse("go", [[
	(call_expression
		(identifier) @testmethod
		(#match? @testmethod "^(It|Specify)")
		(argument_list
			(interpreted_string_literal
				(interpreted_string_literal_content) @methodname
			)
		)
	)
]])

local container_query = vim.treesitter.query.parse("go", [[
	(call_expression
		(identifier) @testmethod
		(#match? @testmethod "^(Describe|Context|When|It|Specify)")
		(argument_list
			(interpreted_string_literal
				(interpreted_string_literal_content) @methodname
			)
		)
	)
]])

--- Get Ginkgo Leaf Node "^(It|Specify)" test under the cursor
--- @return string | nil
local get_ginkgo_leaf_node_test_under_cursor = function()
	local node = ts_utils.get_node_at_cursor(0, true)
	while node do
		if node:type() ~= "call_expression" then
			goto skip
		end

		for id, capture in leaf_node_query:iter_captures(node, 0) do
			if leaf_node_query.captures[id] == "methodname" then
				return vim.treesitter.get_node_text(capture, 0)
			end
		end

		::skip::
		node = node:parent()
	end
	vim.notify("No test method found!", vim.log.levels.WARN)
	return nil
end

--- Get all Ginkgo leaf node and containers in the file
--- @return string | nil
local get_all_ginkgo_tests = function()
	local methods = {}
	local tree = vim.treesitter.get_parser():parse()[1]
	for _, match in container_query:iter_matches(tree:root(), 0) do
		local method = {}
		for _, nodes in pairs(match) do
			for _, node in ipairs(nodes) do
				table.insert(method, vim.treesitter.get_node_text(node, 0))
			end
		end
		table.insert(methods, method)
	end
	if not #methods then
		vim.notify("No test method found!", vim.log.levels.WARN)
		return nil
	end
	local result = nil
	vim.ui.select(methods, {
		prompt = "Select ginkgo test for debbuging",
		format_item = function(item)
			return item[1] .. "(\"" .. item[2] .. "\")"
		end,
	}, function(choice)
		if choice and #choice > 1 then
			result = choice[2]
		end
	end)
	return result
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
		name = "Ginkgo All",
		request = "launch",
		mode = "test",
		program = "./${relativeFileDirname}",
	}, {
		__call = function(config)
			local test_name = get_all_ginkgo_tests()
			if test_name then
				config.args = { "-ginkgo.v", "-ginkgo.focus", test_name }
			end
			return config
		end,
	}),
	setmetatable({
		type = "go",
		name = "Ginkgo '^(It|Specify)'",
		request = "launch",
		mode = "test",
		program = "./${relativeFileDirname}",
	}, {
		__call = function(config)
			local test_name = get_ginkgo_leaf_node_test_under_cursor()
			if test_name then
				config.args = { "-ginkgo.v", "-ginkgo.focus", test_name }
			end
			return config
		end,
	}),
}
