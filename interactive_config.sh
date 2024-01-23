#! /bin/bash

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

