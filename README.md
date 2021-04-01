# Amber

Theme previewer for Vim.

Note: due to use of Vim 9, at the time of writing, this plugin is incompatible with neovim. A relatively new version of Vim (I have no idea what patch is at least required, but I'm using 8.2.2465) is also required. <sub>Note: Patches adding neovim support by removing Vim 9 will be declined, but patches adding neovim support by tweaking code if Neovim adds support for Vim 9 will be approved.</sub>


Neovim users can use [lush.nvim](https://github.com/rktjmp/lush.nvim) instead.

That being said, advantages to Lush (at least when everything is ready):
 * No need to copy a template with returns and imports - Amber handles parsing inside Vim and consequentially has its own syntax designed to be minimal, but still get the job done.
 * Amber is a previewer and design helper, not a theme engine: _only_ vimscript overhead after the theme is properly converted to a normal, universal vimscript file (that should be compatible with nvim as long as they don't completely change how colorschemes are defined at the core, anyway).

And the obligatory disadvantages:
 * (Depending on your POV,) Amber isn't a complete theme engine
 * ... and there's consequentially not live updates to i.e. random colors. Lines are processed when an update to the line is detected - not otherwise.
 * ... and such changes don't persist when the theme is exported into a "stable" variant anyway (proper Vim themes are considered the "stable" version of the stuff Amber does)

## TODO:

* [x] Preview
* [x] Save (need to do hybrid; .vim and a normal file containing the raw data, largely to facilitate theme updating)
* [x] Load (we load the second file mentioned in the save point)
* [x] Support for things like airline, where highlight groups aren't directly used. (update: ish; there's support for raw Vimscript, but airline specifically might have to be designed completely separately)

## Stuff for the future:
* [ ] Sensible caching

