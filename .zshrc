fpath=(/Users/daniel.klevebring/.local/share/zsh/site-functions $fpath)
export PATH="/Users/daniel.klevebring/.local/bin:$PATH"

export PATH=/usr/local/bin:$PATH:~/go/bin

# start ssh-agent if it's not already running
if ! pgrep -u $USER -x ssh-agent > /dev/null; then
	# agent is not running, start it
    ssh-agent -s > ~/.ssh-agent
	source ~/.ssh-agent
else
	# agent is running, check if SSH_AUTH_SOCK is set
	if [ -z "$SSH_AUTH_SOCK" ]; then
		# if .ssh-agent is availble source it
		if [ -f ~/.ssh-agent ]; then
			echo "Sourcing .ssh-agent"
			source ~/.ssh-agent
		else
			echo "SSH_AUTH_SOCK is not set, looking for agent socket files"
			# .ssh-agent is not available on macos, so instead we look at the agent socket files
			for sock in `ls /tmp/ssh-*/agent.*`; do
				export SSH_AUTH_SOCK=$sock
				if ssh-add -l; then
					echo "Your SSH Agent is fixed. New socket=$sock."
					break
				fi
			done
		fi
	else
		echo "SSH_AUTH_SOCK is set to $SSH_AUTH_SOCK"
	fi
fi

# add ssh key to ssh-agent
ssh-add -l |grep -q daniel.klevebring@gmail.com || ssh-add

# Add wisely, as too many plugins slow down shell startup.
plugins=(
  	globalias
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
)

# Add commands you don't want to expand
GLOBALIAS_FILTER_VALUES=(
    grep
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


export CLOUDSDK_PYTHON=/usr/bin/python3

#set python breakpoint to be ipdb.set_trace instead of the default pdb.set_trace
export PYTHONBREAKPOINT=ipdb.set_trace

# run homebrew load script, if exists
if [ -z "$HOMEBREW_PREFIX" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv | egrep -v '\bPATH=')"
  export PATH="$PATH:${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin"
fi

if [ -f $HOME/.extra.sh ]; then
  source $HOME/.extra.sh
fi
