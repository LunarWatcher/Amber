# Amber

Theme previewer for Vim.

Note: due to use of Vim 9, at the time of writing, this plugin is incompatible with neovim. A relatively new version of Vim (I have no idea what patch is at least required, but I'm using 8.2.2465) is also required. <sub>Note: Patches adding neovim support by removing Vim 9 will be declined, but patches adding neovim support by tweaking code if Neovim adds support for Vim 9 will be approved.</sub>


Neovim users can use [lush.nvim](https://github.com/rktjmp/lush.nvim) instead.

That being said, advantages to Lush (at least when everything is ready):
 * No need to copy a template with returns and imports - Amber handles parsing inside Vim and consequentially has its own syntax designed to be minimal, but still get the job done.
 * Amber is a previewer and design helper, not a theme engine: _only_ vimscript overhead after the theme is properly converted to a normal, universal vimscript file (that should be compatible with nvim as long as they don't completely change how colorschemes are defined at the core, anyway).
 * Python interpolation for group definitions, meaning you get to take advantage of Python. (Lua might be the faster option, but Python already has a few color-related functions that lua don't, as well as [colour](https://pypi.org/project/colour/). Lua might have equivalents, but I'm not well-versed enough in Lua to find anything relevant in one search)

And the obligatory disadvantages:
 * (Depending on your POV,) Amber isn't a complete theme engine
 * ... and there's consequentially not live updates to i.e. random colors. Lines are processed when an update to the line is detected - not otherwise.
 * ... and such changes don't persist when the theme is exported into a "stable" variant anyway (proper Vim themes are considered the "stable" version of the stuff Amber does)


... [and Python (and other interfaces) are still safe](https://groups.google.com/g/vim_use/c/K_U3ndDXOGA/m/sj5cndNaAgAJ). Probably. We'll cross that bridge when we get there.

