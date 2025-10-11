return function(callback, config)
	local host = config.host or "127.0.0.1"
	local port = config.port or "30001"
	callback({
		type = "server",
		host = host,
		port = port,
	})
end
