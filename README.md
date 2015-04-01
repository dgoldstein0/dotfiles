This repo is for my personal settings files, which I want to sync & version control.  Suggestions are welcome, but don't expect me to incorporate anything that isn't useful to me.

## Installation

Trying to set up as much as possible with `make`, but we'll see how that goes.

First check out this repo at ~/settings_files.  Relocation not supported at this time.

- vimrc: on Linux, `make ~/.vimrc`.  just generates a symlink.  On windows, you want ~/_vimrc to point to vimrc - either copy it their, or make a junction.
- bash: you'll have to add `source ~/settings_files/bash_settings` to your `~/.bashrc` (Ubuntu) or `~/.bash_profile` (Mac / Windows mingw32)
- you might want to `source ~/.bash_alias` in your .bashrc.  The vimrc here will use ~/.bash_alias for local aliases
- vim coffescript: `make install_vimcoffee` should do it.  It just creates ~/.vim if it doesn't exist, and then unzips the zip file into it.
- inputrc: `make ~/.inputrc`

## Windows-specific issues

I usually use msysgit which comes with a bash shell, and a bunch of basic utilities.  It however does not include `make` by default. See http://stackoverflow.com/questions/3219926/using-make-with-msysgit for a fix.

Other errata:
- the vimrc is expected at ~/_vimrc instead of ~/.vimrc
- echo (from msysgit) doesn't automatically translate escapes \n, \t, etc. to the proper characters - the "-e" option seems to be needed.  I think -e might be the default on linux.
