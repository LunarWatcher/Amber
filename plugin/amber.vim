" Amber.vim
" License: MIT
" Author: https://github.com/LunarWatcher

command! AmberInit call amber#Initialize()
command! AmberSynstack call amber#AmberSynstack()
command! AmberInsertGroups call amber#InsertGroups()

command! -nargs=? AmberSave call amber#Save(<f-args>)
command! -nargs=? AmberLoad call amber#Load(<f-args>)

