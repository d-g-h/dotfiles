#!/bin/bash
set -euo pipefail
# Compatibility entry point. Installs the complete work package set and apps.
repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
exec brew bundle install --file="$repo_dir/Brewfile" "$@"
