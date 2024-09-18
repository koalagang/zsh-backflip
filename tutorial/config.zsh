# THIS IS A SAMPLE CONFIGURATION FOR ZSH-BACKFLIP
# ALL OPTIONS IN THIS FILE ARE COMMENTED OUT BUT ARE SET TO THEIR DEFAULT VALUES
# ANY REFERENCES TO BINDINGS ASSUME DEFAULT BINDINGS ARE USED

### GENERAL ###
# Most features are enabled by default
# but you can disable any of them by adjusting (and uncommenting) the respective values below to 0.
# It's strongly recommended that you at least keep completion enabled
# as this is, arguably, the most important feature.
#
# Tab completion
# BACKFLIP_COMPLETION=1
#
# Cycle through different directory formats (absolute path, number, relative path, regex) using ctrl+o
# BACKFLIP_CYCLE_SELECTION=1
#
# Dot expansion makes typing relative paths easier.
# Simply type '...' to get '../../', with successive dots adding more instances of ../
# BACKFLIP_DOT_EXPANSION=1
# Possible values:
# - BACKFLIP_DOT_EXPANSION=0 -> never expand (i.e. disable)
# - BACKFLIP_DOT_EXPANSION=1 -> only expand after backflip commands
# - BACKFLIP_DOT_EXPANSION=2 -> always expand
#
# Enable the bmv command.
# This allows you to run commands with the current directory as the last argument, which can be useful for cp or mv.
# example usage:
# $ bmv /home/user/path/to/deep/directory mv foo.sh
# is equivalent to
# $ mv /home/user/path/to/deep/directory/foo.sh .
# If you want to use flags, make sure to add quotes:
# $ bmv /home/user/path/to/deep/directory 'cp -rv' yes
# bmv can be used with as many files as you want (just supply more files as arguments):
# $ bmv /home/user/path/to/deep/directory 'cp -rv' foo bar baz
# NOTE: this feature is mainly intended to be used in conjunction with tab completion
# BACKFLIP_BMV=1
#
# By default, backflip's regular expressions are case-insensitive.
# this can be changed by enabling the option below.
# BACKFLIP_REGEX_SENSITIVE=0
#
# Bindings are enabled by default.
# You may wish to disable these if they cause conflicts with other plugins or your own custom bindings.
# An alternative reason is if you don't like the default bindings, in which case you can disable them and then re-bind
# them to your preferred shortcuts.
# The functions available for binding include: backflip_widget backflip_cycle_selection backflip_dirhist_up backflip_dirhist_down
# BACKFLIP_BINDINGS_DISABLE=0

### FUZZY FINDER ###
# All fuzzy finder features are disabled by default as this introduces an additional dependency.
# If you have fzf installed and wish to use this, simply enable the fzf option
# and you can ignore the BACKFLIP_FUZZY_CMD option.
# You can also ignore BACKFLIP_FUZZY_FLAGS unless you want to set your own custom flags.
# Setting this option to 1 and leaving the other options untouched is the 'intended' way of using backflip.
# BACKFLIP_FZF_ENABLE=0
#
# The BACKFLIP_FUZZY_CMD option exists in case you wish to use a fuzzy finder other than fzf.
# The only other tested fuzzy finders are skim and fzy. These are both valid options.
# However, you should note that fzy does not support previews and is not compatible with fzf-tab,
# so the only recommended alternative to fzf is skim.
# BACKFLIP_FUZZY_CMD=''
# example: BACKFLIP_FUZZY_CMD='sk'
# Also, beware that if you wish to use fzf-tab with another fuzzy finder then you will have to set this manually:
# zstyle ':fzf-tab:*' fzf-command sk
# or if you just want it to be used with backflip but not with other commands:
# zstyle ':fzf-tab:complete:bf:*' fzf-command sk
#
# Use this option for any flags you wish to append to the command configured with BACKFLIP_FUZZY_CMD.
# Even if you wish to use your fuzzy finder's preview option, do not set it here (see the BACKFLIP_FUZZY_PREVIEW option).
# BACKFLIP_FUZZY_FLAGS=''
# default value if BACKFLIP_FZF_ENABLE=1:
#     --height 40% --reverse \
#     --scheme=path --tiebreak=end \
#     --no-multi \
#     --bind=ctrl-z:ignore,ctrl-u:preview-page-up,ctrl-d:preview-page-down
# example using skim:
# BACKFLIP_FUZZY_FLAGS='\
#     --height 40% --reverse \
#     --tiebreak=end \
#     --no-multi \
#     --bind=ctrl-z:ignore,ctrl-u:preview-page-up,ctrl-d:preview-page-down'
#
# Command to be used as the previewer.
# NOTE: this feature is only available to fuzzy finders that use the same previewer flag as fzf (`--preview 'yourPreviewer {}`).
# For example, skim uses the exact same flag so it is compatible.
# This command should be one that shows paths in a single column and can take a path as its last input.
# BACKFLIP_FUZZY_PREVIEW=''
# example 1: BACKFLIP_FUZZY_PREVIEW='ls -1 --color=always'
# example 2: BACKFLIP_FUZZY_PREVIEW='eza -1 --color=always --icons=always'
# example 3: BACKFLIP_FUZZY_PREVIEW='find .'

### HISTORY ###
# History related features
# These include:
# - ff ('frontflip'), allowing you to jump back to directories you jumped out of when running bf
# - bfhist, allowing you to view the directories you were previously in but left using bf
# - dirhistory emulation (see BACKFLIP_EMULATE_DIRHIST option)
# BACKFLIP_HISTORY=1
# NOTE: history is only preserved for the zsh session -- it does not persist.
# Closing your terminal or otherwise exiting the session will result in backflip's history being lost.
# This is because it is only intended for quick usage of ff and dirhistory emulation.
# It is not analagous to zsh history or a z.sh/z.lua/zoxide database.
#
# Dirhistory emulation is disabled by default to avoid conflicts.
# If you do not have dirhistory (an Oh My Zsh plugin) installed and wish to use backflip's emulation
# then go right ahead and enable this.
# It allows you to move up and down the directories in your path with alt+h and alt+l or alt+left and alt+right.
# NOTE for everyone: enabling dirhistory emulation will enable backflip history regardless of what option you have set above
# because this emulation depends upon backflip's history feature.
# NOTE for xterm users: to use alt+h or alt+l, you need to add the following to your xresources: `XTerm.vt100.metaSendsEscape: true`
# BACKFLIP_EMULATE_DIRHIST=0

### DEVELOPER OPTIONS ###
# These options are not intended for regular commandline use and should not really be set here.
# They are mainly used internally by the plugin itself but could have potential uses if you write your own custom scripts.
# If you wish to use these, it would be more logical to use them on a per-command basis.
# example:
# $ BACKFLIP_PRINT_ONLY=1 bf ../../../
#
# If enabled, print the directory bf is cd'ing into before cd'ing into it
# BACKFLIP_PRINT_CD=0
#
# If enabled, print the selected directory but do not cd into it
# BACKFLIP_PRINT_ONLY=0
