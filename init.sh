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

function posix_to_win() {
    # resolve relative paths here, so cmd doesn't choke on ~ on windows
    # NOTE: if source is a junction to target, readlink resolves it to the target.
    local path=$(readlink -f $1)
    echo "$path" | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/'
}

function exec_cmd() {
cmd << EOD
$1
EOD
}

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
                echo "creating junction from $SOURCE to $TARGET"
                # TODO use mklink to create junction instead of junction,
                # to kill the extra dependency.
                junction.exe -q $SOURCE $TARGET > /dev/null;
            else
                echo "creating hardlink from $SOURCE to $TARGET"
                exec_cmd "mklink /H \"$(posix_to_win $SOURCE)\" \"$(posix_to_win $TARGET)\"" > /dev/null;
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
