local config = require("cmoscofian.dap")
local dap = require("dap")
local dapui = require("dapui")
local vscode = require("dap.ext.vscode")

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
vim.keymap.set("n", "<leader>dc", dap.clear_breakpoints, opts)
vim.keymap.set("n", "<leader>dr", dap.run_to_cursor, opts)
vim.keymap.set("n", "<F5>", dap.continue, opts)
vim.keymap.set("n", "<F10>", dap.step_over, opts)
vim.keymap.set("n", "<F11>", dap.step_into, opts)
vim.keymap.set("n", "<F12>", dap.step_out, opts)
vim.keymap.set("n", "<leader>dt", function() dapui.toggle({ reset = true }) end, opts)

dapui.setup {
	controls = {
		icons = {
			pause = "■",
			play = "▶",
			step_over = "→",
			step_into = "↓",
			step_out = "↑",
			step_back = "←",
			run_last = "↕",
			terminate = "✗",
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
				{ id = "stacks", size = 0.1 },
				{ id = "breakpoints", size = 0.2 },
				{ id = "watches", size = 0.2 },
				{ id = "scopes", size = 0.5 },
			},
			size = 40,
			position = "left",
		},
		{
			elements = {
				"repl",
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
		text = "⊚",
		texthl = "DapBreakpoint"
	},
	{
		name = "DapBreakpointCondition",
		text = "⊙",
		texthl = "DapBreakpointCondition"
	},
	{
		name = "DapBreakpointRejected",
		text = "✗",
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

vscode.load_launchjs(".vim/dap.json", nil)
