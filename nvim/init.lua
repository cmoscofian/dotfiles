vim.opt.runtimepath:append("$VIMDIR")
vim.opt.packpath:append("$VIMDIR")
vim.cmd("source $VIMDIR/vimrc")

vim.opt.laststatus = 3
vim.opt.winborder = "rounded"

require("cmoscofian.globals")
