vim9script

def amber#VimscriptGenerator#generateVimscript(filename: string)
    var lines: list<string> = [ '" Generated by Amber: https://github.com/lunarwatcher/amber']
    add(lines, '" Variables')
    for [variableName, value] in items(g:AmberVariables)
        add(lines, 'let s:' .. variableName .. " = '" .. value .. "'")
    endfor

    add(lines, '" Highlight definitions')
    for [groupName, groupContent] in items(g:AmberHighlights)
        add(lines, 'hi ' .. groupName .. ' ' .. groupContent)
    endfor
    
    writefile(lines, g:AmberOutputDirectory .. '/' .. filename .. ".vim")

enddef