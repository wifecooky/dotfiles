#!/bin/bash

echo "Xcodeをインストールします..."
xcode-select --install

## Install rosetta
# sudo softwareupdate --install-rosetta --agree-to-licensesudo softwareupdate --install-rosetta --agree-to-license

## Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

## Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install GNU awk
brew install gawk

# Install GnuPG to enable PGP-signing commits.
brew install gnupg


## Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep
brew install openssh

## Install font tools.
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font

## Install shell tools.
brew install zsh
brew install zsh-completions
brew install zsh-syntax-highlighting
brew install zsh-autosuggestions

## Install other useful binaries.
brew install peco # interactive filtering tool
brew install jq
brew install git
brew install git-lfs
# brew install imagemagick --with-webp
brew install pnpm
brew install asdf
brew install tree
brew install bat
brew install starship # cross-shell prompt


## Install some casks
brew tap homebrew/core
brew tap homebrew/cask
brew cask install visual-studio-code
brew cask install google-chrome
brew cask install iterm2
brew cask install warp
brew cask install raycast
brew cask install slack
# brew cask install zoom
brew cask install xmind # mind map
brew cask install authy
# brew cask install diffmerge # diff tool
# brew cask install docker


# Remove outdated versions from the cellar.
brew cleanup