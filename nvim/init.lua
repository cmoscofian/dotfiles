vim.opt.runtimepath:append("~/.vim")
vim.opt.packpath:append("~/.vim")
vim.cmd("source ~/.vim/vimrc")

vim.opt.showmode=false
vim.opt.laststatus=3
vim.cmd("colorscheme nibblemod")

require("cmoscofian.globals")
