local config = require("cmoscofian.dap")
local dap = require("dap")
local dapui = require("dapui")
local vsc_de = require("dap.ext.vscode")

dap.adapters = config.adapters
dap.configurations = config.configurations

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open({ reset = true })
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

local opts = { silent = true }
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, opts)
vim.keymap.set("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Condition: ")) end, opts)
vim.keymap.set("n", "<leader>dl", function() dap.set_breakpoint(nil, nil, vim.fn.input("LogPoint: ")) end, opts)
vim.keymap.set("n", "<leader>dL", function() dap.set_breakpoint(nil, vim.fn.input("HitCondition: "), nil) end, opts)
vim.keymap.set("n", "<leader>dc", dap.clear_breakpoints, opts)
vim.keymap.set("n", "<leader>dr", dap.run_to_cursor, opts)
vim.keymap.set("n", "<leader>dt", function() dapui.toggle({ reset = true }) end, opts)
vim.keymap.set("n", "<F5>", dap.continue, opts)
vim.keymap.set("n", "<F10>", dap.step_over, opts)
vim.keymap.set("n", "<F11>", dap.step_into, opts)
vim.keymap.set("n", "<F12>", dap.step_out, opts)

dapui.setup {
	controls = {
		icons = {
			pause = "▣",
			play = "▶",
			step_over = "▶",
			step_into = "▼",
			step_out = "▲",
			step_back = "◀",
			run_last = "◆",
			terminate = "●",
			disconnect = "◎",
		}
	},
	icons = {
		expanded = "▼",
		collapsed = "▷",
		current_frame = "▷",
	},
	layouts = {
		{
			elements = {
				{ id = "stacks",      size = 0.1 },
				{ id = "breakpoints", size = 0.2 },
				{ id = "watches",     size = 0.2 },
				{ id = "scopes",      size = 0.5 },
			},
			size = 40,
			position = "left",
		},
		{
			elements = {
				{ id = "repl",    size = 0.5 },
				{ id = "console", size = 0.5 },
			},
			size = 0.3,
			position = "bottom",
		},
	},
	windows = {
		indent = 4,
	},
}

vim.fn.sign_define({
	{
		name = "DapBreakpoint",
		text = "•",
		texthl = "DapBreakpoint"
	},
	{
		name = "DapBreakpointCondition",
		text = "∘",
		texthl = "DapBreakpointCondition"
	},
	-- TODO: This does not exist in nvim-dap, open an upstream discussion.
	-- Should be simple to implement and adds a bit of value (I think)...
	{
		name = "DapHitCondition",
		text = "∘",
		texthl = "DapHitCondition",
	},
	{
		name = "DapLogPoint",
		text = "∘",
		texthl = "DapLogPoint",
	},
	{
		name = "DapBreakpointRejected",
		text = "▪",
		texthl = "DapBreakpointRejected",
		linehl = "DapBreakpointRejectedLine"
	},
	{
		name = "DapStopped",
		text = "",
		texthl = "DapStopped",
		linehl = "DapStoppedLine"
	},
})

vim.api.nvim_create_user_command("OsvStart", function(_)
	vim.cmd("packadd osv")
	require("osv").launch({ port = 30001 })
end, { force = true })

vim.api.nvim_create_user_command("OsvStop", function(_)
	require("osv").stop()
end, { force = true })

vsc_de.load_launchjs(".vim/dap.json", nil)
