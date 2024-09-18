[[ "$BACKFLIP_COMPLETION" == 0 ]] && return

# RECOMMENDED: install Aloxaf/fzf-tab to use fzf for the completion menu
# see fuzzy.zsh for more on that

# disable completion sorting (i.e. display completion in the order that backflip intends to)
zstyle ':completion:*:bf:*' sort false
zstyle ':completion:*:bmv:*' sort false

# completion for directories
backflip_completion_dirs(){
    IFS=$'\n' local -a dirs=($(backflip_get_dirs))
    _describe 'command' dirs
}

backflip_completion_files(){
    # grab everything following the command in the buffer and make them elements in an array
    local -a args=(${(z)BUFFER##*(bf|ff|bmv) })
    # take the first argument but make sure to remove backspaces if present
    local selection="${args[1]:gs/\\//}"

    # if the selection is not a directory then we must convert it to one
    if ! [ -d "$selection" ]; then
        local dir="$(BACKFLIP_PRINT_ONLY=1 bf "$selection")"
        [[ "$dir" == "$BACKFLIP_ERROR" ]] && return 1 # exit if it errors out (i.e. no match is made)
    else
        local dir="$selection"
    fi

    # perform completion on all files in the directory
    [ -n "$dir" ] && _files -W "$dir"
}

backflip_command_flag_completion(){
    # grab everything following the command in the buffer and make them elements in an array
    local -a args=(${(z)BUFFER##*(bf|ff|bmv) })

    # take the second argument
    local selection="${args[2]}"

    # local dir="${args[1]:gs/\\//}"

    # if a completion function exists, use it
    whence _${selection} >/dev/null && _${selection}
}

# TODO: find a means of making the last completion (files) infinitely repeatable
# as it stands, I've just put in three of those completions
_backflip(){
    _arguments '1:first:backflip_completion_dirs' '2:second:_command_names' \
        '::optional:backflip_command_flag_completion' '::optional:backflip_completion_files' \
        '::optional:backflip_completion_files' '::optional:backflip_completion_files' '::optional:backflip_completion_files'
}
compdef _backflip bf ff bmv
