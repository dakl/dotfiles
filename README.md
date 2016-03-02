# Daniels’s dotfiles

## Installation

### Using Git and the bootstrap script

You can clone the repository wherever you want. (I like to keep it in `~/Projects/dotfiles`, with `~/dotfiles` as a symlink.) The bootstrapper script will pull in the latest version and copy the files to your home folder.

```bash
git clone https://github.com/dakl/dotfiles.git && cd dotfiles && source bootstrap.sh
```

### Using the init scripts

The scripts `init.sh` and `init-osx.sh` assumes that the dotfiles are already bootstrapped.

* On linux: `./init.sh`
* On OS X: `./init-osx.sh`

