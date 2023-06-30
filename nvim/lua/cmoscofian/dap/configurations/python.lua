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
        name = "Test",
        module = "pytest",
        args = { "${file}" },
        pythonPath = python_path,
    },
}
