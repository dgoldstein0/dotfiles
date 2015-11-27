#! bash

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
else
    ln -s ~/settings_files/.vim/ ~/.vim/;
    ln -s ~/settings_files/vimrc ~/.vimrc;
    ln -s ~/settings_files/inputrc ~/.inputrc;
fi

git submodule init
git submodule update
