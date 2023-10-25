#!/bin/bash -e

echo "Setting up your Mac..."

# Install Xcode command line tools if not already installed.
xcode-select --install 2>/dev/null || true

###################################################
# Install rosetta
###################################################
# sudo softwareupdate --install-rosetta --agree-to-licensesudo softwareupdate --install-rosetta --agree-to-license

###################################################
# Install command-line tools using Homebrew.
###################################################
# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install GNU awk
brew install gawk

# Install GnuPG to enable PGP-signing commits.
brew install gnupg

###################################################
# Install more recent versions of some macOS tools.
###################################################
brew install vim --with-override-system-vi
brew install grep
brew install openssh

###################################################
# Install font tools.
###################################################
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font

###################################################
# Install shell tools.
###################################################
brew install zsh
brew install zsh-completions
brew install zsh-syntax-highlighting
brew install zsh-autosuggestions

###################################################
## Install other useful binaries.
###################################################
brew install peco # interactive filtering tool
brew install jq
brew install git
brew install git-lfs
# brew install imagemagick --with-webp
brew install pnpm # package manager
brew install asdf # version manager
brew install tree # display directory tree
brew install bat # cat with wings
brew install starship # cross-shell prompt
brew install chezmoi # dotfiles manager


###################################################
# Install some casks
###################################################
brew tap homebrew/core
brew tap homebrew/cask
brew cask install visual-studio-code
brew cask install google-chrome
brew cask install iterm2 # terminal
brew cask install warp # another terminal
# brew cask install alfred # launcher
brew cask install raycast # launcher
brew cask install slack
brew cask install zoom
brew cask install xmind # mind map
brew cask install authy
# brew cask install diffmerge # diff tool
# brew cask install docker

###################################################
# Remove outdated versions from the cellar.
###################################################
brew cleanup

###################################################
# Install some tools can't be installed by brew
###################################################
curl -fsSL https://d2lang.com/install.sh | sh -s -- # d2lang