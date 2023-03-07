#!/bin/bash
echo "------ install currrent user linux started ----------------------------"

start_dir=$(pwd)

cd ~/.local/share/vlc/lua/

echo "------------------changed working directory to ------------------------"
pwd

dir="gfx"

if [[ ! -e $dir ]]; then
    mkdir $dir
elif [[ ! -d $dir ]]; then
    echo "$dir already exists but is not a directory" 1>&2
fi

dir="sd"

if [[ ! -e $dir ]]; then
    mkdir $dir
elif [[ ! -d $dir ]]; then
    echo "$dir already exists but is not a directory" 1>&2
fi

dir="playlist"

if [[ ! -e $dir ]]; then
    mkdir $dir
elif [[ ! -d $dir ]]; then
    echo "$dir already exists but is not a directory" 1>&2
fi

echo "------- copying files ---------------------------------------------------"
echo "--------- home dir is: $HOME"

cd $start_dir
echo "--------- changed working directory to ----------------------------------"
pwd


cp -r ./gfx $HOME/.local/share/vlc/lua/; echo "...copied gfx files to .local/share/vlc/lua/..."
tree $HOME/.local/share/vlc/lua/gfx

cp -r ./playlist $HOME/.local/share/vlc/lua/; echo "...copied playlist files to .local/share/vlc/lua/..."
tree $HOME/.local/share/vlc/lua/playlist

cp -r ./sd $HOME/.local/share/vlc/lua/; echo "...copied sd files to .local/share/vlc/lua/..."
tree $HOME/.local/share/vlc/lua/sd

echo "------- install script completed -----------------------------------------"


