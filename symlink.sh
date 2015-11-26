#! bash

if [[ "$OSTYPE" == "msys" ]]; then
    echo $1 $3;
    junction.exe $3 $1;
else
    ln -s $1 $2;
fi
