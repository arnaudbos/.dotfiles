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
bot "Setting up >Git<"
################################################

# skip those GUI clients, git command-line all the way
require_brew git
# need fontconfig to install/build fonts
require_brew fontconfig

################################################
bot "Setting up >ZSH<"
################################################
running "installing zsh brews"; filler
require_brew zsh
require_brew zsh-completions
# update ruby to latest
require_brew ruby
# set zsh as the user login shell
CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
if [[ "$CURRENTSHELL" != "/usr/local/bin/zsh" ]]; then
  bot "setting newer homebrew zsh (/usr/local/bin/zsh) as your shell (password required)"
  # sudo bash -c 'echo "/usr/local/bin/zsh" >> /etc/shells'
  # chsh -s /usr/local/bin/zsh
  sudo dscl . -change /Users/$USER UserShell $SHELL /usr/local/bin/zsh > /dev/null 2>&1
  ok
fi

if [[ ! -d "./oh-my-zsh/custom/themes/powerlevel9k" ]]; then
  git clone https://github.com/bhilburn/powerlevel9k.git oh-my-zsh/custom/themes/powerlevel9k
fi

################################################
bot "Installing >homebrew command-line tools<"
################################################

# node version manager
require_brew nvm
