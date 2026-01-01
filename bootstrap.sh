#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $DOTFILES_DIR

function symlink() {
	SOURCE_FILE=$1
	TARGET_FILE=$2
	TARGET_DIR=$(dirname "${TARGET_FILE}")
	mkdir -p $(dirname "${TARGET_DIR}")
	if [[ -e "$TARGET_FILE" ]]; then
		if [[ -L "$TARGET_FILE" ]]; then # in bash, -L means "is a symbolic link".
			echo "Symlink \"${TARGET_FILE}\" already in place, skipping symlinking"
		else
			echo "WARNING: \"${TARGET_FILE}\" already exist, can't symlink."
		fi
	else
		echo "Symlinking \"${SOURCE_FILE}\" to \"${TARGET_FILE}\""
		ln -s "$DOTFILES_DIR/${SOURCE_FILE}" "$TARGET_FILE"
	fi
}

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
		--exclude "vm" \
		-av --no-perms . ~

	# copy vscode config files
	VSCODE_BASE="$HOME/Library/Application Support/Code/User"
	FILES=$(find vscode|grep json$|sed  's/^vscode\///')
	mkdir -p ${VSCODE_BASE}
	for SOURCE_FILE in ${FILES[@]}; do
		TARGET_FILE="${VSCODE_BASE}/${SOURCE_FILE}"
		symlink "vscode/${SOURCE_FILE}" "${TARGET_FILE}"
	done

	# copy cursor settings
	SOURCE_FILE="cursor/settings.json"
	TARGET_FILE="$HOME/Library/Application Support/Cursor/User/settings.json"
	symlink "${SOURCE_FILE}" "${TARGET_FILE}"

	# share keybindings from vscode to cursor
	SOURCE_FILE="vscode/keybindings.json"
	TARGET_FILE="$HOME/Library/Application Support/Cursor/User/keybindings.json"
	symlink "${SOURCE_FILE}" "${TARGET_FILE}"

	# ensure that `python` is a symlink to the latest uv-managed Python
	# to let various tools find a functional Python
	./uv-python-symlink.sh

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
