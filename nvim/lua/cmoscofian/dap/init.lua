local languages = { "go", "python" }

local adapters = function()
	local T = {}
	for _, lang in pairs(languages) do
		local path = string.format("cmoscofian.dap.adapters.%s", lang)
		local ok, module = pcall(require, path)
		if ok then
			T[lang] = module
		end
	end
	return T
end

local configurations = function()
	local T = {}
	for _, lang in pairs(languages) do
		local path = string.format("cmoscofian.dap.configurations.%s", lang)
		local ok, module = pcall(require, path)
		if ok then
			T[lang] = module
		end
	end
	return T
end

return {
	adapters = adapters(),
	configurations = configurations(),
}
