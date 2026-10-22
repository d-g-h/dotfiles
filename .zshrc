# Interactive shell configuration; machine-specific changes go in .zshrc.local.
# Handle non-login shells as well as the default macOS login shell.
if [[ -z "$HOMEBREW_PREFIX" ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
else
  autoload -Uz compinit
  compinit
fi

export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
elif [[ -n "$HOMEBREW_PREFIX" && -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]]; then
  source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
fi

HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="$HOME/.history"
setopt APPEND_HISTORY EXTENDED_HISTORY HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST HIST_SAVE_NO_DUPS HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS SHARE_HISTORY clobber

alias vim=nvim
alias vimdiff='nvim -d'
alias tmux='tmux -2'
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias spot='mdfind -onlyin "$PWD"'
alias g='grep -in'
alias history='fc -l 1'
alias ha='history | rg'
alias lsa='ls -lah'
alias l='ls -lA1'
alias ll='ls -l'
alias la='ls -lA'
alias sl=ls
alias lt='ls -ltFh'
autoload -Uz zmv
alias mmv='noglob zmv -W'
bindkey -v
bindkey '^R' history-incremental-search-backward

export LANG=en_US.UTF-8
export GOPATH="${GOPATH:-$HOME/go}"
export ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
typeset -gU path
path=("$HOME/.local/bin" "$HOME/.node/bin" "$GOPATH/bin" $path "$HOME/.rvm/bin")

if [[ -n "$HOMEBREW_PREFIX" && -r "$HOMEBREW_PREFIX/etc/profile.d/z.sh" ]]; then
  source "$HOMEBREW_PREFIX/etc/profile.d/z.sh"
fi
export FZF_DEFAULT_OPTS='
  --extended
  --bind ctrl-f:page-down,ctrl-b:page-up
  --color fg:-1,bg:-1,hl:64,fg+:-1,bg+:-1,hl+:64
  --color info:33,prompt:37,spinner:136,pointer:160,marker:125
'
if (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi
ulimit -n 10240 2>/dev/null || true
[[ -r "${ZDOTDIR:-$HOME}/.zshrc.local" ]] && source "${ZDOTDIR:-$HOME}/.zshrc.local"
true
