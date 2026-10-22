# Homebrew must be available before Prezto and shell plugins start.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LANG=en_US.UTF-8
typeset -gU path
path=("$HOME/.local/bin" "$HOME/bin" $path)

[[ -r "$HOME/.orbstack/shell/init.zsh" ]] && source "$HOME/.orbstack/shell/init.zsh"
[[ -r "${ZDOTDIR:-$HOME}/.zprofile.local" ]] && source "${ZDOTDIR:-$HOME}/.zprofile.local"
true
