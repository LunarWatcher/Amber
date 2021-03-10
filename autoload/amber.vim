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

def amber#Compile(statement: string)
    if statement == ""
        # Ignore empty lines
        return
    endif
    # Start parsing. Well, parsing largely being use regex to get shit
    var tryStatement = matchlist(statement, '\v^\s*(.{-})\s*\{(.*)\}\s*$')
    if len(tryStatement) != 0
        # We have a statement
        echom "Statement: " .. statement
    else
        # We check if we have a varible
        var tryVariable = matchlist(statement, '\v^\s*(var\s+[a-zA-Z0-9]+)\s*\V=\v\s*"(.{-})"\s*$')
        if len(tryVariable) != 0
            echom "Variable: " .. statement
        endif
    endif
    # And we ignore everything invalid, because it might be an incomplete statement.
    # Incremental parsing means we can't complain too much
    # Might be worth adding custom highlight groups? 

enddef

def amber#Parse()
    # prevent calls from other buffers
    if bufnr('%') != g:AmberBufferInit
        echom "Bad parse"
        return
    endif
    if !exists('b:AmberCache')
        echom "init"
        b:AmberCache = []
    endif
    echom "in function"

    # We could of course use '.' instead, but this could potentially exclude
    # line changes triggered by things like multiple cursors (in one of many forms),
    # various visual multi-replace stuff (i.e. visual -> c triggers change across
    # several lines), and substitutions.
    var idx: number = 0
    for line in getline(0, '$')
        if idx >= len(b:AmberCache)
            b:AmberCache->add(line)
            amber#Compile(line)
        else
            # Potentially a weak cache. We'll see.
            if line != b:AmberCache[idx]
                b:AmberCache[idx] = line
                amber#Compile(line)
            endif
        endif
        idx += 1
    endfor

enddef

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
        # We use CursorHoldI instead of CursorMovedI to prevent constant updates.
        # Potentially slightly slower updates, but still does the trick.
        # As long as it doesn't require a refresh, it's still about as close as it
        # gets to real-time.
        autocmd CursorHoldI <buffer> call amber#Parse()
        # This is largely to check for normal mode shit.
        autocmd CursorHold  <buffer> call amber#Parse()
    augroup END
enddef
