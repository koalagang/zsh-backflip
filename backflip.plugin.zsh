# source the config file (if it exists) before doing anything else
[ -f "$ZDOTDIR/backflip/config.zsh" ] && source "$ZDOTDIR/backflip/config.zsh"

# set default options if the user has not modified their values
[ -z "$BACKFLIP_COMPLETION" ] && BACKFLIP_COMPLETION=1
[ -z "$BACKFLIP_CYCLE_SELECTION" ] && BACKFLIP_CYCLE_SELECTION=1
[ -z "$BACKFLIP_HISTORY" ] && BACKFLIP_HISTORY=1
[ -z "$BACKFLIP_DOT_EXPANSION" ] && BACKFLIP_DOT_EXPANSION=1
[ -z "$BACKFLIP_FUZZY" ] && BACKFLIP_FUZZY=1
[ -z "$BACKFLIP_BMV" ] && BACKFLIP_BMV=1
[ -z "$BACKFLIP_EMULATE_DIRHIST" ] && BACKFLIP_EMULATE_DIRHIST=0
[ -z "$BACKFLIP_REGEX_SENSITIVE" ] && BACKFLIP_REGEX_SENSITIVE=0
[ -z "$BACKFLIP_BINDINGS_DISABLE" ] && BACKFLIP_BINDINGS_DISABLE=0
[ -z "$BACKFLIP_FZF_ENABLE" ] && BACKFLIP_FZF_ENABLE=0
[ -z "$BACKFLIP_PRINT_CD" ] && BACKFLIP_PRINT_CD=0
[ -z "$BACKFLIP_PRINT_ONLY" ] && BACKFLIP_PRINT_ONLY=0

# find the directory which this file is located in
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# source all the components of backflip
# NOTE: the order of the elements in this array are important
# re-ordering them has consequences
backflip_components=(cycle-selection history dot-expansion fuzzy bmv core completion)
for i in "${backflip_components[@]}"; do
    source "${0:A:h}/$i.zsh"
done
unset backflip_components
