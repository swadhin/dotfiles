# Setup virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
export WORKON_HOME=$LOCAL/virtualenvs

if [[ -r "$LOCAL/bin/virtualenvwrapper.sh" ]] ; then
    . "$LOCAL/bin/virtualenvwrapper.sh"
fi
