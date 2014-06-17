# .bashrc

if [[ "$HOSTNAME" == *uppmax* ]]
then
  # Modules, activate the module command
  case "$0" in
    -sh|sh|*/sh)modules_shell=sh ;;
    -ksh|ksh|*/ksh)modules_shell=ksh ;;
    -zsh|zsh|*/zsh)modules_shell=zsh ;;
    -bash|bash|*/bash)modules_shell=bash ;;
  esac
  module() { eval `/usr/local/Modules/$MODULE_VERSION/bin/modulecmd $modules_shell $*`; }

  # User specific aliases and functions

  # Source global definitions
  if [ -f /etc/bashrc ]; then
    . /etc/bashrc
  fi
fi
