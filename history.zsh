[[ "$BACKFLIP_HISTORY" == 0 ]] && [[ "$BACKFLIP_EMULATE_DIRHIST" == 0 ]] && return

# emulate Oh My Zsh's dirhistory plugin
# IMPORTANT: this must be loaded *before* the BACKFLIP_HISTORY if block that loads ff and bfhist
if [ "$BACKFLIP_EMULATE_DIRHIST" -eq 1 ]; then
    backflip_dirhist_up(){
        # locally disable auto_pushd if it is enabled
        # because otherwise using dirhist a lot will pollute the directory stack
        unsetopt localoptions auto_pushd

        # temporarily unset chpwd_functions to prevent them from interfering
        local temp_chpwd=(chpwd_functions) && unset chpwd_functions
        bf ..
        zle .reset-prompt
        chpwd_functions=(temp_chpwd)
    }
    zle -N backflip_dirhist_up

    backflip_dirhist_down(){
        unsetopt localoptions auto_pushd

        # don't print directories in history when jumping forwards
        local BACKFLIP_HISTORY_SILENT=1

        local temp_chpwd=(chpwd_functions) && unset chpwd_functions
        # only attempt to jump forwards if there actually is a history
        [ -n "$BACKFLIP_PAST_DIR" ] && ff
        zle .reset-prompt
        chpwd_functions=(temp_chpwd)
    }
    zle -N backflip_dirhist_down

    # set all the bindings
    # this part is a modified version of the dirhistory bindings code
    [ "$BACKFLIP_BINDINGS_DISABLE" -ne 0 ] || for keymap in emacs vicmd viins; do
        # alt + arrow left (up) or right (down)
        if [[ "$TERM_PROGRAM" == 'Apple_terminal' ]]; then
            # Terminal.app
            bindkey -M "$keymap" "^[b" backflip_dirhist_up
            bindkey -M "$keymap" "^[f" backflip_dirhist_down
        elif [[ "$TERM_PROGRAM" == 'iTerm.app' ]]; then
            # iTerm2
            bindkey -M "$keymap" "^[^[[D" backflip_dirhist_up
            bindkey -M "$keymap" "^[^[[C" backflip_dirhist_down
        else
            # xterm normal mode
            bindkey -M "$keymap" "\e[1;3D" backflip_dirhist_up
            bindkey -M "$keymap" "\e[1;3C" backflip_dirhist_down

            # xterm application mode
            bindkey -M "$keymap" "\e[3D" backflip_dirhist_up
            bindkey -M "$keymap" "\e[3C" backflip_dirhist_down

            # urxvt (aka rxvt-unicode)
            bindkey -M "$keymap" "^[${terminfo[kcub1]}" backflip_dirhist_up
            bindkey -M "$keymap" "^[${terminfo[kcuf1]}" backflip_dirhist_down

            # Putty
            bindkey -M "$keymap" "\e\e[D" backflip_dirhist_up
            bindkey -M "$keymap" "\e\e[C" backflip_dirhist_down

            # GNU screen
            bindkey -M "$keymap" "\eO3D" backflip_dirhist_up
            bindkey -M "$keymap" "\eO3C" backflip_dirhist_down
        fi

        # alt + h (up) or l (down)
        # should work with most terminals as far as I'm aware
        # I don't have a mac to test terminal.app or iterm2 with, though
        # if using xterm (please don't), you need to set the following in your xresources:
        # XTerm.vt100.metaSendsEscape: true
        bindkey -M "$keymap" '^[h' backflip_dirhist_up
        bindkey -M "$keymap" '^[l' backflip_dirhist_down
    done
fi

# keep a record of past directories
backflip_history(){
    # seeing as we can't continue to go up the tree once we reach root
    # there's no point in adding it to the history
    [[ "$PWD" != '/' ]] && BACKFLIP_PAST_DIR=($PWD $BACKFLIP_PAST_DIR)
}

# jump to previous directory in the history
# (i.e. go back to where you were before you 'backflipped' -> do a 'frontflip')
# similar to popd but only applies to directories you've *gone out of* using bf
ff(){
    if [ -n "$BACKFLIP_PAST_DIR" ]; then
        [ "$BACKFLIP_HISTORY_SILENT" -ne 1 ] && print -D "\n${BACKFLIP_PAST_DIR[@]}"
        cd "${BACKFLIP_PAST_DIR[1]}" && shift BACKFLIP_PAST_DIR
    else
        print 'ff: directory stack empty'
    fi
}

# print directories in the history
bfhist(){
  for i in {1.."${#BACKFLIP_PAST_DIR[@]}"}; do
      print -D "${BACKFLIP_PAST_DIR[$i]}"
  done
}
