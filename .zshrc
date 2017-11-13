#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

source ~/.zsh-nvm/zsh-nvm.plugin.zsh
# Customize to your needs...
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
setopt clobber

# mpv
alias mpv="mpv --no-border"

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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/usr/local/sbin:$PATH"

export FZF_DEFAULT_OPTS="
  --extended
  --bind ctrl-f:page-down,ctrl-b:page-up
  --color fg:-1,bg:-1,hl:64,fg+:-1,bg+:-1,hl+:64
  --color info:33,prompt:37,spinner:136,pointer:160,marker:125
"
export HOMEBREW_CASK_OPTS="--appdir=~/Applications "
export ANDROID_HOME=$HOME/Library/Android/sdk

###-begin-ng-completion###
#
# ng command completion script
#
# Installation: ng completion >> ~/.bashrc (or ~/.zshrc)
#

ng_opts="new init build serve generate autocomplete e2e lint test version"
init_opts="--dry-run --verbose --blueprint --skip-npm --skip-bower --name"
new_opts="--dry-run --verbose --blueprint --skip-npm --skip-bower --skip-git --directory"
build_opts="--environment --output-path --watch --watcher"
serve_opts="--port --host --proxy --insecure-proxy --watcher --live-reload --live-reload-host
            --live-reload-port --environment --output-path --ssl --ssl-key --ssl-cert"
generate_opts="component directive pipe route service"
test_opts="--watch --browsers --colors --log-level --port --reporters"

if type complete &>/dev/null; then
  _ng_completion() {
    local cword pword opts

    COMPREPLY=()
    cword=${COMP_WORDS[COMP_CWORD]}
    pword=${COMP_WORDS[COMP_CWORD - 1]}

    case ${pword} in
      ng) opts=$ng_opts ;;
      i|init) opts=$init_opts ;;
      new) opts=$new_opts ;;
      b|build) opts=$build_opts ;;
      s|serve|server) opts=$serve_opts ;;
      g|generate) opts=$generate_opts ;;
      test) opts=$test_opts ;;
    esac

    COMPREPLY=( $(compgen -W "${opts}" -- $cword) )

    return 0
  }
  complete -o default -F _ng_completion ng
elif type compctl &>/dev/null; then
  _ng_completion () {
    local words cword opts
    read -Ac words
    read -cn cword
    let cword-=1

    case $words[cword] in
      ng) opts=$ng_opts ;;
      i|init) opts=$init_opts ;;
      new) opts=$new_opts ;;
      b|build) opts=$build_opts ;;
      s|serve|server) opts=$serve_opts ;;
      g|generate) opts=$generate_opts ;;
      test) opts=$test_opts ;;
    esac

    setopt shwordsplit
    reply=($opts)
    unset shwordsplit
  }
  compctl -K _ng_completion ng
fi
###-end-ng-completion###

ulimit -n 10240
# fix terminals to send ctrl-h to neovim correctly
[[ -f "~/.$TERM.ti" ]] && tic ~/.$TERM.ti
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

alias mopidy="PYTHONPATH=$(brew --prefix)/lib/python2.7/site-packages mopidy"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
