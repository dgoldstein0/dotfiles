#! /bin/bash

# NOTE: this script should be idempotent, so it can be used to update
# settings to the latest and not just to init a new machine.

# OS detection first
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    WINDOWS=1;
else
    WINDOWS=0;
fi

# TODO add a mode that's copying instead of symlinking, which can install to something other than ~.

# Installation.  Symlinks on unix, junction points on windows.
# But junctions only work on folders, so copy the files for windows.
function link() {
    local SOURCE=$2;
    local TARGET=$1;
    if [[ -e $SOURCE ]]; then
        if [[ $SOURCE -ef $TARGET ]]; then
            return;
        else
            echo "$SOURCE already exists, can't link it to $TARGET";
        fi
    else
        if [[ $WINDOWS == 1 ]]; then
            if [[ -d $TARGET ]]; then
                junction.exe -q $SOURCE $TARGET;
            else
                # TODO use symlinks or hardlinks of some kind.
                cp $TARGET $SOURCE;
            fi
        else
            ln -s $TARGET $SOURCE;
        fi
    fi
}

link ~/settings_files/.vim ~/.vim;
link ~/settings_files/vimrc ~/.vimrc;
link ~/settings_files/inputrc ~/.inputrc;
mkdir -p ~/.ipython
link ~/settings_files/ipython_profile ~/.ipython/profile_default
link ~/settings_files/.gitconfig ~/.gitconfig;
link ~/settings_files/gitconfig_global ~/.gitconfig_global;

# create empty ~/.gitconfig_local if it doesn't exist
if [[ ! -e ~/.gitconfig_local ]]; then
    touch ~/.gitconfig_local;
fi

if [[ $(git config --get user.email) = "" ]]; then
    echo "What do you want as the default git email for this machine?"
    read EMAIL;
    if [ $? -ne 0 ]; then
        echo "bailing out, user ctrl+c'ed.";
        exit 1;
    else
        echo "setting email $EMAIL";
        git config -f ~/.gitconfig_local user.email "$EMAIL";
    fi
fi

git submodule init
git submodule update
