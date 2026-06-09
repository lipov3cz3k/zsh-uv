#!/usr/bin/env zsh
# shellcheck disable=SC1090

# Exit if the 'uv' command can not be found
if ! (( $+commands[uv] )); then
    return
fi

# Completions directory for `uv` command
local COMPLETIONS_DIR="${0:A:h}/completions"

# Add completions to the FPATH
typeset -TUx FPATH fpath
fpath=("$COMPLETIONS_DIR" $fpath)

local _uv_version="$(uv --version 2>/dev/null)"
local _version_file="${COMPLETIONS_DIR}/.uv-version"

# Generate completion only when missing or uv version changed, to avoid
# invalidating completion cache (e.g. zimfw .dat mtime check) on every load.
if [[ ! -f "$COMPLETIONS_DIR/_uv" || "$_uv_version" != "$(cat "$_version_file" 2>/dev/null)" ]]; then
    uv generate-shell-completion zsh 2>/dev/null >| "$COMPLETIONS_DIR/_uv"
    print -r -- "$_uv_version" >| "$_version_file"
fi

# If the completion file still does not exist (generation failed), then we need
# to autoload and bind it to `uv`. Otherwise, compinit will have already done that.
if [[ ! -f "$COMPLETIONS_DIR/_uv" ]]; then
    typeset -g -A _comps
    autoload -Uz _uv
    _comps[uv]=_uv
fi