#!/bin/bash
set -euo pipefail
# Compatibility entry point; the Brewfile is the package source of truth.
repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
export DOTFILES_SKIP_APPS=1
exec brew bundle install --file="$repo_dir/Brewfile" "$@"
