export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git)

source $ZSH/oh-my-zsh.sh

DISABLE_AUTO_UPDATE=true
DISABLE_UPDATE_PROMPT=true

# aliases
alias t="terraform"
alias k="kubctl"
alias c="code ."
alias be="bundle exec"
alias r="be rails"
