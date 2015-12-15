#! /bin/bash

# NOTE: this script should be idempotent, so it can be used to update
# settings to the latest and not just to init a new machine.

# OS detection first
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    WINDOWS=1;
else
    WINDOWS=0;
fi

# Installation.  Symlinks on unix, junction points on windows.
# But junctions only work on folders, so copy the files for windows.
if [[ $WINDOWS == 1 ]]; then
    junction ~/.vim/ ~/settings_files/.vim/;
    cp ~/settings_files/vimrc ~/.vimrc
    cp ~/settings_files/inputrc ~/.inputrc;
    junction ~/.ipython/profile_default/ ~/settings_files/ipython_profile
    junction ~/.gitconfig ~/settings_files/.gitconfig;
    junction ~/.gitconfig_global ~/settings_files/gitconfig_global;
else
    # -n = don't follow symlinks.  This is needed to make this idempotent.
    # Otherwise when the ~/.vim -> ~/settings_files/.vim symlink exists,
    # ln decides to make a symlink from ~/.vim/.vim to ~/settings_files/.vim
    # for some reason that's completely beyond me.  symlinks to files don't
    # seem to have this problem.
    ln -n -s ~/settings_files/.vim ~/.vim;
    ln -s ~/settings_files/vimrc ~/.vimrc;
    ln -s ~/settings_files/inputrc ~/.inputrc;
    ln -n -s ~/settings_files/ipython_profile ~/.ipython/profile_default
    ln -s ~/settings_files/.gitconfig ~/.gitconfig;
    ln -s ~/settings_files/gitconfig_global ~/.gitconfig_global;
fi

git submodule init
git submodule update
