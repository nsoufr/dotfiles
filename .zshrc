# instant prompt — must be near the top
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

export PATH="$HOME/.local/bin:$PATH"
