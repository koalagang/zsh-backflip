[[ "$BACKFLIP_CYCLE_SELECTION" == 0 ]] && return

backflip_cycle_selection(){
    # grab everything following bf/bmv in the buffer and make them elements in an array
    local -a args=(${(z)BUFFER##*(bf|bmv) })

    # take the first argument but make sure to remove backslashes if present
    local selection="${args[1]:gs/\\//}"

    [ -z "$selection" ] && return 1

    # absolute -> number
    if [[ -d "$selection" && ! "$selection" =~ '\.\.' ]]; then
        # take the working directory and remove part of the string
        # that contains the directory we're looking for...
        local number="$(print -P "\${PWD:s|$selection||}")/" # the leading slash here is *important*

        # ...we're left with a string containing just the number of slashes we need
        # so we simply count these...
        local number="${#${(ps:/:)${number}}}"

        # ...and then we can replace the argument with that number
        # but make sure to properly escape the backslashes if there are any
        local dir="${args[1]:gs/\\/\\\\/}"
        BUFFER="$(print -P -r "\${BUFFER:s|$dir|$number|}")"
        zle .reset-prompt

    # relative -> absolute
    # or relative -> regex (if a regex was used in a previous cycle)
    elif [[ -d "$selection" && "$selection" =~ '\.\.' ]]; then
        if [ -n "$backflip_regex_selection" ]; then
            # use the previous regex input
            local input="$backflip_regex_selection"
            unset backflip_regex_selection
        else
            # convert selection to its absolute path using the 'a' modifier
            # and make sure to escape backslashes
            local input="${selection:a:gs| |\\\\ |}"
        fi

        LBUFFER="$(print -P -r "\${LBUFFER:s|$selection|$input|}")"
        zle .reset-prompt

    # number -> relative
    elif [[ "$selection" =~ '^[0-9]+$' && "$selection" -gt 0 ]]; then
        # as many instances of ../ as specified
        local relative="${${(pl:$selection*3::../:)}}"
        LBUFFER="$(print -P "\${LBUFFER:s|$selection|$relative|}")"
        zle .reset-prompt

    # regex -> absolute
    else
        local input="$(BACKFLIP_PRINT_ONLY=1 backflip_regex_jump "$selection")"
        [[ "$input" == "$BACKFLIP_ERROR" ]] && return 1
        LBUFFER="$(print -P "\${LBUFFER:s|$selection|$input|}")"
        zle .reset-prompt
        # store selection in a global variable so that we can cycle back to it
        backflip_regex_selection="$selection"
    fi
}
zle -N backflip_cycle_selection
# bind it to ctrl+o
[ "$BACKFLIP_BINDINGS_DISABLE" -ne 0 ] || bindkey '^o' backflip_cycle_selection
