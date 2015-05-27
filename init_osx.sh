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
  recipes=(git tree sl lesspipe htop-osx caskroom/cask/brew-cask)
  for item in ${recipes[@]}; do
      brew install $item
  done

  if [[ ! "$(type -P gcc-4.2)" ]]; then
    echo "Installing Homebrew dupe recipe: apple-gcc42"
    brew install https://raw.github.com/Homebrew/homebrew-dupes/master/apple-gcc42.rb
  fi
  
  # Install homebrew casks
  casks=( Caskroom/cask/macdown Caskroom/cask/github ) #caskroom/versions/java7 intellij-idea-ce)
  for item in ${casks[@]}; do
      brew cask install $item
  done

fi

#brew cask install caskroom/versions/java7
#brew cask install Caskroom/cask/pycharm-ce
#brew install github-release
#brew cask install rstudio
#brew install Caskroom/cask/r
#brew install Caskroom/cask/virtualbox
#brew install homebrew/versions/scala210
