return function(callback, config)
    local xdg = os.getenv("XDG_DATA_HOME")
    callback({
        type = "executable",
        command = xdg .. "/venv/debugpy/bin/python",
        args = { "-m", "debugpy.adapter" },
        options = {
            source_filetype = "python",
        },
    })
end
