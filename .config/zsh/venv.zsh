function create_virtualenv () {
    VENV_BASE=.venv
    VENV_NAME=$(basename $(pwd))
    if [ -e $VENV_BASE ]; then
        echo "Virtualenv already exists here. Can't create."
        return 1337
    else
        # ask for the name of the new virtualenv
        vared -p 'Create new virtualenv with name: ' -c VENV_NAME
        python -m venv --prompt "($VENV_NAME) " $VENV_BASE
        source $VENV_BASE/bin/activate
    fi
}

function activiate_venv () {
    VENV_BASE=.venv
    if [ -e .venv ]; then
        source .venv/bin/activate
    else
        echo "Virtualenv doesn't exist here. Create it first by running \"venv mk\""
    fi
}

function venv () {
    if [ "$1" = "mk" ]; then
        create_virtualenv
    elif [ "$1" = "a" ]; then
        activiate_venv
    else
        echo "Usage:"
        echo "Create new virtualenv: venv mk"
        echo "Activate virtualenv:   venv a"
    fi
}
