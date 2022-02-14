vim.opt.runtimepath:append("~/.vim")
vim.opt.packpath:append("~/.vim")
vim.opt.showmode=false
vim.cmd("source ~/.vim/vimrc")
vim.cmd("colorscheme nibblemod")

require("cmoscofian.globals")
