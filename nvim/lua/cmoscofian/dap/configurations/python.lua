local ts_utils = require("nvim-treesitter.ts_utils")

local poetry_getenv = function()
    local handle = io.popen("poetry env info -p")
    if handle ~= nil then
        local result = handle:read("*a")
        handle:close()
        return result:sub(1, #result - 1)
    end
    return nil
end

local python_path = function()
    local poetry = poetry_getenv()
    if vim.fn.executable(poetry .. "/bin/python") == 1 then
        return poetry .. "/bin/python"
    end

    local pipx = os.getenv("PIPX_HOME")
    if vim.fn.executable(pipx .. "/venvs/bin/python") == 1 then
        return pipx .. "/venvs/bin/python"
    end

    local pwd = vim.fn.getcwd()
    if vim.fn.executable(pwd .. "/venv/bin/python") == 1 then
        return pwd .. "/venv/bin/python"
    end

    return "/usr/bin/python3"
end

local pytest_method = function()
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
        pythonPath = python_path,
    },
    {
        type = "python",
        request = "launch",
        name = "Pytest (default)",
        module = "pytest",
        args = { "-vv" },
        pythonPath = python_path,
    },
    setmetatable({
        type = "python",
        request = "launch",
        name = "Pytest (single)",
        module = "pytest",
        args = { "${file}", "-vv" },
        pythonPath = python_path,
    }, {
        __call = function(config)
            local method = pytest_method()
            if method then
                table.insert(config.args, "-k" .. method)
            end
            return config
        end,
    }),
}
