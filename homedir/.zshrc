# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.dotfiles/oh-my-zsh
# if you want to use this, change your non-ascii font to Droid Sans Mono for Awesome
# POWERLEVEL9K_MODE='awesome-patched'
# export ZSH_THEME="powerlevel9k/powerlevel9k"
export ZSH_THEME="honukai"
# https://github.com/bhilburn/powerlevel9k#customizing-prompt-segments
# https://github.com/bhilburn/powerlevel9k/wiki/Stylizing-Your-Prompt
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir nvm vcs)
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status history time)
# colorcode test
# for code ({000..255}) print -P -- "$code: %F{$code}This is how your text would look like%f"
# POWERLEVEL9K_NVM_FOREGROUND='008'
# POWERLEVEL9K_NVM_BACKGROUND='072'
# POWERLEVEL9K_SHOW_CHANGESET=true
#export ZSH_THEME="random"

# Set to this to use case-sensitive completion
export CASE_SENSITIVE="true"

# disable weekly auto-update checks
# export DISABLE_AUTO_UPDATE="true"

# disable colors in ls
# export DISABLE_LS_COLORS="true"

# disable autosetting terminal title.
export DISABLE_AUTO_TITLE="true"

# Which plugins would you like to load? (plugins can be found in ~/.dotfiles/oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git ssh-agent history history-substring-search jsontools lein colored-man-pages colorize copyfile aws chucknorris encode64 tmux vundle docker lein node npm pip virtualenv brew zsh-syntax-highlighting zsh-autosuggestions)

bindkey -v
bindkey '^R' history-incremental-search-backward

export ZSH_DISABLE_COMPFIX="true"
source $ZSH/oh-my-zsh.sh

# Customize to your needs...
unsetopt correct

# run fortune on new terminal :)
chuck_cow | lolcat

eval $(thefuck --alias)

source ~/.zprofile


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/arnaud/Lab/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/arnaud/Lab/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/arnaud/Lab/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/arnaud/Lab/google-cloud-sdk/completion.zsh.inc'; fi

# The next line enables shell command completion for kubectl.
if [ -x "$(command -v kubectl)" ]; then source <(kubectl completion zsh); fi

export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
