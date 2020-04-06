autoload -U promptinit; promptinit
prompt spaceship

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
