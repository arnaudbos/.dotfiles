#!/usr/bin/env bash

################################################
bot "Setting up >Homebrew Cask<"
################################################
running "checking brew-cask install"
output=$(brew tap | grep cask)
if [[ $? != 0 ]]; then
  action "installing brew-cask"
  require_brew caskroom/cask/brew-cask
fi
brew tap caskroom/versions > /dev/null 2>&1
ok

###############################################################################
bot "Setting up >iTerm2<"
###############################################################################
require_cask iterm2

if [ $TERM_PROGRAM == 'iTerm.app' ]; then
    warn "You are running this script from inside iTerm. Some settings might not work. Run form Terminal to apply correctly"
fi

cp ./configs/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist

###############################################################################
bot "Setting up >Mozilla Firefox<"
###############################################################################
# checks if mozilla firefox was already installed
firstinstall=`brew cask list | grep "firefox" &> /dev/null ; echo $?`

require_cask firefox

# if first installation, opens
if [ $firstinstall == 1 ]; then
  open "/Applications/Firefox.app"
fi
botdone

###############################################################################
bot "Installing >Cheatsheet<"
###############################################################################
# checks if was already installed
firstinstall=`brew cask list | grep "cheatsheet" &> /dev/null ; echo $?`
require_cask cheatsheet
# if first installation, opens
if [[ $firstinstall == 1 ]]; then
  open "/Applications/CheatSheet.app"
fi

###############################################################################
bot "Installing >Flux<"
###############################################################################
# checks if was already installed
firstinstall=`brew cask list | grep "flux" &> /dev/null ; echo $?`
require_cask flux
# if first installation, opens
if [[ $firstinstall == 1 ]]; then
  open "/Applications/Flux.app"
fi

###############################################################################
bot "Setting up >Transmission<"
###############################################################################
require_cask transmission

running "Use '~/Downloads' to store incomplete downloads"
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Downloads";ok

running "Don’t prompt for confirmation before downloading"
defaults write org.m0k.transmission DownloadAsk -bool false;ok

running "Trash original torrent files"
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true;ok

running "Hide the donate message"
defaults write org.m0k.transmission WarningDonate -bool false;ok

running "Hide the legal disclaimer"
defaults write org.m0k.transmission WarningLegal -bool false;ok

###############################################################################
# bot "Setting up >odrive<"
# bot "Setting up >Grammarly<"
###############################################################################

botdone
