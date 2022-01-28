local handlers = require("cmoscofian.lsp.handlers")
local setup = require("cmoscofian.lsp.setup")

local M = {}

M.handlers = {
    on_reference = handlers.on_reference,
    on_rename = handlers.on_rename,
}

M.config = {
    capabilities = setup.set_capabilities(),
    on_attach = setup.on_attach,
}

return M
