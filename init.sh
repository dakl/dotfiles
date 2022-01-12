#!/usr/bin/env bash

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils
echo "Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install other useful binaries
brew install git

# set git user and email
git config --global user.email "daniel.klevebring@gmail.com"
git config --global user.name "Daniel Klevebring"

# Install Bash
brew install bash

# Install wget with IRI support
brew install wget --enable-iri

# Install more recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep

# Install ag, http and jq
brew install the_silver_searcher httpie jq

# Remove outdated versions from the cellar
brew cleanup
