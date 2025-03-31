autoload -U promptinit; promptinit

SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="» "
SPACESHIP_GIT_BRANCH_PREFIX=""
SPACESHIP_GIT_STATUS_STASHED=""

SPACESHIP_PROMPT_ORDER=(
  venv          # Virtualenv section
  time          # Time stamps section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  jobs          # Background jobs indicator
  char          # Prompt character
)

SPACESHIP_RPROMPT_ORDER=(
  statusemoji
)

# if type pyenv > /dev/null; then
#   export PYENV_ROOT="$HOME/.pyenv"
#   export PATH="$PYENV_ROOT/bin:$PATH"
#   eval "$(pyenv init -)"
# fi
