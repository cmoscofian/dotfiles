local test_function_name_query = vim.treesitter.query.parse("go", [[
	(function_declaration
		name: (identifier) @function.identifier
		(#match? @function.identifier "^(Test|Benchmark)([A-Z].*)?$")
	)
]])

local subtest_method_name_query = vim.treesitter.query.parse("go", [[
	(call_expression
		function: (selector_expression (field_identifier) @method.identifier)
		(#match? @method.identifier "^Run$")
		arguments: [
			(argument_list . (interpreted_string_literal (interpreted_string_literal_content) @method.identifier.string))
			(argument_list . [(identifier) (call_expression) (selector_expression)] @method.identifier.variable)
		]
	)
]])

local ginkgo_subject_function_query = vim.treesitter.query.parse("go", [[
	(call_expression
		function: (identifier) @function.identifier
		(#match? @function.identifier "^(It|Specify)")
		arguments: [
			(argument_list . (interpreted_string_literal (interpreted_string_literal_content) @function.identifier.string))
			(argument_list . [(identifier) (call_expression) (selector_expression)] @function.identifier.variable)
		]
	)
]])

local ginkgo_container_subject_function_query = vim.treesitter.query.parse("go", [[
	(call_expression
		function: (identifier) @function.identifier
		(#match? @function.identifier "^(Describe|Context|When|It|Specify)")
		arguments: [
			(argument_list . (interpreted_string_literal (interpreted_string_literal_content) @function.identifier.string))
			(argument_list . [(identifier) (call_expression) (selector_expression)] @function.identifier.variable)
		]
	)
]])

--- @param node TSNode
--- @param patterns string[]
--- @return boolean
local match_node_text_to_patterns = function(node, patterns)
	local node_text = vim.treesitter.get_node_text(node, 0)
	for _, pattern in ipairs(patterns) do
		local match = string.find(node_text, pattern)
		if match then
			return true
		end
	end
	return false
end

--- Get test/ benchmark "^(Test|Benchmark)([A-Z].*)?$" name under the cursor
--- @return string | nil
local get_test_function_name_under_cursor = function()
	local node = vim.treesitter.get_node()
	while node and node:type() ~= "function_declaration" do
		node = node:parent()
	end

	if not node then
		vim.notify("No test/benchmark function match 'function_declaration' under the cursor", vim.log.levels.WARN)
		return nil
	end

	local next = test_function_name_query:iter_captures(node, 0)
	local _, capture = next()
	if not capture then
		vim.notify("No test/benchmark function capture under the cursor", vim.log.levels.WARN)
		return nil
	end
	return vim.treesitter.get_node_text(capture, 0)
end

--- Get test/ benchmark "^Run$" name under the cursor
--- @return string | nil
local get_subtest_method_name_under_cursor = function()
	local cursor_node = vim.treesitter.get_node()
	while cursor_node and not (cursor_node:type() == "call_expression" and match_node_text_to_patterns(cursor_node, { "^[tb].Run" })) do
		cursor_node = cursor_node:parent()
	end
	if not cursor_node then
		vim.notify("No test/benchmark subtest 'call_expression' match '^[tb].Run' under the cursor", vim.log.levels.WARN)
		return nil
	end

	for _, matches, _ in subtest_method_name_query:iter_matches(cursor_node, 0) do
		for id, nodes in pairs(matches) do
			for _, node in ipairs(nodes) do
				if subtest_method_name_query.captures[id] == "method.identifier.string" then
					--- @diagnostic disable-next-line: redundant-return-value
					return string.gsub(vim.treesitter.get_node_text(node, 0), " ", "_")
				end
				if subtest_method_name_query.captures[id] == "method.identifier.variable" then
					vim.notify("Run method name is a variable, cannot be infered!", vim.log.levels.WARN)
					--- @type string | nil
					local result = nil
					--- @param input string
					vim.ui.input({ prompt = "Pattern: " }, function(input)
						result = string.gsub(input, " ", "_")
					end)
					return result
				end
			end
		end
	end
	vim.notify("No test/benchmark function capture under the cursor", vim.log.levels.WARN)
	return nil
end

--- Get Ginkgo subject "^(It|Specify)" test name under the cursor
--- @return string | nil
local get_ginkgo_subject_test_name_under_cursor = function()
	local cursor_node = vim.treesitter.get_node()
	while cursor_node and not (cursor_node:type() == "call_expression" and match_node_text_to_patterns(cursor_node, { "^It%(", "^Specify%(" })) do
		cursor_node = cursor_node:parent()
	end
	if not cursor_node then
		vim.notify("No test 'call_expression' match '^(It|Specify)' under the cursor", vim.log.levels.WARN)
		return nil
	end

	for _, matches, _ in ginkgo_subject_function_query:iter_matches(cursor_node, 0) do
		for id, nodes in pairs(matches) do
			for _, node in ipairs(nodes) do
				if ginkgo_subject_function_query.captures[id] == "function.identifier.string" then
					return vim.treesitter.get_node_text(node, 0)
				end
				if ginkgo_subject_function_query.captures[id] == "function.identifier.variable" then
					vim.notify("Run method name is a variable, cannot be infered!", vim.log.levels.WARN)
					--- @type string | nil
					local result = nil
					--- @param input string
					vim.ui.input({ prompt = "Pattern: " }, function(input)
						result = input
					end)
					return result
				end
			end
		end
	end
	vim.notify("No test/benchmark function capture under the cursor", vim.log.levels.WARN)
	return nil
end

--- Select Ginkgo test from all available tests that match the pattern
--- "^(Describe|Context|When|It|Specify)".
--- @return string | nil
local get_ginkgo_test_name_from_file = function()
	local methods = {}
	local tree = vim.treesitter.get_parser():parse()[1]
	for _, match in ginkgo_container_subject_function_query:iter_matches(tree:root(), 0) do
		local method = {}
		for _, nodes in pairs(match) do
			for _, node in ipairs(nodes) do
				table.insert(method, vim.treesitter.get_node_text(node, 0))
			end
		end
		table.insert(methods, method)
	end
	if not #methods then
		vim.notify("Test name is a variable, cannot be infered!", vim.log.levels.WARN)
		return nil
	end
	--- @type string | nil
	local result = nil
	vim.ui.select(methods, {
		prompt = "Select ginkgo test for debbuging",
		--- @param item string[]
		format_item = function(item)
			return item[1] .. "(\"" .. item[2] .. "\")"
		end,
		--- @param choice string[]
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
		name = "Main (main.go)",
		request = "launch",
		mode = "debug",
		program = "${file}",
		cwd = "${workspaceFolder}",
		outputMode = "remote",
	},
	{
		type = "go",
		name = "Main (cmd/main.go)",
		request = "launch",
		mode = "debug",
		program = "${workspaceFolder}/cmd",
		cwd = "${workspaceFolder}",
		outputMode = "remote",
	},
	setmetatable({
		type = "go",
		name = "Test '^(Test|Benchmark)([A-Z].*)?$'",
		request = "launch",
		mode = "test",
		program = "${fileDirname}",
		cwd = "${workspaceFolder}",
		outputMode = "remote",
	}, {
		__call = function(config)
			config.args = { "-test.v" }
			local test_name = get_test_function_name_under_cursor()
			if test_name then
				table.insert(config.args, "-test.run")
				table.insert(config.args, test_name)
			end
			return config
		end,
	}),
	setmetatable({
		type = "go",
		name = "Test '^Run$'",
		request = "launch",
		mode = "test",
		program = "${fileDirname}",
		cwd = "${workspaceFolder}",
		outputMode = "remote",
	}, {
		__call = function(config)
			config.args = { "-test.v" }
			local test_name = get_subtest_method_name_under_cursor()
			if test_name then
				table.insert(config.args, "-test.run")
				table.insert(config.args, "^Test.*/" .. test_name)
			end
			return config
		end,
	}),
	setmetatable({
		type = "go",
		name = "Ginkgo '^(It|Specify)'",
		request = "launch",
		mode = "test",
		program = "${fileDirname}",
		cwd = "${workspaceFolder}",
		outputMode = "remote",
	}, {
		__call = function(config)
			config.args = { "-ginkgo.v" }
			local test_name = get_ginkgo_subject_test_name_under_cursor()
			if test_name then
				table.insert(config.args, "-ginkgo.focus")
				table.insert(config.args, test_name)
			end
			return config
		end,
	}),
	setmetatable({
		type = "go",
		name = "Ginkgo '^(Describe|Context|When|It|Specify)'",
		request = "launch",
		mode = "test",
		program = "${fileDirname}",
		cwd = "${workspaceFolder}",
		outputMode = "remote",
	}, {
		__call = function(config)
			config.args = { "-ginkgo.v" }
			local test_name = get_ginkgo_test_name_from_file()
			if test_name then
				table.insert(config.args, "-ginkgo.focus")
				table.insert(config.args, test_name)
			end
			return config
		end,
	}),
}
