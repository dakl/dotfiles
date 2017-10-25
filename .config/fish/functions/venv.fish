function venv --description 'create or activate a virtualenv'
    set VENV_BASE $HOME/.virtualenvs
    if [ $argv = "ls" ]
        ls $VENV_BASE
    else if test -e $VENV_BASE/$argv
        source $VENV_BASE/$argv/bin/activate.fish
    else
        virtualenv --prompt "($argv) " $VENV_BASE/$argv
        source $VENV_BASE/$argv/bin/activate.fish
    end
end