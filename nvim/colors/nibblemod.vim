runtime colors/nibble.vim

" Lualine highlights {{{
highlight! link LualineA Menu
highlight LualineB guifg=#c0c0c0 guibg=#0000ff gui=NONE ctermfg=251 ctermbg=21 cterm=NONE
highlight! link LualineC StatusLine
highlight! link LualineX LualineB
highlight! link LualineY LualineA
highlight! link LualineZ LualineA
highlight! link LualineMode WarningMsg
highlight! link LualineInactive StatusLineNC
" }}}

" Black background {{{
" WARN: uncomment the lines below to have black background as a default instead
" of the DOS blue
" highlight! Normal guifg=#ffffff guibg=#000000 ctermfg=255 ctermbg=16 cterm=NONE
" highlight! NormalFloat guifg=#ffffff guibg=#000000 ctermfg=255 ctermbg=16 cterm=NONE
" highlight! NormalNC guifg=#ffffff guibg=#000000 ctermfg=255 ctermbg=16 cterm=NONE
" }}}
