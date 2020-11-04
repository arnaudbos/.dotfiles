#!/usr/bin/env bash

################################################
bot "Setting up >Homebrew<"
################################################

running "checking homebrew install"
brew_bin=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
    action "installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    if [[ $? != 0 ]]; then
      error "unable to install homebrew, script $0 abort!"
      exit 2
    fi
else
    echo -n "already installed "
fi
ok

# Make sure we’re using the latest Homebrew
running "updating homebrew"
brew update
ok

question "Upgrade any existing outdated packages? [y|N] " response
if [[ $response =~ ^(y|yes|Y) ]];then
    # Upgrade any already-installed formulae
    action "upgrade brew packages..."
    brew upgrade
    ok "brews updated..."
else
    ok "skipped brew package upgrades.";
fi

################################################
bot "Setting up brews"
################################################

bot "Installing >ack<"
require_brew ack

bot "Installing >bat<"
require_brew bat

bot "Installing >catimg<"
require_brew catimg

bot "Installing >coreutils<"
require_brew coreutils

bot "Installing >dos2unix<"
require_brew dos2unix

bot "Installing >doitlive<"
require_brew doitlive

bot "Installing >emojify<"
require_brew emojify

bot "Installing >findutils<"
require_brew findutils

bot "Installing >fd<"
require_brew fd

bot "Installing >fortune<"
require_brew fortune

bot "Installing >gifsicle<"
require_brew gifsicle

bot "Installing >gnupg<"
require_brew gnupg

bot "Installing >gzip<"
require_brew gzip

bot "Installing >graphviz<"
require_brew graphviz

bot "Installing >grip<"
require_brew grip

bot "Installing >httpie<"
require_brew httpie

bot "Installing >lolcat<"
require_brew lolcat

bot "Installing >make<"
require_brew make

bot "Installing >openssh<"
require_brew openssh

bot "Installing >rsync<"
require_brew rsync

bot "Installing >unzip<"
require_brew unzip

bot "Installing >imagemagick<"
require_brew imagemagick

bot "Installing >imagesnap<"
require_brew imagesnap

bot "Installing >jq<"
require_brew jq

bot "Installing >yq<"
require_brew yq

bot "Installing >moreutils<"
require_brew moreutils

bot "Installing >nmap<"
require_brew nmap

bot "Installing >openconnect<"
require_brew openconnect

bot "Installing >plantuml<"
require_brew plantuml

bot "Installing >python<"
require_brew python

bot "Installing >clojure<"
require_brew clojure/tools/clojure

bot "Installing >leiningen<"
require_brew leiningen

bot "Installing >tmux<"
require_brew tmux

bot "Installing >thefuck<"
require_brew thefuck

bot "Installing >tldr<"
require_brew tldr

bot "Installing >tree<"
require_brew tree

bot "Installing >vim<"
require_brew vim

bot "Installing >watch<"
require_brew watch

bot "Installing >wget<"
require_brew wget

botdone
