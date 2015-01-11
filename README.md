This repo is for my personal settings files, which I want to sync & version control.  Suggestions are welcome, but don't expect me to incorporate anything that isn't useful to me.

## Installation

Trying to set up as much as possible with `make`, but we'll see how that goes.

First check out this repo at ~/settings_files.  Relocation not supported at this time.

- vimrc: `make ~/.vimrc`.  just generates a symlink... might not do the right thing on all platforms
- bash: you'll have to add `source ~/settings_files/bash_settings` to your `~/.bashrc` (Ubuntu) or `~/.bash_profile` (Mac / Windows mingw32)
- vim coffescript: `make install_vimcoffee` should do it.  It just creates ~/.vim if it doesn't exist, and then unzips the zip file into it.
- inputrc: `make ~/.inputrc`
