#!/bin/bash
###################################################################
#Script Name	: codeserver.sh
#Description	: Run the latest version of Visual Studio Code on Google Cloud Shell
#Author       	: Renan Teixeira
#Email         	: contato@renanteixeira.com.br
#Version        : 0.4 - 19/01/2020 - 12:40
###################################################################

echo 'Run Visual Studio Code'

if dpkg-query -s jq 1>/dev/null 2>&1; then
    echo
else
    echo "Package JQ not found!"
    echo
    echo "[1] Install JQ package and run script"
    echo "[2] Exit script"
    echo
    echo -n "Chose an option "
    read option
    case $option in
        1) sudo apt-get install jq -y ;;
        2) exit ;;
        *) exit ;;
    esac
fi

export VERSION=`curl -s https://api.github.com/repos/cdr/code-server/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")'`

export NAME=`curl -s https://api.github.com/repos/cdr/code-server/releases/latest |jq .name -r`

codeRoot="$HOME/codeserver"

downloadCodeServer(){
    cd $codeRoot
    echo "Code Server Version $VERSION not found, downloading...."
    wget -c https://github.com/cdr/code-server/releases/download/$VERSION/code-server-$NAME-linux-x86_64.tar.gz -O $VERSION.tar.gz

    echo "Download completed, unzipping file..."
    mkdir $VERSION && tar xvzf $VERSION.tar.gz -C $VERSION --strip-components 1
    
    echo "Unpacking completed..."
    rm -f $VERSION.tar.gz
    
    clear
    cd $codeRoot/$VERSION
    ./code-server --port 8080
}

runCodeServer(){
    if [ -d "$codeRoot/$VERSION" ]; then
        echo "Code Server Version $VERSION exists"
        echo "Running..."
    
        cd $codeRoot/$VERSION
        ./code-server --port 8080
    else
        downloadCodeServer
    fi
}

if [ ! -d "$codeRoot" ]; then
    clear
    mkdir $codeRoot
    downloadCodeServer
else
    clear
    runCodeServer
fi
