return function(callback, config)
	local host = config.host or "127.0.0.1"
	local port = config.port or "30000"
	local addr = string.format("%s:%s", host, port)
	local xdg = os.getenv("XDG_STATE_HOME")
	local logfile = string.format("%s/dlv.log", xdg)

	local opts = {
		stdio = { nil, nil, nil },
		args = { "dap", "--listen", addr, "--log", "--log-output", "dap", "--log-dest", logfile },
		detached = true
	}

	local handle, pid
	handle, pid = vim.uv.spawn("dlv", opts, function(code)
		if handle and not handle:is_closing() then
			handle:close()
		end
		if code ~= 0 then
			vim.schedule_wrap(function()
				vim.notify("dlv exited with error code: " .. code, vim.log.levels.WARN)
			end)
		end
	end)

	assert(handle, "Error running dlv: " .. pid)

	vim.defer_fn(function()
		callback({
			type = "server",
			host = host,
			port = port
		})
	end, 100)
end
