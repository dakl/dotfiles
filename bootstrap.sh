#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $DOTFILES_DIR

#git pull origin master
function doIt() {
	echo "Copying dotfiles to $HOME"
	rsync --quiet \
		--exclude ".git/" \
		--exclude ".vscode/" \
		--exclude ".DS_Store" \
		--exclude "bootstrap.sh" \
		--exclude "init.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		--exclude "install-zsh-ubuntu.sh" \
		--exclude "Brewfile" \
		--exclude "iterm2" \
		--exclude "vscode" \
		-av --no-perms . ~

	VSCODE_BASE="$HOME/Library/Application Support/Code/User"
	FILES=$(find vscode|grep json$|sed  's/^vscode\///')
	mkdir -p ${VSCODE_BASE}
	for SOURCE_FILE in ${FILES[@]}; do
		TARGET_FILE="${VSCODE_BASE}/${SOURCE_FILE}"
		TARGET_DIR=$(dirname "${TARGET_FILE}")
		mkdir -p $(dirname "${TARGET_DIR}")

		if [[ -e "$TARGET_FILE" ]]; then
			if [[ -L "$TARGET_FILE" ]]; then # in bash, -L means "is a symbolic link".
				echo "Symlink ${TARGET_FILE} already in place, skipping symlinking"
			else
				echo "WARNING: ${TARGET_FILE} already exist, can't symlink."
			fi
		else
			echo "Symlinking $SOURCE_FILE to ${TARGET_FILE}"
			ln -s "$DOTFILES_DIR/vscode/${SOURCE_FILE}" "$TARGET_FILE"
		fi
	done

	echo "Done"
}

SOURCE_FILE=Brewfile
TARGET_FILE=${HOME}/Brewfile
if [[ -e "$TARGET_FILE" ]]; then
	if [[ -L "$TARGET_FILE" ]]; then # in bash, -L means "is a symbolic link".
		echo "Symlink ${TARGET_FILE} already in place, skipping symlinking"
	else
		echo "WARNING: ${TARGET_FILE} already exist, can't symlink."
	fi
else
	echo "Symlinking $SOURCE_FILE to ${TARGET_FILE}"
	ln -s "$DOTFILES_DIR/${SOURCE_FILE}" "$TARGET_FILE"
fi

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
