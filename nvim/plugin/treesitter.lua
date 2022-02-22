local treesitter = require("nvim-treesitter.configs")

treesitter.setup {
    highlight = {
        enable = true,
    },
    ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "go",
        "html",
        "java",
        "javascript",
        "json",
        "lua",
        "markdown",
        "typescript",
        "vim",
    },
}
