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
s:define("g:AmberOutputDirectory", $HOME .. "/.amber-vim/")
if !isdirectory(g:AmberOutputDirectory)
    mkdir(g:AmberOutputDirectory, 'p')
endif
s:define("g:AmberClearHighlights", 1)
g:AmberDirty = 0

# These keep track of highlights and variables.
# Purely for generating the resulting files.
g:AmberHighlights = {}
g:AmberVariables = {}

def amber#Compile(statement: string)
    if statement == ""
        # Ignore empty lines
        return
    endif
    # Start parsing. Well, parsing largely being use regex to get shit
    var tryStatement = matchlist(statement, '\v^\s*(.{-})\s*\{(.*)\}\s*$')
    if len(tryStatement) != 0
        # We have a statement
        var name: string = tryStatement[1]
        var groupContent: string = tryStatement[2]
        g:AmberHighlights[name] = groupContent
       
        for [variable, value] in items(g:AmberVariables)
            # Substitute in the variable
            groupContent = substitute(groupContent, '%' .. variable, value, 'g')
        endfor
        # Replace double quotes with single quotes
        groupContent = substitute(groupContent, '"', "'", '') 
        if groupContent =~ "\s\*link="
            exec 'silent! hi ' .. substitute(groupContent, '=', ' ', '')
        else
            exec "silent! hi " .. name .. " " .. groupContent
        endif
    else
        # We check if we have a varible
        var tryVariable = matchlist(statement, '\v^\s*var\s+([a-zA-Z0-9]+)\s*\V=\v\s*"(.{-})"\s*$')
        if len(tryVariable) != 0
            var variableName = tryVariable[1]
            var variableContent = tryVariable[2]
            g:AmberVariables[variableName] = variableContent
        endif
    endif
    # And we ignore everything invalid, because it might be an incomplete statement.
    # Incremental parsing means we can't complain too much
    # Might be worth adding custom highlight groups?

enddef

def amber#Parse()
    if !g:AmberDirty
        return
    endif
    g:AmberDirty = 0
    # prevent calls from other buffers
    if bufnr('%') != g:AmberBufferInit
        echom "Bad call to parse"
        return
    endif
    amber#ResetHighlights()
    g:AmberVariables = {}
    g:AmberHighlights = {}

    # We could of course use '.' instead, but this could potentially exclude
    # line changes triggered by things like multiple cursors (in one of many forms),
    # various visual multi-replace stuff (i.e. visual -> c triggers change across
    # several lines), and substitutions.
    for line in getline(0, '$')
        # Caching might be reasonable here, but fuck that.
        amber#Compile(line)
    endfor

enddef

def amber#ResetHighlights()
    # We clear highlights here
    hi clear

    silent! hi link AmberHighlightDefinition Statement
    silent! hi link AmberVariable Statement
    silent! hi link AmberVariableName Constant
    silent! hi link AmberVariableContent String
    silent! hi link AmberHighlightFeature Identifier
    silent! hi link AmberHighlightFeaturePlainText String
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
        autocmd TextChanged,TextChangedI <buffer> g:AmberDirty = 1
    augroup END

    # Let's add a few highlights:
    syn match AmberHighlightDefinition '\v(^.{-}(\s*|$)(\{.*\})?$)' contains=AmberHighlightFeature
    # i.e. guifg=...
    syn match AmberHighlightFeature '\v[a-zA-Z]+\=(["'].{-}["']|.{-}\s)' contained contains=AmberHighlightFeaturePlainText,AmberHighlightFeaturePythonInterpolation
    syn match AmberHighlightFeaturePlainText '\v\=\zs['"]?.{-}(['"]|\s)' contained

    syn match AmberVariable '\v^\s*var.*' contains=AmberVariableName,AmberVariableContent
    syn match AmberVariableName '\v\zs[a-zA-Z0-9]+\ze *\=' contained
    syn match AmberVariableContent '\v\=\zs.*' contained
    amber#ResetHighlights()

enddef

# Utilities

def amber#AmberSynstack()
    # These don't work. Possibly a vim9 bug
    #echo synstack(line('.'), col('.'))
    #echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, ''name'')')
    #echom 'The highlight groups under the cursor are: ' .. stack
    var ids: list<number> = synstack(line('.'), col('.'))
    var mapped: list<string> = []
    for id in ids
        add(mapped, synIDattr(id, 'name'))
    endfor
    echom 'The highlight groups under the cursor are: ' .. join(mapped, ', ')
enddef

def amber#InsertGroups()
    if !exists("g:AmberBufferInit") || g:AmberBufferInit == 0
        echom "That's only useful if you :AmberInit first :)"
        return
    endif
    var ids: list<number> = synstack(line('.'), col('.'))
    var mapped: list<string> = []
    for id in ids
        add(mapped, synIDattr(id, 'name'))
    endfor
    
    win_gotoid(get(win_findbuf(g:AmberBufferInit), 0))
    mapped = map(mapped, 'v:val .. " {  }"')
    append(line('$'), mapped)
enddef


def amber#Load(fn: string = "")
    if !exists("g:AmberBufferInit") || g:AmberBufferInit == 0
        call amber#Initialize()
    endif
    win_gotoid(get(win_findbuf(g:AmberBufferInit), 0))
    var fileName = fn == "" ? input("Filename (note: has to be relative to g:AmberOutputDirectory; load the .amber file): ") : fn
    if fileName !~? '\v\.amber$'
        echom "Can only load .amber files; not " .. fileName
        return
    endif
    var content = readfile(g:AmberOutputDirectory .. "/" .. fileName)
    
    setline(1, content)
    g:AmberDirty = 1
    amber#Parse()
enddef

def amber#Save(fn: string = "")
    if !exists("g:AmberBufferInit") || g:AmberBufferInit == 0
        echom "That's only useful if you :AmberInit first :)"
        return
    endif
    win_gotoid(get(win_findbuf(g:AmberBufferInit), 0))
    var fileName = fn == "" ? input("Theme name: ") : fn

    var content = getline(0, '$')
    writefile(content, g:AmberOutputDirectory .. "/" .. fileName .. ".amber")
    amber#VimscriptGenerator#generateVimscript(fileName)
enddef
