local jdtls = require("jdtls")
local config = require("cmoscofian.lsp").config

local project_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local on_attach = function(client, bufnr)
    jdtls.setup.add_commands()
    config.on_attach(client, bufnr)

    -- Specific jdtls key bindings
    local opts = { silent = true }
    vim.keymap.set("n", "goi", jdtls.organize_imports, opts)
    vim.keymap.set("n", "gv", jdtls.extract_variable, opts)
    vim.keymap.set("n", "gc", jdtls.extract_constant, opts)
    vim.keymap.set("n", "gm", jdtls.extract_method, opts)
end

local sdkdir = os.getenv("SDKMAN_DIR")
-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local jdtls_config = {
    on_attach = on_attach,
    capabilities = config.capabilities,
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = { "jdtls", project_dir },
    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "build.gradle", "pom.xml" }),
    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-1.8",
                        path = sdkdir ..  "/candidates/java/8.0.302-open/",
                        default = false,
                    },
                    {
                        name = "JavaSE-11",
                        path = sdkdir ..  "/candidates/java/11.0.12-open/",
                        default = false,
                    },
                    {
                        name = "JavaSE-17",
                        path = sdkdir ..  "/candidates/java/17.0.7-tem/",
                        default = true,
                    },
                },
            },
            errors = {
                incompleteClasspath = {
                    severity = "error",
                },
            },
            implementationCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            signatureHelp = {
                enabled = true,
            },
        },
    },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(jdtls_config)
