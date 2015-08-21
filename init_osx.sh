# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# Some tools look for XCode, even though they don't need it.
# https://github.com/joyent/node/issues/3681
# https://github.com/mxcl/homebrew/issues/10245
if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]]; then
  sudo xcode-select -switch /usr/bin
fi

# Install Homebrew.
if [[ ! "$(type -P brew)" ]]; then
  echo "Installing Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if [[ "$(type -P brew)" ]]; then
  echo "Updating Homebrew"
  brew update

  # Install Homebrew recipes.
  recipes=(git tree sl lesspipe htop-osx stress maven graphviz Caskroom/cask/brew-cask)
  for item in ${recipes[@]}; do
      brew install $item
  done

  if [[ ! "$(type -P gcc-4.2)" ]]; then
    echo "Installing Homebrew dupe recipe: apple-gcc42"
    brew install https://raw.github.com/Homebrew/homebrew-dupes/master/apple-gcc42.rb
  fi
  
  #brew casks
  brew cask install Caskroom/cask/macdown
  brew cask install Caskroom/versions/java7
  brew cask install Caskroom/cask/pycharm-ce
  #brew install github-release
  brew install Caskroom/cask/r
  brew install Caskroom/cask/rstudio
  #brew install Caskroom/cask/virtualbox
  brew install homebrew/versions/scala210
  #brew install Caskroom/cask/chefdk
  #brew install Caskroom/cask/puppet
  brew install Caskroom/cask/keepingyouawake
  brew install Caskroom/cask/virtualbox
  brew install Caskroom/cask/vagrant
  brew install Caskroom/cask/sourcetree

fi
