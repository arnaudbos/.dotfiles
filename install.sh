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

if [[ $OSTYPE == darwin* ]]; then
  MD5_NEWWP=$(md5 img/laputa_huge.jpg | awk '{print $4}')
  MD5_OLDWP=$(md5 /System/Library/CoreServices/DefaultBackground.jpg | awk '{print $4}')
else
  MD5_NEWWP=$(md5sum ./img/laputa_huge.jpg | awk '{print $4}')
  MD5_OLDWP=$(md5sum $(gsettings get org.gnome.desktop.background picture-uri | sed 's/^.\{8\}\(.*\).\{1\}$/\1/'))
fi
if [[ "$MD5_NEWWP" != "$MD5_OLDWP" ]]; then
  question "Do you want to use the project's custom desktop wallpaper? [Y|n] " response
  if [[ $response =~ ^(no|n|N) ]];then
    echo "skipping...";
    ok
  else
    running "Set a custom wallpaper image"
    if [[ $OSTYPE == darwin* ]]; then
      # `DefaultBackground.jpg` is already a symlink, and
      # all wallpapers are in `/Library/Desktop Pictures/`. The default is `Mojave Day.jpg`.
      rm -rf ~/Library/Application Support/Dock/desktoppicture.db
      sudo rm -f /System/Library/CoreServices/DefaultBackground.jpg > /dev/null 2>&1
      sudo rm -f /Library/Desktop\ Pictures/Mojave\ Day.jpg
      sudo cp ./img/laputa_huge.jpg /System/Library/CoreServices/DefaultBackground.jpg;
      sudo cp ./img/laputa_huge.jpg /Library/Desktop\ Pictures/Mojave\ Day.jpg;ok
    else
      gsettings set org.gnome.desktop.background picture-uri file://$(pwd)/img/laputa_huge.jpg;ok
    fi
  fi
fi

################################################
# homebrew/apt
################################################
if [[ $OSTYPE == darwin* ]]; then
  source ./brew.sh;
  source ./casks.sh;
else
  source ./apt.sh;
fi

################################################
bot "Setting up >Git<"
################################################

# skip those GUI clients, git command-line all the way
if [[ $OSTYPE == darwin* ]]; then
  require_brew git
  require_brew fontconfig
else
  require_apt git
  require_apt fontconfig
fi
# need fontconfig to install/build fonts

################################################
bot "Setting up >ZSH<"
################################################
running "installing zsh"; filler
if [[ $OSTYPE == darwin* ]]; then
  require_brew zsh
  require_brew zsh-completions
else
  require_apt zsh
fi

# set zsh as the user login shell
if [[ $OSTYPE == darwin* ]]; then
  CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
else
  CURRENTSHELL=$SHELL
fi
if [[ "$CURRENTSHELL" != "/usr/local/bin/zsh" ]] && [[ "$CURRENTSHELL" != "/usr/bin/zsh" ]]; then
  if [[ $OSTYPE == darwin* ]]; then
    bot "setting newer homebrew zsh (/usr/local/bin/zsh) as your shell (password required)"
    # sudo bash -c 'echo "/usr/local/bin/zsh" >> /etc/shells'
    # chsh -s /usr/local/bin/zsh
    sudo dscl . -change /Users/$USER UserShell $SHELL /usr/local/bin/zsh > /dev/null 2>&1
  else
    bot "setting newer zsh (/usr/local/bin/zsh or /usr/bin/zsh) as your shell (password required)"
    chsh -s $(which zsh)
  fi
  ok
fi

cp configs/honukai.zsh-theme oh-my-zsh/themes/honukai.zsh-theme

if [[ ! -d "./oh-my-zsh/custom/themes/powerlevel9k" ]]; then
  git clone https://github.com/bhilburn/powerlevel9k.git oh-my-zsh/custom/themes/powerlevel9k
fi

################################################
# spacemacs
################################################
if [[ ! -d "$HOME/.emacs.d" ]] ; then
  git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
fi

################################################
# dotfiles
################################################
source ./dotfiles.sh

################################################
# "extra" softare
################################################
source ./extras.sh

################################################
# vim
################################################
vim -c 'PluginInstall' -c 'qa!'

################################################
# osx/not osx
################################################
if [[ $OSTYPE == darwin* ]]; then
  source ./osx.sh;
else
  source ./linux.sh;
fi

################################################
# misc
################################################
bot "installing fonts"
./fonts/install.sh
ok

if [[ $OSTYPE == darwin* ]]; then
  ################################################
  bot "Cleaning up the mess"
  ################################################
  # Remove outdated versions from the cellar
  running "Cleaning up homebrew cache"
  brew cleanup > /dev/null 2>&1
  brew cask cleanup > /dev/null 2>&1
  ok
fi

msg "Note that some of these changes require a logout/restart to take effect."; filler
msg "You should also NOT open System Preferences. It might overwrite some of the settings."; filler
if [[ $OSTYPE == darwin* ]]; then
  running "Killing affected applications (so they can reboot)...."
  for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
      "Dock" "Finder" "Mail" "Messages" "SystemUIServer" "iCal" "Transmission" "Atom" \
      "The Unarchiver" "smcFanControl"; do
  killall "${app}" > /dev/null 2>&1
  done
  ok
fi

botdone

if [[ $OSTYPE == darwin* ]]; then
  {
    ###############################################################################
    bot "Unfortunately I can't setup everything :( Heres a list of things you need to manually do"
    ###############################################################################
    item 1 "Installing from App Store:"
    item 2 "...?"
    item 1 "Installing from JetBrains Toolbox:"
    item 2 "IntelliJ IDEA with plugins"
    item 1 "Installing Google Cloud tools."
    filler
    item 1 "Set Finder settings"
    item 2 "Remove 'All My Files' from sidebar",
    item 2 "Add 'odrive' to sidebar"
    item 2 "Add folders to sidebar: 'Lab'"
    filler
    item 1 "Set odrive configuration."
    item 1 "Sync Firefox."
    item 1 "Set Final Cut Pro X / Compressor / Grammarly configuration."
    item 1 "Set Cursive and SizeUp licenses."
    filler
    item 1 "Extra apps:"
    item 2 "...?"
  } | tee ~/Desktop/osxbot_manual.txt;
else
  {
    ###############################################################################
    bot "Unfortunately I can't setup everything :( Heres a list of things you need to manually do"
    ###############################################################################
    item 1 "Installing from Package Manager:"
    filler
    item 1 "Set Nautilus settings"
    item 2 "Remove 'All My Files', 'Movies', 'Music' and 'Pictures' from sidebar"
    item 2 "Add folders to sidebar: 'Lab'"
    filler
    item 1 "Extra apps:"
    item 2 "...?"
  } | tee ~/Desktop/osxbot_manual.txt;
fi
# force mac version
if [[ $OSTYPE == darwin* ]]; then
  /usr/bin/sed -i '' -e "s/\[32;01m//g; s/\[39;49;00m//g; s/\[35;01m//g" ~/Desktop/osxbot_manual.txt
  filler
  msg "Manual instructions saved to '~/Desktop/osxbot_manual.txt'";filler
fi

botdone

################################################
if [[ $OSTYPE == darwin* ]]; then
  bot "Woot! All done. Kill this terminal and launch iTerm"
else
  bot "Woot! All done. Kill this terminal and launch Terminator"
fi
################################################
