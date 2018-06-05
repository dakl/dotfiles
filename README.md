# Daniels’s dotfiles

## Installation

### Using Git and the bootstrap script

You can clone the repository wherever you want. (I like to keep it in `~/Projects/dotfiles`, with `~/dotfiles` as a symlink.) The bootstrapper script will pull in the latest version and copy the files to your home folder.

```bash
git clone https://github.com/dakl/dotfiles.git && cd dotfiles && source bootstrap.sh
```

# Install base packages with homebrew

```fish
brew install (cat brew-packages.txt)
```
