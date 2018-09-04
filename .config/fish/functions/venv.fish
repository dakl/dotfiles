function venv --argument-names cmd VENV_NAME --description 'list (ls), create (mk) or activate (a) a virtualenv'
    set VENV_BASE .venv

    if [ -z $cmd ]
        set cmd 'unset'
    end

    if [ -z $VENV_NAME ]
        set VENV_NAME (basename (pwd))
    end
    
    ## create a new virtualenv
    if [ $cmd = "mk" ]
        if test -e $VENV_BASE
            echo "Virtualenv already exists here. Can't create."
            exit 1
        else
            # ask for the name of the new virtualenv
            read -l VENV_NAME -c $VENV_NAME -p "set_color green; echo -n \"Create new virtualenv with name: \"; set_color normal; echo '> '"
            python -m venv $VENV_BASE --prompt "($VENV_NAME) "
            source $VENV_BASE/bin/activate.fish
        end
    
    ## Activate a virtualenv
    else if [ $cmd = "a" ]
        if test -e $VENV_BASE
            source $VENV_BASE/bin/activate.fish
        else if test -e .venv
            source .venv/bin/activate.fish
        else
            echo "Virtualenv doesn't exist here. Create it first by running \"venv mk\""
        end

    else
        echo "Usage:"
        echo "Create new virtualenv: venv mk"
        echo "Activate virtualenv:   venv a"
    end
end