local status, lspconfig = pcall(require, "lspconfig")
if not status then
    return
end

local status, util = pcall(require, "lspconfig.util")
if not status then
    return
end

local on_attach = function(client, bufnr)
    local function set_keybind(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    local opts = { noremap = true, silent = true }
    set_keybind("n", "<c-]>", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    set_keybind("n", "gD", "<cmd>Lspsaga preview_definition<cr>", opts)
    set_keybind("n", "gd", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    set_keybind("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    set_keybind("n", "K", "<cmd>Lspsaga hover_doc<cr>", opts)
    set_keybind("n", "ga", "<cmd>Lspsaga code_action<cr>", opts)
    set_keybind("n", "gr", "<cmd>Lspsaga lsp_finder<cr>", opts)
    set_keybind("i", "<c-k>", "<cmd>Lspsaga signature_help<cr>", opts)
    set_keybind("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostic<cr>", opts)
    set_keybind("n", "<c-p>", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts)
    set_keybind("n", "<c-n>", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts)
    set_keybind("n", "<leader>r", "<cmd>Lspsaga rename<cr>", opts)
end

lspconfig.clangd.setup {}

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
    },
    single_file_support = true,
}

lspconfig.jdtls.setup {
    on_attach = on_attach,
    cmd = {"jdtls"},
    filetypes = {"java", "groovy", "kotlin"},
    root_dir = vim.loop.cwd,
}

lspconfig.tsserver.setup {
    on_attach = on_attach,
    root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git", "*.js"),
    single_file_support = true,
}

