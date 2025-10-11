return function(callback, _)
	local xdg = os.getenv("XDG_RUNTIME_HOME")
	callback({
		type = "executable",
		command = xdg .. "/python/tools/debugpy/bin/python",
		args = { "-m", "debugpy.adapter" },
		options = {
			source_filetype = "python",
		},
	})
end
