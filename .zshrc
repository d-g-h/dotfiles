export TERM="screen-256color"

autoload -Uz compinit
compinit
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.history
alias history="history 0"
alias vim="nvim"
alias tmux="tmux -2"
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias spot='mdfind -onlyin `pwd`'
bindkey "^R" history-incremental-search-backward

# History
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

#List, find, and what not
alias g="grep -in"

# Show history
alias history="fc -l 1"
alias ha="history | ack"

# List direcory contents
alias lsa="ls -lah"
alias l="ls -lA1"
alias ll="ls -l"
alias la="ls -lA"
alias sl=ls # often screw this up
alias lt="ls -ltFh"   #long list,sorted by date,show type,human readable

autoload -U zmv
alias mmv="noglob zmv -W"
bindkey -v

export LC_CTYPE=C
export LANG=C
export LC_ALL=en_US.UTF-8

#common directories
. `brew --prefix`/etc/profile.d/z.sh

export GOPATH=$HOME/go
PATH=$PATH:$GOPATH/bin

export PATH="$HOME/.node/bin:$PATH"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export NVM_DIR=~/.nvm
. $(brew --prefix nvm)/nvm.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/usr/local/sbin:$PATH"

export FZF_DEFAULT_OPTS="
  --extended
  --bind ctrl-f:page-down,ctrl-b:page-up
  --color fg:-1,bg:-1,hl:64,fg+:-1,bg+:-1,hl+:64
  --color info:33,prompt:37,spinner:136,pointer:160,marker:125
"
export HOMEBREW_CASK_OPTS="--appdir=/Applications --caskroom=/etc/Caskroom"
