#!/usr/bin/env bash

###########################
# This script installs the dotfiles and runs all other system configuration scripts
# @author Adam Eivy
###########################
DEFAULT_EMAIL="arnaud@arnaudbos.com"
DEFAULT_GITHUBUSER="arnaudbos"

# include my library helpers for colorized echo and require_brew, etc
source ./lib_sh/echos.sh
source ./lib_sh/utils.sh
source ./lib_sh/requirers.sh

bot "Hi! I'm going to install tooling and tweak your system settings. Here I go..."

# ensure ~/.gitshots exists to prevent "Error." in terminal after git commits
# TODO: use node/yoeman to templatize elements of this project and use inquerer to ask if the
# user wants to use gitshots
mkdir -p ~/.gitshots

# Ask for the administrator password upfront
if sudo grep -q "# %wheel\tALL=(ALL) NOPASSWD: ALL" "/etc/sudoers"; then

  # Ask for the administrator password upfront
  bot "I need you to enter your sudo password so I can install some things:"
  sudo -v

  # Keep-alive: update existing sudo time stamp until the script has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

  question "Do you want me to setup this machine to allow you to run sudo without a password?\n
        More infomation here: http://wiki.summercode.com/sudo_without_a_password_in_mac_os_x \n
              [y|N]" response

  if [[ $response =~ (yes|y|Y) ]];then
      sed --version 2>&1 > /dev/null
      sudo sed -i '' 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers
      if [[ $? == 0 ]];then
          sudo sed -i 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers
      fi
      sudo dscl . append /Groups/wheel GroupMembership $(whoami)
      bot "You can now run sudo commands without password!"
  fi
fi

grep 'user = GITHUBUSER' ./homedir/.gitconfig > /dev/null 2>&1
if [[ $? = 0 ]]; then
  question "Is this your github username '$COL_YELLOW$githubuser$COL_RESET'? [Y|n]" response

  if [[ $response =~ ^(no|n|N) ]];then
    question "What is your github username  then? [$DEFAULT_GITHUBUSER] " githubuser
    if [[ ! $githubuser ]];then
      githubuser=$DEFAULT_GITHUBUSER
    fi
  fi

  fullname=`osascript -e "long user name of (system info)"`

  if [[ -n "$fullname" ]];then
    lastname=$(echo $fullname | awk '{print $2}');
    firstname=$(echo $fullname | awk '{print $1}');
  fi

  if [[ -z $lastname ]]; then
    lastname=`dscl . -read /Users/$(whoami) | grep LastName | sed "s/LastName: //"`
  fi
  if [[ -z $firstname ]]; then
    firstname=`dscl . -read /Users/$(whoami) | grep FirstName | sed "s/FirstName: //"`
  fi

  if [[ ! "$firstname" ]];then
    response='n'
  else
    question "Is this your full name '$COL_YELLOW$firstname $lastname$COL_RESET'? [Y|n]" response
  fi

  if [[ $response =~ ^(no|n|N) ]];then
    question "What is your first name? " firstname
    question "What is your last name? " lastname
  fi
  fullname="$firstname $lastname"

  bot "Great $fullname, "

  email=`dscl . -read /Users/$(whoami)  | grep EMailAddress | sed "s/EMailAddress: //"`
  if [[ ! $email ]];then
    response='n'
  else
    question "Is this your email '$COL_YELLOW$email$COL_RESET'? [Y|n]" response
  fi

  if [[ $response =~ ^(no|n|N) ]];then
    question "What is your email? [$DEFAULT_EMAIL] " email
    if [[ ! $email ]];then
      email=$DEFAULT_EMAIL
    fi
  fi

  running "replacing items in .gitconfig with your info ($COL_YELLOW$fullname, $email, $githubuser$COL_RESET)"

  # test if gnu-sed or osx sed

  sed -i "s/GITHUBFULLNAME/$firstname $lastname/" ./homedir/.gitconfig > /dev/null 2>&1 | true
  if [[ ${PIPESTATUS[0]} != 0 ]]; then
    echo
    running "looks like you are using OSX sed rather than gnu-sed, accommodating"
    sed -i '' "s/GITHUBFULLNAME/$firstname $lastname/" ./homedir/.gitconfig;
    sed -i '' 's/GITHUBEMAIL/'$email'/' ./homedir/.gitconfig;
    sed -i '' 's/GITHUBUSER/'$githubuser'/' ./homedir/.gitconfig;
  else
    echo
    bot "looks like you are already using gnu-sed. woot!"
    sed -i 's/GITHUBEMAIL/'$email'/' ./homedir/.gitconfig;
    sed -i 's/GITHUBUSER/'$githubuser'/' ./homedir/.gitconfig;
  fi
fi

MD5_NEWWP=$(md5 img/wallpaper.png | awk '{print $4}')
MD5_OLDWP=$(md5 /System/Library/CoreServices/DefaultDesktop.jpg | awk '{print $4}')
if [[ "$MD5_NEWWP" != "$MD5_OLDWP" ]]; then
  question "Do you want to use the project's custom desktop wallpaper? [Y|n] " response
  if [[ $response =~ ^(no|n|N) ]];then
    echo "skipping...";
    ok
  else
    running "Set a custom wallpaper image"
    # `DefaultDesktop.jpg` is already a symlink, and
    # all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
    rm -rf ~/Library/Application Support/Dock/desktoppicture.db
    sudo rm -f /System/Library/CoreServices/DefaultDesktop.jpg > /dev/null 2>&1
    sudo rm -f /Library/Desktop\ Pictures/El\ Capitan.jpg
    sudo cp ./img/wallpaper.png /System/Library/CoreServices/DefaultDesktop.jpg;
    sudo cp ./img/wallpaper.png /Library/Desktop\ Pictures/El\ Capitan.jpg;ok
  fi
fi

################################################
# homebrew
################################################
source ./brew.sh

################################################
# brew cask
################################################
source ./casks.sh

################################################
# dotfiles
################################################
source ./dotfiles.sh

################################################
# "extra" softare
################################################
source ./extras.sh

################################################
# osx
################################################
source ./osx.sh

################################################
# misc
################################################
bot "installing fonts"
./fonts/install.sh
ok

if [[ -d "/Library/Ruby/Gems/2.0.0" ]]; then
  running "Fixing Ruby Gems Directory Permissions"
  sudo chown -R $(whoami) /Library/Ruby/Gems/2.0.0
  ok
fi

running "Installing & updating Atom packages"; filler
# strip packages file
atom_packages=$(mktemp /tmp/dotfiles.atom_packages.XXXXXXXXXX)
cat homedir/.atom/packages.cson | sed '$ d' | sed '1,1d' | sed 's/\"//g' > $atom_packages
apm install --packages-file $atom_packages

################################################
bot "Cleaning up the mess"
################################################
Remove outdated versions from the cellar
running "Cleaning up homebrew cache"
brew cleanup > /dev/null 2>&1
brew cask cleanup > /dev/null 2>&1
ok

msg "Note that some of these changes require a logout/restart to take effect."; filler
msg "You should also NOT open System Preferences. It might overwrite some of the settings."; filler
running "Killing affected applications (so they can reboot)...."
for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
    "Dock" "Finder" "Mail" "Messages" "SystemUIServer" "iCal" "Transmission" "Atom" \
    "The Unarchiver" "smcFanControl"; do
killall "${app}" > /dev/null 2>&1
done
ok

botdone

{
  ###############################################################################
  bot "Unfortunately I can't setup everything :( Heres a list of things you need to manually do"
  ###############################################################################
  item 1 "Installing from App Store:"
  item 2 "Keynote"
  item 2 "Numbers"
  item 2 "Pages"
  filler
  item 1 "Set Finder settings"
  item 2 "Remove 'All My Files', 'Movies', 'Music' and 'Pictures' from sidebar"
  item 2 "Add folders to sidebar: 'Lab'"
  filler
  item 1 "Set Dropbox configuration:"
  item 2 "Show desktop notifications"
  item 2 "Start dropbox on system startup"
  item 2 "Selective Sync folders"
  item 2 "Do not enable camera uploads"
  item 2 "Share screenshots using Dropbox"
  filler
  item 1 "Extra apps:"
  item 2 "Add to firewall"
} | tee ~/Desktop/osxbot_manual.txt
# force mac version
/usr/bin/sed -i '' -e "s/\[32;01m//g; s/\[39;49;00m//g; s/\[35;01m//g" ~/Desktop/osxbot_manual.txt
filler
msg "Manual instructions saved to '~/Desktop/osxbot_manual.txt'";filler

botdone

################################################
bot "Woot! All done. Kill this terminal and launch iTerm"
################################################
