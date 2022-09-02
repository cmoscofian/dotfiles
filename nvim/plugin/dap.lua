local dap = require("dap")
local ui = require("dapui")
local conf = require("cmoscofian.dap")

ui.setup {}

dap.adapters = conf.adapters
dap.configurations = conf.configurations
dap.listeners.after.event_initialized["dapui_config"] = function()
    ui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    ui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    ui.close()
end


vim.fn.sign_define("DapBreakpoint", { texthl = "Decorator" })
vim.fn.sign_define("DapBreakpointCondition", { texthl = "Special" })
vim.fn.sign_define("DapStopped", { texthl = "SpecialChar", linehl = "DiffText" })
vim.fn.sign_define("DapBreakpointRejected", { texthl = "DiagnosticError" })

local opts = { silent = true }
vim.keymap.set("n", "<leader>d", dap.toggle_breakpoint, opts)
vim.keymap.set("n", "<leader>D", function() dap.set_breakpoint(vim.fn.input("Condition: ")) end, opts)
vim.keymap.set("n", "<F5>", dap.continue, opts)
vim.keymap.set("n", "<F10>", dap.step_over, opts)
vim.keymap.set("n", "<F11>", dap.step_into, opts)
vim.keymap.set("n", "<F12>", dap.step_out, opts)
vim.keymap.set("n", "<leader>tu", ui.toggle, opts)
