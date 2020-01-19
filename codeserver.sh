#!/bin/bash
###################################################################
#Script Name	: codeserver.sh
#Description	: Run the latest version of Visual Studio Code on Google Cloud Shell
#Author       	: Renan Teixeira
#Email         	: contato@renanteixeira.com.br
#Version        : 0.2 - 24/12/2019 - 12:00
###################################################################

echo 'Run Visual Studio Code'

export VERSION=`curl -s https://api.github.com/repos/cdr/code-server/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")'`

export NAME=`curl -s https://api.github.com/repos/cdr/code-server/releases/latest |jq .name -r`

codeRoot="$HOME/codeserver"

downloadCodeServer(){
    cd $codeRoot
    echo "Code Server Version $VERSION not found, downloading...."
    wget -c https://github.com/cdr/code-server/releases/download/$VERSION/code-server$NAME-linux-x86_64.tar.gz -O $VERSION.tar.gz

    echo "Download completed, unzipping file..."
    mkdir $VERSION && tar xvzf $VERSION.tar.gz -C $VERSION --strip-components 1
    
    echo "Unpacking completed..."
    rm -f $VERSION.tar.gz
    
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
    mkdir $codeRoot
    downloadCodeServer
else
    runCodeServer
fi
