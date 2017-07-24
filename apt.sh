#!/usr/bin/env bash

################################################
bot "Setting up >apt-get<"
################################################

question "Update packages and Upgrade any existing outdated packages? [y|N] " response
if [[ $response =~ ^(y|yes|Y) ]];then

    bot "Installing PPAs"
    # Java
    sudo add-apt-repository ppa:webupd8team/java
    # Atom
    sudo add-apt-repository ppa:webupd8team/atom
    # Google Chrome
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

    # Make sure we’re using the latest package
    running "updating packages"
    sudo apt-get update
    ok

    # Upgrade any already-installed formulae
    action "upgrade apt packages..."
    sudo apt-get upgrade
    ok "apts updated..."
else
    ok "skipped apt package upgrades.";
fi
