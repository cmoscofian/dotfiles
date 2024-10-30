return function(callback, config)
	local stdout = vim.uv.new_pipe(false)
	local host = config.host or "127.0.0.1"
	local port = config.port or "38697"
	local addr = string.format("%s:%s", host, port)

	local opts = {
		stdio = { nil, stdout },
		args = { "dap", "-l", addr },
		detached = true
	}

	local handler = nil
	handler, err = vim.uv.spawn("dlv", opts, function(code)
		stdout:close()
		handler:close()
		if code ~= 0 then
			print("dlv exited with code", code)
		end
	end)

	assert(handler, "Error running dlv: " .. tostring(err))

	stdout:read_start(function(err, chunk)
		assert(not err, err)
		if chunk then
			vim.schedule(function()
				require("dap.repl").append(chunk)
			end)
		end
	end)

	vim.defer_fn(function()
		callback {
			type = "server",
			host = "127.0.0.1",
			port = port
		}
	end, 100)
end
