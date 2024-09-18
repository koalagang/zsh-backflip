if [ "$BACKFLIP_FZF_ENABLE" -eq 1 ]; then
    # set some default options if fzf is enabled
    BACKFLIP_FUZZY_CMD='fzf'
    [ -z "$BACKFLIP_FUZZY_FLAGS" ] && BACKFLIP_FUZZY_FLAGS='\
        --height 40% --reverse \
        --scheme=path --tiebreak=end \
        --no-multi \
        --bind=ctrl-z:ignore,ctrl-u:preview-page-up,ctrl-d:preview-page-down'
elif [ -n "$BACKFLIP_FUZZY_CMD" ]; then
    # do nothing
else
    # if neither option is set, then don't run the rest of the file
    return
fi

# set the previewer if this option is used
[ -n "$BACKFLIP_FUZZY_PREVIEW" ] && BACKFLIP_FUZZY_FLAGS=" $BACKFLIP_FUZZY_FLAGS --preview '$BACKFLIP_FUZZY_PREVIEW {}'" && \
    # if fzf-tab is installed, set it to use the previewer for the first argument (the directory)
    if [ -n "$(whence fzf-tab-complete)" ]; then
        zstyle ':fzf-tab:complete:bf:argument-1'  fzf-preview "$BACKFLIP_FUZZY_PREVIEW \$word"
        zstyle ':fzf-tab:complete:fmv:argument-1'  fzf-preview "$BACKFLIP_FUZZY_PREVIEW \$word"
    fi
