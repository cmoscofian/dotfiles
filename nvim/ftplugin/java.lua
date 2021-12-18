local status, jdtls = pcall(require, "jdtls")
if not status then
    return
end

local project_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local on_attach = function(client, bufnr)
    jdtls.setup.add_commands()
    local function set_keybind(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    local opts = { noremap = true, silent = true }
    set_keybind("n", "<c-]>", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    set_keybind("n", "gD", "<cmd>Lspsaga preview_definition<cr>", opts)
    set_keybind("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
    set_keybind("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)
    set_keybind("n", "K", "<cmd>Lspsaga hover_doc<cr>", opts)
    set_keybind("n", "ga", "<cmd>Lspsaga code_action<cr>", opts)
    set_keybind("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
    set_keybind("i", "<c-k>", "<cmd>Lspsaga signature_help<cr>", opts)
    set_keybind("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostic<cr>", opts)
    set_keybind("n", "<c-p>", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts)
    set_keybind("n", "<c-n>", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts)
    set_keybind("n", "<leader>r", "<cmd>Lspsaga rename<cr>", opts)

    -- Specific jdtls key bindings
    set_keybind("n", "goi", "<cmd>lua require('jdtls').organize_imports()<cr>", opts)
    set_keybind("n", "gv", "<cmd>lua require('jdtls').extract_variable()<cr>", opts)
    set_keybind("v", "gv", "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>", opts)
    set_keybind("n", "gc", "<cmd>lua require('jdtls').extract_constant()<cr>", opts)
    set_keybind("v", "gc", "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>", opts)
    set_keybind("n", "gm", "<cmd>lua require('jdtls').extract_constant()<cr>", opts)
    set_keybind("v", "gm", "<esc><cmd>lua require('jdtls').extract_method(true)<cr>", opts)
end
-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
    on_attach = on_attach,
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {"jdtls", project_dir},
    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = jdtls.setup.find_root({".git", "mvnw", "gradlew", "build.gradle", "pom.xml"}),
    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-1.8",
                        path = "/Library/Java/JavaVirtualMachines/jdk1.8.0_311.jdk/Contents/Home",
                        default = true,
                    },
                    {
                        name = "JavaSE-11",
                        path = "/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home/",
                    },
                },
            },
        },
    },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)
