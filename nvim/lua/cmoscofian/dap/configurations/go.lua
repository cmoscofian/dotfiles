local utils = require("dap.utils")

return {
	{
		type = "go",
		name = "Debug Main",
		request = "launch",
		program = "${file}",
	},
	{
		type = "go",
		name = "Attach",
		mode = "local",
		request = "attach",
		processId = utils.pick_process,
	},
	{
		type = "go",
		name = "Debug Test",
		request = "launch",
		mode = "test",
		program = "${file}",
	},
	{
		type = "go",
		name = "Debug Test (go.mod)",
		request = "launch",
		mode = "test",
		program = "./${relativeFileDirname}",
	}
}
