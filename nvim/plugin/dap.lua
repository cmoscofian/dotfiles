local dap = require("dap")
local ui = require("dapui")
local config = require("cmoscofian.dap")

dap.adapters = config.adapters
dap.configurations = config.configurations

dap.listeners.after.event_initialized["dapui_config"] = function()
    ui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    ui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    ui.close()
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
vim.keymap.set("n", "<leader>dt", ui.toggle, opts)

ui.setup {
    layouts = {
        {
            elements = {
                "stacks",
                "breakpoints",
                "watches",
                "scopes",
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
        indent = 2,
    },
}

vim.fn.sign_define {
    {
        name = "DapBreakpoint",
        text = "*",
        texthl = "DapBreakpoint"
    },
    {
        name = "DapBreakpointCondition",
        text = "*",
        texthl = "DapBreakpointCondition"
    },
    {
        name = "DapBreakpointRejected",
        text = "x",
        texthl = "DapBreakpointRejected",
        linehl = "DapBreakpointRejectedLine"
    },
    {
        name = "DapStopped",
        texthl = "DapStopped",
        linehl = "DapStoppedLine"
    },
}
