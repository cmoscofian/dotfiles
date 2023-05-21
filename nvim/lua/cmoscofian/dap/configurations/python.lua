return {
    {
        type = "python",
        request = "launch",
        name = "Venv",
        program = "${file}",
        pythonPath = function()
            local pipx = os.getenv("PIPX_HOME")
            if vim.fn.executable(pipx .. "/venv/bin/python") == 1 then
                return pipx .. "/venv/bin/python"
            end

            local pwd = vim.fn.getcwd()
            if vim.fn.executable(pwd .. "/venv/bin/python") == 1 then
                return pwd .. "/venv/bin/python"
            end

            return "/usr/bin/python3"
        end,
    },
}
