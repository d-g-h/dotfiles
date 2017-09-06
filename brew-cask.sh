#!/bin/bash

# brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup
brew install caskroom/cask/brew-cask
brew tap caskroom/versions

# daily
brew cask install onepassword
brew cask install slack
brew cask install flux
brew cask install vagrant
brew cask install virtualbox-extension-pack

# dev
brew cask install iterm2-beta
brew cask install dockertoolbox

# browsers
brew cask install google-chrome-canary
brew cask install google-chrome
brew cask install firefox
