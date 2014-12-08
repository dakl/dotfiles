if [[ "$HOSTNAME" == *uppmax* ]]
then
  # modules are used to manage user environment and software packages
  if [ -f /etc/profile.modules ]
  then
    . /etc/profile.modules
  # load a default environment
  #module load sge 
  # PGI compilers
  #module load pgi 
  fi

  # Get the aliases and functions
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi

fi

# Add `~/bin` to the `$PATH`
export PATH="/usr/local/sbin:$HOME/bin:~/python:$PATH"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
#for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
for file in ~/.{path,bash_prompt,aliases,functions,exports,git-completion.bash,extra}; do
	[ -r "$file" ] && source "$file"
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null
done

# If possible, add tab completion for many more commands
#if [ -f /etc/bash_completion ]; then
#  source /etc/bash_completion
#fi

## DRMAA at uppmax, thanks @johandahlberg
export LD_LIBRARY_PATH=/sw/apps/build/slurm-drmaa/1.0.7/lib/:$LD_LIBRARY_PATH

