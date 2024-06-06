export PATH=$HOME/.pyenv/bin:$PATH
export PATH=/usr/local/bin:$PATH:~/go/bin

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Add wisely, as too many plugins slow down shell startup.
plugins=(
  	globalias
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
)

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="spaceship"

source $ZSH/oh-my-zsh.sh
source $HOME/.config/zsh/alias.zsh
source $HOME/.config/zsh/venv.zsh
source $HOME/.config/zsh/statusemoji.zsh
source $HOME/.config/zsh/prompt.zsh

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# date format, see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# run homebrew load script
eval "$(/opt/homebrew/bin/brew shellenv)"

if [ -f $HOME/.extra.sh ]; then
  source $HOME/.extra.sh
fi

export PATH=$(pyenv root)/shims:$PATH
export PATH=/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin:$PATH
export CLOUDSDK_PYTHON=/usr/bin/python3
