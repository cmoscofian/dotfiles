local treesitter = require("nvim-treesitter.configs")

treesitter.setup {
    highlight = {
        enable = true,
    },
    ensure_installed = {
        "bash",
        "cpp",
        "css",
        "go",
        "html",
        "java",
        "javascript",
        "json",
        "markdown",
        "python",
        "rust",
        "typescript",
        "vim",
    },
}
