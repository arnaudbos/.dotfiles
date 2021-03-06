#!/usr/bin/env bash

# source ./utils.sh

function question() {
    echo -en "\n$COL_MAGENTA ¿$COL_RESET" $1 " "
    local ret
    read ret
    eval "$2=\$ret"
}

function download() {
    running "downloading $1";filler
    http="${2:0:4}"
    if [[ $http = "http" ]]; then
        wget "$2" -O "$1"
    else
        # gdrive trick
        filename="$(curl -sc /tmp/gcokie "https://drive.google.com/uc?export=download&id=$2" | grep -o '="uc-name.*</span>' | sed 's/.*">//;s/<.a> .*//')"
        getcode="$(awk '/_warning_/ {print $NF}' /tmp/gcokie)"
        curl -Lb /tmp/gcokie "https://drive.google.com/uc?export=download&confirm=${getcode}&id=$2" -o "$1"
    fi
    if [[ $? != 0 ]]; then
        error "failed to download $1!"
    fi
    ok
}

function download_app() {
    appname=$1
    link=$2
    local response
    softpath=`stat "/Applications/$appname.app" > /dev/null 2>&1`
    if [ $? = 1 ]; then
      question "$appname is not installed. Do you want to download? [Y|n]" response
      if [[ -z "$response" ]]; then response='Y'; fi
    else
      question "$appname is already installed. Do you want to download again? [y|N]" response
      if [[ -z "$response" ]]; then response='N'; fi
    fi

    if [[ $response =~ ^(yes|y|Y) ]]; then
      running "Downloading $appname to ~/Downloads"; filler
      pushd ~/Downloads > /dev/null 2>&1
      download "$appname.dmg" "$link"
      popd > /dev/null 2>&1
    fi
}

function download_mac_app() {
    appname=$1
    local response
    installed=`mas list | grep -i "$1" | wc -l | sed -e 's/^[ \t]*//'`
    if [ $installed -ge 1 ]; then
      msg "$appname is already installed. Nothing to do."
      return
    else
      question "$appname is not installed. Do you want to install? [Y|n]" response
      if [[ -z "$response" ]]; then response='Y'; fi
    fi

    if [[ $response =~ ^(yes|y|Y) ]]; then
      running "Searching apps with name $appname into Mac App Store"; filler
      mas search "$appname"
    else
      return
    fi

    unset response

    question "Please entre the app ID for $appname that you wish to install" id
    if [[ -z "$id" ]]; then
      return
    else
      mas purchase $id
      mas install $id
    fi
}

function symlinkifne {
    echo -en " $1"

    if [[ -e $1 ]]; then
        # file exists
        if [[ -L $1 ]]; then
            # it's already a simlink (could have come from this project)
            echo -en ' simlink exists, skipping ';ok
            return
        fi
        # backup file does not exist yet
        if [[ ! -e ~/.dotfiles_backup/$1 ]];then
            mv $1 ~/.dotfiles_backup/
            echo -en ' backed up saved;';
        fi
    fi
    # create the link
    ln -s ~/.dotfiles/$1 $1
    echo -en ' linked ';ok
}

