local telescope = require("telescope")
local lazygit = require("lazygit")

local opts = { silent = true }
vim.keymap.set("n", "gl", lazygit.lazygit, opts)

telescope.load_extension("lazygit")
