[[ "$BACKFLIP_DOT_EXPANSION" == 0 ]] && return

backflip_dot_expansion() {
    # Note that this function is a fork of Mikael Magnusson's rationalise-dot.
    # You can find the original code here: https://www.zsh.org/mla/users/2010/msg00768.html

    # keep the regex match from leaking into the environment
    local match ; local MATCH

    if [ "$BACKFLIP_DOT_EXPANSION" -eq 1 ]; then
        # requires the use of the bf (or bmv) command
        # this is the default as to avoid confusion
        local REGEX='(^bf |^bmv |/)\.\.'
    elif [ "$BACKFLIP_DOT_EXPANSION" -eq 2 ]; then
        # matches in most cases
        local REGEX='(^|/| |'$'\n''|\||;|&)\.\.'
    fi

    # note the need for \$ following $REGEX below as we didn't place it in the variable
    # due to the slight difference in the two if statements
    # if ending with a slash, insert two dots and a slash
    if [[ "$LBUFFER" =~ "$REGEX/\$" ]]; then
      zle .self-insert
      zle .self-insert
      LBUFFER+='/'
    # if not ending with a slash, insert a slash and then two dots and another slash
    # this is only invoked after the third dot,
    # with the above if statement being invoked on subsequent dots
    elif [[ "$LBUFFER" =~ "$REGEX\$" ]]; then
      LBUFFER+='/'
      zle .self-insert
      zle .self-insert
      LBUFFER+='/'
    # if neither regex is met then we should just insert a dot
    else
      zle .self-insert
    fi
}
zle -N backflip_dot_expansion
# usually we check if $BACKFLIP_BINDINGS_DISABLE=1 but there's no reason to do it in this case
# because whether or not to use dot expansion is determined by the value of $BACKFLIP_DOT_EXPANSION_DISABLE
bindkey . backflip_dot_expansion

# without this, typing a . aborts incremental history search
bindkey -M isearch . self-insert
