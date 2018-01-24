function venv --argument-names cmd VENV_NAME --description 'list (ls), create (mk) or activate (a) a virtualenv'
    set VENV_BASE $HOME/.virtualenvs

    if [ -z $cmd ]
        set cmd 'unset'
    end

    if [ -z $VENV_NAME ]
        set VENV_NAME (basename (pwd))
    end
    
    ## List availavle virtualenvs
    if [ $cmd = "ls" ]
        # list available virtualenvs
        ls $VENV_BASE

    
    ## create a new virtualenv
    else if [ $cmd = "mk" ]
        if test -e $VENV_BASE/$VENV_NAME
            echo "Virtualenv $VENV_NAME already exists. Can't create."
            exit 1
        else
            # ask for the name of the new virtualenv
            read -l VENV_NAME -c $VENV_NAME -p "set_color green; echo -n \"Create new virtualenv with name: \"; set_color normal; echo '> '"
            virtualenv --prompt "($VENV_NAME) " $VENV_BASE/$VENV_NAME
            source $VENV_BASE/$VENV_NAME/bin/activate.fish
        end
    
    ## Activate a virtualenv
    else if [ $cmd = "a" ]
        if test -e $VENV_BASE/$VENV_NAME
            source $VENV_BASE/$VENV_NAME/bin/activate.fish
        else if test -e .venv
            source .venv/bin/activate.fish
        else
            echo "Virtualenv \"$VENV_NAME\" doesn't exists. Create it first by running \"venv mk $VENV_NAME\""
        end

    else
        echo "Usage:"
        echo "List virtualenvs:      venv ls"
        echo "Create new virtualenv: venv mk [virtualenv_name] (default name of current dir)"
        echo "Activate virtualenv:   venv a [virtualenv_name] (default name of current dir)"        
    end
end