local status, lspconfig = pcall(require, "lspconfig")
if not status then
    return
end

local on_attach = function(client, bufnr)
    local function set_keybind(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    local opts = { noremap = true, silent = true }
    set_keybind("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    set_keybind("n", "<c-]>", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    set_keybind("n", "gd", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    set_keybind("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    set_keybind("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    set_keybind("n", "ga", "<cmd>Telescope lsp_code_actions<cr>", opts) 
    set_keybind("n", "gr", "<cmd>Telescope lsp_references<cr>", opts) 
    set_keybind("i", "<c-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
    set_keybind("n", "<c-p>", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", opts)
    set_keybind("n", "<c-n>", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", opts)
    set_keybind("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
end

lspconfig.gopls.setup {
    on_attach = on_attach,
    cmd = {"gopls", "serve"},
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        }
    }
}

lspconfig.tsserver.setup {
    on_attach = on_attach,
}
