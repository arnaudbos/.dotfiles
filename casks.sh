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
bot "Setting up >odrive<"
###############################################################################
# checks if odrive was already installed
firstinstall=`brew cask list | grep "odrive" &> /dev/null ; echo $?`

require_cask odrive

# if first installation, opens
if [ $firstinstall == 1 ]; then
  open "/Applications/odrive.app"
fi
botdone

###############################################################################
bot "Setting up >JetBrains Toolbox<"
###############################################################################
# checks if jetbrains-toolbox was already installed
firstinstall=`brew cask list | grep "jetbrains-toolbox" &> /dev/null ; echo $?`

require_cask jetbrains-toolbox

# if first installation, opens
if [ $firstinstall == 1 ]; then
  open "/Applications/jetbrains-toolbox.app"
fi
botdone

###############################################################################
bot "Setting up >Docker<"
###############################################################################
# checks if docker was already installed
firstinstall=`brew cask list | grep "docker" &> /dev/null ; echo $?`

require_cask docker

# if first installation, opens
if [ $firstinstall == 1 ]; then
  open "/Applications/Docker.app"
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

botdone

################################################
bot "Setting up brews"
################################################

bot "Installing >cyberduck<"
require_cask cyberduck

bot "Installing >dash<"
require_cask dash

bot "Installing >emacs<"
require_cask emacs

bot "Installing >evernote<"
require_cask evernote

bot "Installing >geogebra<"
require_cask geogebra

bot "Installing >java<"
require_cask java

bot "Installing >skitch<"
require_cask skitch

bot "Installing >skype<"
require_cask skype

bot "Installing >the-unarchiver<"
require_cask the-unarchiver

bot "Installing >transmission<"
require_cask transmission

bot "Installing >vlc<"
require_cask vlc

bot "Installing >xquartz<"
require_cask xquartz

botdone
