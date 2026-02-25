local config = require("cmoscofian.dap")
local dap = require("dap")
local view = require("dap-view")

dap.adapters = config.adapters
dap.configurations = config.configurations

local opts = { silent = true }
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, opts)
vim.keymap.set("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Condition: ")) end, opts)
vim.keymap.set("n", "<leader>dl", function() dap.set_breakpoint(nil, nil, vim.fn.input("LogPoint: ")) end, opts)
vim.keymap.set("n", "<leader>dL", function() dap.set_breakpoint(nil, vim.fn.input("HitCondition: "), nil) end, opts)
vim.keymap.set("n", "<leader>dc", dap.clear_breakpoints, opts)
vim.keymap.set("n", "<leader>dr", dap.run_to_cursor, opts)
vim.keymap.set("n", "<leader>dt", view.toggle, opts)
vim.keymap.set("n", "<F5>", dap.continue, opts)
vim.keymap.set("n", "<F1>", dap.step_over, opts)
vim.keymap.set("n", "<F2>", dap.step_into, opts)
vim.keymap.set("n", "<F3>", dap.step_out, opts)

view.setup({
	winbar = {
		show = true,
		-- You can add a "console" section to merge the terminal with the other views
		sections = { "scopes", "breakpoints", "repl", "watches", "threads", "exceptions" },
		-- Must be one of the sections declared above
		default_section = "scopes",
		-- Configure each section individually
		-- Add your own sections
		custom_sections = {},
		controls = {
			enabled = true,
			position = "right",
			buttons = {
				"play",
				"step_into",
				"step_over",
				"step_out",
				"step_back",
				"run_last",
				"terminate",
				"disconnect",
			},
			custom_buttons = {},
		},
	},
	windows = {
		size = 0.25,
		position = "below",
		terminal = {
			size = 0.7,
			position = "left",
			-- List of debug adapters for which the terminal should be ALWAYS hidden
			hide = {},
		},
	},
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
		collapsed = "▷ ",
		expanded = "▼ ",
	},
	help = {
		border = nil,
	},
	render = {
		-- Optionally a function that takes two `dap.Variable`'s as arguments
		-- and is forwarded to a `table.sort` when rendering variables in the scopes view
		sort_variables = nil,
	},
	-- Controls how to jump when selecting a breakpoint or navigating the stack
	-- Comma separated list, like the built-in 'switchbuf'. See :help 'switchbuf'
	-- Only a subset of the options is available: newtab, useopen, usetab and uselast
	-- Can also be a function that takes the current winnr and the bufnr that will jumped to
	-- If a function, should return the winnr of the destination window
	switchbuf = "usetab,uselast",
	-- Auto open when a session is started and auto close when all sessions finish
	auto_toggle = true,
	-- Reopen dapview when switching to a different tab
	-- Can also be a function to dynamically choose when to follow, by returning a boolean
	-- If a function, receives the name of the adapter for the current session as an argument
	follow_tab = false,
})

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
