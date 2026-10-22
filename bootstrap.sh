#!/bin/bash
# Run from a checkout on a new Mac. Compatible with macOS's Bash 3.2.
set -euo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
ZSH_DIR="${ZDOTDIR:-$CONFIG_DIR/zsh}"
BACKUP_DIR="$HOME/.dotfiles-backups/$(date +%Y%m%d-%H%M%S)-$$"
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: ./bootstrap.sh [--dry-run]
  --dry-run               Show actions without writing files or using the network
  -h, --help              Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

[[ "$(uname -s)" == Darwin ]] || { echo 'This bootstrap supports macOS only.' >&2; exit 1; }
[[ $EUID -ne 0 ]] || { echo 'Run as your own user, without sudo.' >&2; exit 1; }
for directory in "$HOME" "$CONFIG_DIR" "$ZSH_DIR"; do
  [[ "$directory" == /* ]] || { echo 'HOME, XDG_CONFIG_HOME and ZDOTDIR must be absolute paths.' >&2; exit 1; }
done

run() {
  if [[ $DRY_RUN == 1 ]]; then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

link_file() {
  local source="$1" destination="$2" backup
  if [[ -L "$destination" && "$(readlink "$destination")" == "$source" ]]; then
    return
  fi
  if [[ -e "$destination" || -L "$destination" ]]; then
    backup="$BACKUP_DIR$destination"
    run mkdir -p "$(dirname "$backup")"
    run mv "$destination" "$backup"
  fi
  run mkdir -p "$(dirname "$destination")"
  run ln -s "$source" "$destination"
}

clone_if_missing() {
  local url="$1" destination="$2"
  if [[ -d "$destination/.git" || -f "$destination/.git" ]]; then
    printf 'Keeping existing checkout: %s\n' "$destination"
  elif [[ -e "$destination" || -L "$destination" ]]; then
    printf 'Expected a Git checkout at %s; move it aside and rerun.\n' "$destination" >&2
    exit 1
  else
    run mkdir -p "$(dirname "$destination")"
    run git clone --depth 1 --recursive "$url" "$destination"
  fi
}

if ! xcode-select -p >/dev/null 2>&1; then
  run xcode-select --install
  echo 'Finish installing the Xcode Command Line Tools, then rerun this script.'
  exit 0
fi
if [[ -x /opt/homebrew/bin/brew ]]; then
  BREW=/opt/homebrew/bin/brew
elif [[ -x /usr/local/bin/brew ]]; then
  BREW=/usr/local/bin/brew
elif command -v brew >/dev/null 2>&1; then
  BREW="$(command -v brew)"
else
  if [[ $DRY_RUN == 1 ]]; then
    echo '[dry-run] Install Homebrew using https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
  else
    installer="$(mktemp -t dotfiles-homebrew)"
    trap 'rm -f "$installer"' EXIT
    curl --fail --silent --show-error --location https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$installer"
    /bin/bash "$installer"
  fi
  if [[ "$(uname -m)" == arm64 ]]; then BREW=/opt/homebrew/bin/brew; else BREW=/usr/local/bin/brew; fi
fi
if [[ $DRY_RUN == 0 ]]; then eval "$("$BREW" shellenv)"; fi
run "$BREW" bundle install --file="$REPO_DIR/Brewfile"

# Preserve the previous Git config as the local override on first install.
if [[ -f "$HOME/.gitconfig" && ! -L "$HOME/.gitconfig" && ! -e "$HOME/.gitconfig.local" && ! -L "$HOME/.gitconfig.local" ]]; then
  run cp -p "$HOME/.gitconfig" "$HOME/.gitconfig.local"
fi
for name in .zshenv .gitconfig .tmux.conf .hushlogin .sift.conf; do
  link_file "$REPO_DIR/$name" "$HOME/$name"
done
for name in .zshenv .zprofile .zshrc .zpreztorc; do
  link_file "$REPO_DIR/$name" "$ZSH_DIR/$name"
done
link_file "$REPO_DIR/nvim" "$CONFIG_DIR/nvim"
link_file "$REPO_DIR/wezterm.lua" "$CONFIG_DIR/wezterm/wezterm.lua"
link_file "$REPO_DIR/git/ignore" "$CONFIG_DIR/git/ignore"
link_file "$REPO_DIR/user_settings.json" "$HOME/Library/Application Support/Code/User/settings.json"

# nvm changes shell options internally; load it without nounset.
run mkdir -p "${NVM_DIR:-$HOME/.nvm}"
if [[ $DRY_RUN == 1 ]]; then
  printf '[dry-run] Load nvm; install Node LTS and packages from npm-global.txt\n'
else
  export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
  set +u
  if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
  else
    source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
  fi
  nvm install --lts
  nvm alias default "$(nvm current)"
  packages=()
  while IFS= read -r package || [[ -n "$package" ]]; do
    case "$package" in ''|\#*) continue ;; esac
    packages+=("$package")
  done < "$REPO_DIR/npm-global.txt"
  npm install --global "${packages[@]}"
  set -u
fi

clone_if_missing https://github.com/sorin-ionescu/prezto.git "$ZSH_DIR/.zprezto"
while IFS= read -r plugin; do
  clone_if_missing "https://github.com/$plugin.git" "$HOME/.tmux/plugins/${plugin##*/}"
done < <(sed -n "s/^set -g @plugin '\([^']*\)'$/\1/p" "$REPO_DIR/.tmux.conf")
if [[ $DRY_RUN == 0 ]]; then
  nvim --clean --headless '+lua if vim.fn.has("nvim-0.12") == 0 then vim.cmd("cquit 1") end' +qa
fi
run nvim --headless --cmd 'let g:dotfiles_bootstrap = 1' '+lua dofile(vim.fn.stdpath("config") .. "/bootstrap.lua")' +qa

code_bin="$(command -v code || true)"
if [[ -z "$code_bin" ]]; then code_bin='/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code'; fi
while IFS= read -r extension || [[ -n "$extension" ]]; do
  [[ -n "$extension" ]] && run "$code_bin" --install-extension "$extension"
done < "$REPO_DIR/vscode-extensions.txt"

printf '\nConfiguration ready. Backups, if needed: %s\n' "$BACKUP_DIR"
echo 'Set work Git identity using: git config --file ~/.gitconfig.local user.name "Your Name"'
echo '                           git config --file ~/.gitconfig.local user.email "you@company.com"'
echo 'Open a new terminal, or run: exec /bin/zsh -l'
echo 'For Terraform, run tfenv install <project-version> and tfenv use <project-version>.'
