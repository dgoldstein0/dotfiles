#! /bin/bash

# NOTE: this script should be idempotent, so it can be used to update
# settings to the latest and not just to init a new machine.

# param parsing: based on http://stackoverflow.com/questions/7069682/how-to-get-arguments-with-flags-in-bash-script

MODE="link"
INSTALL_DIR=$HOME

while test $# -gt 0; do
    case "$1" in
        -h|--help)
            cat << EOF
Script to install / update dotfiles on the current machine.  When run in link mode (default), it only needs to be run to pick up new files / configuration changes; in copy mode, it should be run on every pull.

usage: ./init.sh [options]

options:
--copy: copy the dotfiles to the target directory instead of symlinking them.
--install-dir: the directory to put all the dotfiles into.  Defaults to the homedir.
EOF
            exit 0
            ;;
        --copy)
            MODE="copy"
            shift
            ;;
        --install-dir)
            shift
            if test $# -gt 0; then
                INSTALL_DIR=$1
            else
                echo "no install dir specified"
                exit 1
            fi
            shift
            ;;
        *)
            echo "unrecognized option $1"
            exit 1
    esac
done

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

# Installation.  Symlinks on unix, junction points & hardlinks on windows.
function link() {
    local SOURCE=$2;
    local TARGET=$1;
    if [[ -e $SOURCE ]]; then
        if [[ $SOURCE -ef $TARGET ]]; then
            return;
        else
            echo "$SOURCE already exists, can't link it to $TARGET";
        fi
    elif [[ $MODE == "link" ]]; then
        if [[ $WINDOWS == 1 ]]; then
            if [[ -d $TARGET ]]; then
                echo "creating junction from $SOURCE to $TARGET"
                # TODO use mklink to create junction instead of junction,
                # to kill the extra dependency.
                ./.win-bin/junction.exe -q $SOURCE $TARGET > /dev/null;
            else
                echo "creating hardlink from $SOURCE to $TARGET"
                exec_cmd "mklink /H \"$(posix_to_win $SOURCE)\" \"$(posix_to_win $TARGET)\"" > /dev/null;
            fi
        else
            ln -s $TARGET $SOURCE;
        fi
    else # MODE is copy
        if [[ -d $TARGET ]]; then
            cp -R $TARGET $SOURCE
        else
            cp $TARGET $SOURCE
        fi
    fi
}

# first and foremost: setup shell env
if [[ $WINDOWS == 1 ]]; then
    link ~/settings_files/windows_bash_profile $INSTALL_DIR/.bash_profile
    link ~/settings_files/windows_bash_profile_global $INSTALL_DIR/.bash_profile_global

    # create empty ~/.bash_profile_local if it doesn't exist
    if [[ ! -e $INSTALL_DIR/.bash_profile_local ]]; then
        touch $INSTALL_DIR/.bash_profile_local;
    fi
fi

# fixup .git/config so I can push with my ssh keys, if cloned over https
perl -p -i -e "s~https://github\.com/dgoldstein0/settings_files\.git~git\@github\.com:dgoldstein0/settings_files\.git~" .git/config

# TODO: this is slow - otherwise I'd just do this by default.
#git submodule sync # sync any url changes to the .git/config
git submodule init
git submodule update

link ~/settings_files/.vim $INSTALL_DIR/.vim;
link ~/settings_files/vimrc $INSTALL_DIR/.vimrc;
link ~/settings_files/inputrc $INSTALL_DIR/.inputrc;
mkdir -p $INSTALL_DIR/.ipython
link ~/settings_files/ipython_profile $INSTALL_DIR/.ipython/profile_default
link ~/settings_files/.gitconfig $INSTALL_DIR/.gitconfig;
link ~/settings_files/gitconfig_global $INSTALL_DIR/.gitconfig_global;

# create empty ~/.gitconfig_local if it doesn't exist
if [[ ! -e $INSTALL_DIR/.gitconfig_local ]]; then
    touch $INSTALL_DIR/.gitconfig_local;
fi

if [[ $(git config -f $INSTALL_DIR/.gitconfig_local --get user.email) = "" ]]; then
    echo "What do you want as the default git email for this machine?"
    read EMAIL;
    if [ $? -ne 0 ]; then
        echo "bailing out, user ctrl+c'ed.";
        exit 1;
    else
        echo "setting email $EMAIL";
        git config -f $INSTALL_DIR/.gitconfig_local user.email "$EMAIL";
    fi
fi

which hg >& /dev/null;
if [[ $? == 0 ]]; then
    # hg stuff.  Haven't figured out a way to make hg submodules yet.
    if [[ ! -d ~/settings_files/hg-prompt ]]; then
        hg clone https://bitbucket.org/sjl/hg-prompt ~/settings_files/hg-prompt;
    fi
else
    echo "hg not detected on \$PATH; skipping hg-prompt installation"
fi

if [[ $WINDOWS == 0 ]]; then
    # compile vimproc
    pushd ~/.vim/bundle/vimproc.vim
    if [[ $WINDOWS == 1 ]]; then
        # TODO make vimproc work on windows
        /c/Program\ Files\ \(x86\)/GnuWin32/bin/make.exe -f make_mingw32.mak CC=mingw32-gcc
    else
        make
    fi
    popd
fi
