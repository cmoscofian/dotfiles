vim.opt.runtimepath:append("$DOTDIR/vim")
vim.opt.packpath:append("$DOTDIR/vim")
vim.cmd("source $DOTDIR/vim/vimrc")

vim.opt.showmode = false
vim.opt.laststatus = 3
vim.cmd("colorscheme nibblemod")

require("cmoscofian.globals")
