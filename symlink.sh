#! bash

# usage: ./symlink.sh <dest> <linux src> <windows src>

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    junction.exe $3 $1;
else
    ln -s $1 $2;
fi
