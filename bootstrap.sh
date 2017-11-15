#!/bin/bash

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DOTFILES_DIR

#git pull origin master
function doIt() {
	echo "Copying dotfiles to $HOME/"
	rsync --quiet \
		--exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" --exclude "init.sh" \
		--exclude "init_osx.sh" --exclude "README.md" --exclude "LICENSE-MIT.txt" \
		--exclude ".vscode.keybindings.json" --exclude ".vscode.settings.json" \
		-av --no-perms . ~

	mkdir -p "$HOME/Library/Application Support/Code/User/"
	VSCODE_KEYBINDINGS_FILE="$HOME/Library/Application Support/Code/User/keybindings.json"
	VSCODE_SETTINGS_FILE="$HOME/Library/Application Support/Code/User/settings.json"
	if [[ -e "$VSCODE_KEYBINDINGS_FILE" ]]; then
	    if [[ -L "$VSCODE_KEYBINDINGS_FILE" ]]; then # in bash, -L means "is a symbolic link".
			echo "Symlink for vscode keybindings already in place, skipping symlinking"
		else
		    echo "WARNING: vscode keybindings already exist, can't symlink."
		fi
	else
	    echo "Symlinking vscode keybindings"
		ln -s "$DOTFILES_DIR/.vscode.keybindings.json" "$VSCODE_KEYBINDINGS_FILE"
	fi	

	if [[ -e "$VSCODE_SETTINGS_FILE" ]]; then
	    if [[ -L "$VSCODE_SETTINGS_FILE" ]]; then # in bash, -L means "is a symbolic link".
			echo "Symlink for vscode settings already in place, skipping symlinking"
		else
		    echo "WARNING: vscode settings already exist, can't symlink."
		fi
	else
	    echo "Symlinking vscode settings"
		ln -s "$DOTFILES_DIR/.vscode.settings.json" "$VSCODE_SETTINGS_FILE"
	fi	

	# create virtualenvs dir if it doesn't exist
	mkdir -p ${HOME}/.virtualenvs

	echo "Done"
}
if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt
	fi
fi
unset doIt
