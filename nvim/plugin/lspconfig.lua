local status, lspconfig = pcall(require, "lspconfig")
if not status then
    return
end

local status, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if not status then
    return
end

local capabilities = cmp_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
local project_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local on_attach = function(client, bufnr)
    local function set_keybind(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    local opts = { noremap = true, silent = true }
    set_keybind("n", "<c-]>", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    set_keybind("n", "gD", "<cmd>Lspsaga preview_definition<cr>", opts)
    set_keybind("n", "gd", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    set_keybind("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)
    set_keybind("n", "K", "<cmd>Lspsaga hover_doc<cr>", opts)
    set_keybind("n", "ga", "<cmd>Lspsaga code_action<cr>", opts)
    set_keybind("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
    set_keybind("i", "<c-k>", "<cmd>Lspsaga signature_help<cr>", opts)
    set_keybind("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostic<cr>", opts)
    set_keybind("n", "<c-p>", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts)
    set_keybind("n", "<c-n>", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts)
    set_keybind("n", "<leader>r", "<cmd>Lspsaga rename<cr>", opts)
    set_keybind("n", "gh", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
end

lspconfig.clangd.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    single_file_support = true,
}

lspconfig.gopls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = {"gopls", "serve"},
    settings = {
        gopls = {
            analyses = {
                nilness = true,
                shadow = true,
                unusedparams = true,
                unusedwrite = true,
            },
            staticcheck = true,
            usePlaceholders = true,
        }
    },
    single_file_support = true,
}

lspconfig.tsserver.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    single_file_support = true,
    init_options = {
        preferences = {
            includeCompletionsWithSnippetText = true,
            includeCompletionsForImportStatements = true,
        },
    },
}

