#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")"
#git pull origin master
function doIt() {
	echo "Copying dotfiles to $HOME/"
	rsync --quiet \
		--exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" --exclude "init.sh" \
		--exclude "init_osx.sh" --exclude "README.md" --exclude "LICENSE-MIT.txt" -av --no-perms . ~

	mkdir -p "$HOME/Library/Application Support/Code/User/"
	KEYBINDINGS_FILE="$HOME/Library/Application Support/Code/User/keybindings.json"
	if [[ -e "$KEYBINDINGS_FILE" ]]; then
	    if [[ -L "$KEYBINDINGS_FILE" ]]; then # in bash, -L means "is a symbolic link".
			echo "Symlink for vscode keybindings already in place, skipping symlinking"
		else
		    echo "WARNING: vscode keybindings already exist, can't symlink."
		fi
	else
	    echo "Symlinking vscode keybindings"
		ln -s "$HOME/.vscode.keybindings.json" "$KEYBINDINGS_FILE"
	fi	
	source ~/.bash_profile
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
