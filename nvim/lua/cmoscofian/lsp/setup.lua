local __telescope_status, _ = pcall(require, "telescope")

local M = {}

local function set_diagnostics()
    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local diagnostic_config = {
        virtual_text = false,
        signs = { active = signs },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            border = "rounded",
            focusable = false,
            header = { " Diagnostics", "WildMenu" },
            prefix = "",
            source = "always",
        },
    }
    vim.diagnostic.config(diagnostic_config)
end

local function set_hover_handlers()
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
end

local function set_highlight_document(client)
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec(
        [[
        augroup lsp_document_highlight
            autocmd! * <buffer>
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]], false)
    end
end

local function set_keybinds_and_options(bufnr)
    local function set_keybind(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    local opts = { noremap = true, silent = true }

    set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    set_keybind("n", "<c-]>", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    set_keybind("n", "gd", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    set_keybind("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    set_keybind("i", "<c-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
    set_keybind("n", "<leader>d", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", opts)
    set_keybind("n", "<c-n>", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
    set_keybind("n", "<c-p>", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
    set_keybind("n", "<leader>r", "<cmd>lua require('cmoscofian.lsp.handlers').on_rename()<cr>", opts)

    if __telescope_status then
        set_keybind("n", "ga", "<cmd>Telescope lsp_code_actions theme=cursor<cr>", opts)
        set_keybind("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)
        set_keybind("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
    else
        set_keybind("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
        set_keybind("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
        set_keybind("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    end

    set_keybind("n", "gh", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
end

local capabilities = function()
    local std_capabilities = vim.lsp.protocol.make_client_capabilities()
    local status, cmp = pcall(require, "cmp_nvim_lsp")
    if not status then
        return std_capabilities
    end

    return cmp.update_capabilities(std_capabilities)
end


M.capabilities = capabilities()

M.on_attach = function(client, bufnr)
    set_diagnostics()
    set_highlight_document(client)
    set_hover_handlers()
    set_keybinds_and_options(bufnr)
end

return M
