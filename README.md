This repo is for my personal settings files, which I want to sync & version control.  Suggestions are welcome, but don't expect me to incorporate anything that isn't useful to me.

## Installation

Run after cloning the repo to `~/dotfiles`, run `./install.sh`.  Also run `./interactive_config.sh` for interactive configuration.

TODO: this stuff could be much cleaner.  The goal should be
- one simple command to install everything
- everything is a symlink to the repo, so updating = git pull
- windows v. ubuntu issues are handled by code and not needed to be explicitly documented.

- bash: you'll have to add `source ~/dotfiles/bash_settings.sh` to your `~/.bashrc` (Ubuntu) or `~/.bash_profile` (Mac / Windows mingw32)
- you might want to `source ~/.bash_aliases` in your .bashrc.  The vimrc here will use `~/.bash_aliases` for local aliases
- if you have a broken symlinks from a previous install, `find . -maxdepth 1 -xtype l` can help locate broken symlinks which you can then delete.

## Windows-specific issues

I usually use git-for-windows which comes with a bash shell, and a bunch of basic utilities.  It however is missing some basic utils, which I've added in .win-bin/.

- ssh_agent.sh: needed on Windows because by default, there's no ssh-agent running.  Add `source ~/dotfiles/ssh_agent.sh` to your .bash_profile.  If there's no ~/.bash_profile this is set up automatically.
- ssh access to my github repos is needed.  Which is a bit of a circular dep.  After cloning the repo and setting up ssh_agent.sh as described above, set up .ssh/id_rsa and then run `ssh-add`.
- http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html may come in handy

## Windows Subsystem for Linux issues

Tried this with Ubuntu 16.04; seems to have the same ssh-agent issue as standard windows so `source ~/dotfiles/ssh_agent.ssh` in .bashrc was also needed.

## Vim plugins

I'm using pathogen as my package manager and installing each plugin (including pathogen) as a submodule.

Adding a new plugin like this:

`git submodule add <repo url> .vim/bundle/<plugin name>`

## requirements

I've actually started using vim 8.1 now, though most will work on 7.4+.  Gundo needs python support (but compiling with python & python3 is problematic for unknown reasons) so I'm using http://tipsonubuntu.com/2016/09/13/vim-8-0-released-install-ubuntu-16-04/ which compiles with py3 support.

To get vim-go working, you'll need to set GOPATH in .bashrc (or equivalent); go will search the gopath for modules, but it'll install into the first path, so it makes sense to set it up as `GOPATH=<path to put new things>;<path to existing modules / repo source code>`; and put /usr/local/go/bin on PATH and run through https://golang.org/doc/install#install to get a copy of the latest go toolchain.  After getting that installed and making sure `which go` points to the right go compiler, launch vim and :GoInstallBinaries to complete setup; as long as you have a new-enough go it should install everything correctly.
