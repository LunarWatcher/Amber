vim9script
# Amber.vim
# License: MIT
# Author: https://github.com/LunarWatcher


def s:define(name: string, default: any)
    if !exists(name)
        execute "" .. name .. " = " .. (type(default) == v:t_string ? '"' .. default .. '"' :  default)
    endif
enddef

s:define("g:AmberShowContrast", 1)
s:define("g:AmberOutputDirectory", "~/.amber-vim/")


def amber#Initialize()
    # We don't wanna initialize several times
    if exists("g:AmberBufferInit")
        if g:AmberBufferInit >= 0
            win_gotoid(get(win_findbuf(g:AmberBufferInit), 0))
        endif
        return
    endif
    split 
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    file Amber code

    g:AmberBufferInit = bufnr('%')

    augroup AmberListener
        au!
        autocmd CursorMovedI <buffer> call amber#Parse()
    augroup END
enddef

def amber#Parse()
    # prevent calls from other buffers
    if bufnr('%') != g:AmberBufferInit
        return
    endif


enddef

