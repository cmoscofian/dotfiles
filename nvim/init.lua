vim.opt.runtimepath:append("$VIMDIR")
vim.opt.packpath:append("$VIMDIR")
vim.cmd("source $VIMDIR/vimrc")

vim.opt.showmode = false
vim.opt.laststatus = 3
vim.cmd("colorscheme nibblemod")

require("cmoscofian.globals")
