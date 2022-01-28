local treesitter = require("nvim-treesitter.configs")

treesitter.setup {
    highlight = {
        enable = true,
    },
    ensure_installed = {
        "c",
        "bash",
        "go",
        "java",
        "javascript",
        "json",
        "lua",
        "toml",
    },
}
