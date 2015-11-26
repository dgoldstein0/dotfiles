This repo is for my personal settings files, which I want to sync & version control.  Suggestions are welcome, but don't expect me to incorporate anything that isn't useful to me.

## Installation

TODO: this stuff could be much cleaner.  The goal should be
- one simple command to install everything
- everything is a symlink to the repo, so updating = git pull
- windows v. ubuntu issues are handled by code and not needed to be explicitly documented.

Trying to set up as much as possible with `make`, but we'll see how that goes.

First check out this repo at ~/settings_files.  Relocation not supported at this time.

- vimrc: on Linux, `make ~/.vimrc`.  just generates a symlink.  On windows, you want ~/_vimrc to point to vimrc - either copy it their, or make a junction.
- bash: you'll have to add `source ~/settings_files/bash_settings` to your `~/.bashrc` (Ubuntu) or `~/.bash_profile` (Mac / Windows mingw32)
- you might want to `source ~/.bash_alias` in your .bashrc.  The vimrc here will use ~/.bash_alias for local aliases
- vim coffescript: `make install_vimcoffee` should do it.  It just creates ~/.vim if it doesn't exist, and then unzips the zip file into it.
- inputrc: `make ~/.inputrc`

## Windows-specific issues

I usually use msysgit which comes with a bash shell, and a bunch of basic utilities.  It however does not include `make` by default. See http://stackoverflow.com/questions/3219926/using-make-with-msysgit for a fix.

- ssh_agent.sh: needed on Windows because by default, there's no ssh-agent running.  Add `source ~/settings_files/ssh_agent.sh` to your .bash_profile

Other errata:
- the vimrc is expected at ~/_vimrc instead of ~/.vimrc
- the vim files directory is ~/vimfiles instead of ~/.vim

## Vim plugins

I'm using pathogen as my package manager and installing each plugin (including pathogen) as a submodule.

Adding a new plugin like this:

`git submodule add <repo url> .vim/bundle/<plugin name>`
