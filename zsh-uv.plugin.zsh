#!/usr/bin/env zsh

if (( ! $+commands[uv] )); then
  return
fi

local COMPLETIONS_DIR="${0:A:h}/completions"

# Only regenerate completions if does not exist or older than 24 hours
if [[ ! -f "$COMPLETIONS_DIR/_uv" || ! $(find "$COMPLETIONS_DIR/_uv" -newermt "24 hours ago" -print) ]]; then
  uv generate-shell-completion zsh 2> /dev/null >| "$COMPLETIONS_DIR/_uv" &|
fi

# Add completions to the FPATH
typeset -TUx FPATH fpath
fpath=("$COMPLETIONS_DIR" $fpath)