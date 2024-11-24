#!/usr/bin/env zsh
# shellcheck disable=SC1090

# Exit if the 'fnm' command can not be found
if ! (( $+commands[uv] )); then
    return
fi

# Completions directory for `uv` command
local COMPLETIONS_DIR="${0:A:h}/completions"

# Add completions to the FPATH
typeset -TUx FPATH fpath
fpath=("$COMPLETIONS_DIR" $fpath)

# If the completion file does not exist yet, then we need to autoload
# and bind it to `uv`. Otherwise, compinit will have already done that.
if [[ ! -f "$COMPLETIONS_DIR/_uv" ]]; then
    typeset -g -A _comps
    autoload -Uz _uv
    _comps[uv]=_uv
fi

# Generate and load completion in the background
uv generate-shell-completion zsh 2> /dev/null >| "$COMPLETIONS_DIR/_uv" &|