local languages = { "go" }

local adapters = function()
    local T = {}
    for _, lang in pairs(languages) do
        local path = string.format("cmoscofian.dap.adapters.%s", lang)
        local ok, module = pcall(require, path)
        assert(ok)

        T[lang] = module
    end
    return T
end

local configurations = function()
    local T = {}
    for _, lang in pairs(languages) do
        local path = string.format("cmoscofian.dap.configurations.%s", lang)
        local ok, module = pcall(require, path)
        assert(ok)

        T[lang] = module
    end
    return T
end

return {
    adapters = adapters(),
    configurations = configurations(),
}
