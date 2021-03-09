# Amber

Theme previewer for Vim.

Note: due to use of Vim 9, at the time of writing, this plugin is incompatible with neovim. A relatively new version of Vim (I have no idea what patch is at least required, but I'm using 8.2.2465) is also required.


Neovim users can use [lush.nvim](https://github.com/rktjmp/lush.nvim) instead.

That being said, advantages to Lush (at least when everything is ready):
 * No need to copy a template with returns - Amber handles parsing inside Vim and consequentially has its own syntax
 * Amber is a previewer and design helper, not a theme engine: _only_ vimscript overhead after the theme is properly converted to a normal, universal vimscript file (that should be compatible with nvim as long as they don't completely change how colorschemes are defined at the core, anyway).
 * Python interpolation for group definitions, meaning you get to take advantage of Python. (Lua might be the faster option, but Python already has a few color-related functions that lua don't, as well as [colour](https://pypi.org/project/colour/). Lua might have equivalents, but I'm not well-versed enough in Lua to find anything relevant in one search)


... [and Python (and other interfaces) are still safe](https://groups.google.com/g/vim_use/c/K_U3ndDXOGA/m/sj5cndNaAgAJ). Probably. We'll cross that bridge when we get there.

