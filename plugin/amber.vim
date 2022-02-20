" Amber.vim
" License: MIT
" Author: https://github.com/LunarWatcher

import autoload "amber.vim"

command! AmberInit call amber.Initialize()
command! AmberSynstack call amber.AmberSynstack()
command! AmberInsertGroups call amber.InsertGroups()

command! -nargs=? AmberSave call amber.Save(<f-args>)
command! -nargs=? AmberLoad call amber.Load(<f-args>)

command! -nargs=0 AmberOutputHere call amber.SetOutput("")
command! -nargs=1 AmberOutput call amber.SetOutput(<f-args>)

" Output <M-a>h ere
nnoremap <M-a>h :AmberOutputHere<cr>
" <M-a>o utput
nnoremap <M-a>o :AmberOutput<cr>
" <M-a>d esign
nnoremap <M-a>s :AmberSave<cr>
" <M-a>l oad
nnoremap <M-a>l :AmberLoad<cr>
" <M-a>d esign
nnoremap <M-a>d :AmberInit<cr>
" <M-a>i nsert groups
nnoremap <M-a>i :AmberInsertGroups<cr>

