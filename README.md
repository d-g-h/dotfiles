
```sh
xcode-select --install
./bootstrap.sh --dry-run
# ./bootstrap.sh
brew update
brew bundle install --file=./Brewfile
```

`:lua vim.pack.update()`
`:TSUpdate`

```sh
git config --file ~/.gitconfig.local user.name  ""
git config --file ~/.gitconfig.local user.email ""
```

```sh
python3 tests/bootstrap_test.py
```
