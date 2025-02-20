vim.opt.runtimepath:append("$VIMDIR")
vim.opt.packpath:append("$VIMDIR")
vim.cmd("source $VIMDIR/vimrc")

vim.opt.laststatus = 3

require("cmoscofian.globals")
