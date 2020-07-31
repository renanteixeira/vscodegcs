#!/bin/bash
set -eu

###################################################################
#Script Name	: codeserver.sh
#Description	: Run the latest version of Code Server (Visual Studio Code) in the browser.
#Author       	: Renan Teixeira
#Email         	: contato@renanteixeira.com.br
#Version        : 0.5 - 03/07/2020 - 21:50
###################################################################

#Global variables
GREEN="\e[92m"
RED="\e[31m"
END="\e[0m"
BLUE="\e[34m"
YELLOW="\e[33m"

echo_latest_version() {
  version="$(curl -fsSLI -o /dev/null -w "%{url_effective}" https://github.com/cdr/code-server/releases/latest)"
  version="${version#https://github.com/cdr/code-server/releases/tag/}"
  version="${version#v}"
  echo "$version"
}

VERSION="${VERSION-$(echo_latest_version)}"

CODE_PATH="$HOME/.config/code-server"
CONFIG_FILE=$CODE_PATH/config.yaml
CODE_FILE=$CODE_PATH/$VERSION/bin/code-server

main() {
	OS="$(os)"
	if [ ! "$OS" ]; then
		echoerr "Unsupported OS $(uname)."
		exit 1
	fi

	distro_name

	ARCH="$(arch)"

	if [ ! -d "$CODE_PATH" ]; then
		mkdir $CODE_PATH
		if [ ! -f $CODE_FILE ]; then
			downloadCodeServer
		else
			runCodeServer
		fi
	else
		clear
		runCodeServer
	fi
}

os() {
  case "$(uname)" in
  Linux)
    echo linux
    ;;
  Darwin)
    echo macos
    ;;
  FreeBSD)
    echo freebsd
    ;;
  esac
}

distro() {
  if [ "$OS" = "macos" ] || [ "$OS" = "freebsd" ]; then
    echo "$OS"
    return
  fi

  if [ -f /etc/os-release ]; then
    (
      . /etc/os-release
      case "$ID" in opensuse-*)
        # opensuse's ID's look like opensuse-leap and opensuse-tumbleweed.
        echo "opensuse"
        return
        ;;
      esac

      echo "$ID"
    )
    return
  fi
}

# os_name prints a pretty human readable name for the OS/Distro.
distro_name() {
  if [ "$(uname)" = "Darwin" ]; then
    echo "macOS v$(sw_vers -productVersion)"
    return
  fi

  if [ -f /etc/os-release ]; then
    (
      . /etc/os-release
      echo "$PRETTY_NAME"
    )
    return
  fi

  # Prints something like: Linux 4.19.0-9-amd64
  uname -sr
}

arch() {
  case "$(uname -m)" in
  aarch64)
    echo arm64
    ;;
  x86_64)
    echo amd64
    ;;
  amd64) # FreeBSD.
    echo amd64
    ;;
  esac
}

downloadCodeServer(){
	echoh "Downloading standalone release archive v$VERSION from GitHub releases."
	echoh

	cd $CODE_PATH
	fetch "https://github.com/cdr/code-server/releases/download/v$VERSION/code-server-$VERSION-$OS-$ARCH.tar.gz" \
    "$VERSION.tar.gz"

    untarCodeServer
}

untarCodeServer(){
	cd $CODE_PATH
	mkdir $VERSION && tar xzf $VERSION.tar.gz -C $VERSION --strip-components 1
    
    echo "Unpacking completed..."
    rm -f $VERSION.tar.gz

    configFile
}

runCodeServer(){
    if [ -f $CODE_FILE ]; then
    	printf "${GREEN}"
        printf "Code Server Version ${BLUE}$VERSION${END} ${GREEN}exists\n"
        echo "Running..."
        echo
        printf "${END}"
    
        configFile
    else
        downloadCodeServer
    fi
}

aboutConfigFile(){
cath << EOF
	The configuration file contains the variables that facilitate the parameterization of the Code Server according to its environment.

	This file is located at $CONFIG_FILE if you need to modify it manually.

EOF
}

randomString() {
    # Return random alpha-numeric string of given LENGTH
    #
    # Usage: VALUE=$(randomString $LENGTH)
    #    or: VALUE=$(randomString)

    local DEFAULT_LENGTH=64
    local LENGTH=${1:-$DEFAULT_LENGTH}

    tr -dc A-Za-z0-9 </dev/urandom | head -c $LENGTH
    # -dc: delete complementary set == delete all except given set
}

configFile(){
	aboutConfigFile

	if [ ! -f $CONFIG_FILE ]; then
		printf "${RED}"
		echo "Configuration file does not exist, let's create!"
		printf "${END}"

		newConfigFile
	elif [ ! -s $CONFIG_FILE ]; then
		printf "${RED}"
		echo "Configuration file is empty!"
		printf "${END}"

		newConfigFile
	else
		printf "${YELLOW}"
		echo "Use existing settings or create new ones?"
		printf "${END}\n"
		
		printf "${BLUE}"
		cat $CONFIG_FILE
		printf "${END}"

		echo
	    echo "[1] Keep current"
	    echo "[2] Create again"
	    echo
	    echo -n "Chose an option: "
	    read optionConfig
	    case $optionConfig in
	        1) execCodeServer;;
	        2) newConfigFile;;
	        *) execCodeServer ;;
	    esac
	fi
}

newConfigFile(){
	rm -Rf $CONFIG_FILE
	touch $CONFIG_FILE

	DEFAULT_HOST=127.0.0.1:8080

	#bind-addr
	clear
	aboutConfigFile

	printf "${GREEN}"
	echo "VS Code Access Address!"
	printf "${END}"
	echo
	echo "[1] Use default host address - http://"$DEFAULT_HOST
	echo "[2] Define custom host"
	echo
	echo -n "Chose an option: "
	read optionHost
	case $optionHost in
		1) echo "bind-addr: "$DEFAULT_HOST >> $CONFIG_FILE;;
		2) echo "Enter the host and port in the format: domain.com:8181" && read bindAddr && echo "bind-addr:" $bindAddr >> $CONFIG_FILE;;
		*) newConfigFile ;;
	esac

	#auth
	echo
	printf "${GREEN}"
	echo "Authentication mode!"
	printf "${END}"
	echo
	echo "[1] Generate random password"
	echo "[2] Define custom password"
	echo "[3] No password"
	echo
	echo -n "Chose an option: "
	read optionAuth

	NEWPWD=$(randomString 15)
	case $optionAuth in
		1) echo "auth: password" >> $CONFIG_FILE && echo "password:" $NEWPWD >> $CONFIG_FILE;;
		2) echo "Enter the custom password:" && customPasswd;;
		3) echo "auth: none" >> $CONFIG_FILE;;
		*) newConfigFile ;;
	esac

	execCodeServer
}

customPasswd(){
	read -s authPass
	if [ -z "${authPass}" ];then
		echo "Password is required!"
		customPasswd
	else
		echo "auth: password" >> $CONFIG_FILE
		echo "password:" $authPass >> $CONFIG_FILE
	fi
}

execCodeServer(){
	clear

	printf "\n${GREEN}"
	if grep -q "password:" $CONFIG_FILE; then
		cat $CONFIG_FILE | grep password:
	else
		echo "No password"
	fi
	printf "${END}\n"
	$CODE_FILE
}

fetch() {
  URL="$1"
  FILE="$2"

  if [ -e "$FILE" ]; then
    echoh "+ Reusing $FILE"
    return
  fi

  sh_c curl \
    -#fL \
    -o "$FILE.incomplete" \
    -C - \
    "$URL"
  sh_c mv "$FILE.incomplete" "$FILE"
}


sh_c() {
  echoh "+ $*"
  if [ ! "${DRY_RUN-}" ]; then
    sh -c "$*"
  fi
}

echoh() {
  echo "$@" | humanpath
}

cath() {
  humanpath
}

echoerr() {
  echoh "$@" >&2
}

# humanpath replaces all occurances of " $HOME" with " ~"
# and all occurances of '"$HOME' with the literal '"$HOME'.
humanpath() {
  sed "s# $HOME# ~#g; s#\"$HOME#\"\$HOME#g"
}

main "$@"