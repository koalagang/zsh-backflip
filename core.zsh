# get all the directories above the working directory
backflip_get_dirs(){
    # determine the number of folders deep we are by counting the number of slashes
    # and then loop through that n-1 times so that we don't print the first slash, i.e. root
    for num in {"${#${(ps:/:)${PWD}}}"..2}; do
        print -P "\${PWD:h$num}"
    done
}

backflip_cd(){
    # print and cd
    if [ "$BACKFLIP_PRINT_CD" -eq 1 ]; then
        print "$1" && cd "$1"
    # print but don't cd
    elif [ "$BACKFLIP_PRINT_ONLY" -eq 1 ]; then
        print "$1"
    # just cd
    # this is the default behaviour
    else
        cd "$1"
    fi
}

# show all directories in a menu
backflip_menu(){
    # fuzzy finder
    if [ -n "$BACKFLIP_FUZZY_CMD" ]; then
        backflip_get_dirs | eval "$BACKFLIP_FUZZY_CMD $BACKFLIP_FUZZY_FLAGS"
    # number menu (uses builtin select function to avoid hard dependency on fzf)
    else
        IFS=$'\n' local dirs=($(backflip_get_dirs))
        select directory in "${dirs[@]}"; do
            print "$directory"
            break
        done
    fi
}

# this variable is not made local so that we can reference it in a completion function
[ -z "$BACKFLIP_ERROR" ] && BACKFLIP_ERROR='backflip: error: pattern not found or invalid input given'

# just type one or two letters to jump to the directory, e.g.
# $ pwd
# /home/user/path/to/very/very/deep/directory
# $ bf p
# $ pwd
# /home/user/path
backflip_regex_jump(){
    # keep the regex match local
    local match ; local MATCH

    local REGEX='(.*/'$1'[^/]*/).*'

    # if case-sensitivity is not enabled, make the regex case-insensitive
    [ "$BACKFLIP_REGEX_SENSITIVE" -ne 1 ] && setopt localoptions nocasematch

    if [[ "$PWD" =~ "$REGEX" ]]; then
        backflip_cd "$match"
    else
        # if there is no regex match then we can error out
        # because the regex jump is the ultimate fallback
        print "$BACKFLIP_ERROR"
    fi
}

# widget for activating backflip without manually running the bf command
# requires a fuzzy finder to be set (recommended: fzf)
if [ -n "$BACKFLIP_FUZZY_CMD" ]; then
    backflip_widget(){
        local selected="$(backflip_menu)"
        if [ -n "$selected" ]; then
            # cd'ing directly causes some issues with the prompt getting stuck
            # so instead we run it as a command
            zle .push-line # clear the buffer but remember the cleared contents
            BUFFER="cd $selected" # fill the buffer with a cd command
            zle .accept-line # run the cd command
        fi
        zle .reset-prompt # reset the prompt, restoring the buffer's previous contents
    }
    zle -N backflip_widget
    # bind it to ctrl+b
    [ "$BACKFLIP_BINDINGS_DISABLE" -ne 0 ] || bindkey '^b' backflip_widget
fi

# bf is the main command through which the user interacts with the plugin
bf(){
    # menu jump
    # if given no input, select from a menu
    if [ -z "$1" ]; then
        [ "$BACKFLIP_HISTORY" -eq 1 ] && backflip_history
        local selected="$(backflip_menu)"
        [ -n "$selected" ] && backflip_cd "$selected"

    # number jump
    # if given a positive integer, jump back that number of directories
    elif [[ "$1" =~ '^[0-9]+$' && "$1" -gt 0 ]]; then
        [ "$BACKFLIP_HISTORY" -eq 1 ] && backflip_history
        # go up the specified number of directories
        # e.g. `bf 3` -> cd ../../../
        # the reason for passing the absolute directory into backflip_cd is in case BACKFLIP_PRINT is used
        local selected="${${(pl:$1*3::../:)}}" && backflip_cd "${selected:a}"

    # directory jump
    # if given a directory, cd into it
    # mainly intended for use with bf's completion
    # (otherwise using bf in this context would be no different from using cd)
    elif [[ -d "$1" && -z "$2" ]]; then
        [ "$BACKFLIP_HISTORY" -eq 1 ] && backflip_history
        backflip_cd "$1"

    # if given two or more arguments, run them in the selected directory
    elif [ -n "$2" ]; then
        # 1. enter a subshell
        # 2. unset chpwd_functions inside the subshell to prevent them from interfering
        # 3. cd into the directory
        # 4. run the specified command (by evaluating everything after the first argument)
        # 5. exit the subshell (chpwd_functions are preserved because they were only unset inside the subshell)
        ( unset chpwd_functions && cd "$(BACKFLIP_PRINT_ONLY=1 bf "$1")" && eval "${@:2}" )

    # regex jump
    # if all else fails, run the input through a regex check and cd into it if there's a match
    else
        [ "$BACKFLIP_HISTORY" -eq 1 ] && backflip_history
        backflip_regex_jump "$1"
    fi
}
