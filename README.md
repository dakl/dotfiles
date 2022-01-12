# Daniel’s dotfiles

You can clone the repository wherever you want. I like to keep it in `~/dotfiles`. The bootstrapper script will copy the files to your home folder.

```bash
git clone https://github.com/dakl/dotfiles.git && cd dotfiles && source bootstrap.sh
```

There are two initializtion scripts which installed stuff I commonly use on my computers. For macOS, use `init.sh`, for ubuntu use `install-zsh-ubuntu.sh`.

## Iterm2 keymap

 To set these bindings in iTerm2, go to Preferences->Profiles->Keys and then Presets->Import and import the file `iterm2/keymap.json`.
 