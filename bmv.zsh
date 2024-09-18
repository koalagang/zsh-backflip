[[ "$BACKFLIP_BMV" == 0 ]] && return

# run commands with the current directory as the last argument
# can be useful for cp or mv
# bmv /home/user/path/to/very/very/deep/directory mv hello.txt
# is equivalent to
# mv /home/user/path/to/very/very/deep/directory/hello.txt .

# if you want to use flags, make sure to add quotes
# bmv /home/user/path/to/very/very/deep/directory 'cp -rv' world/

# can be used with as many files as you want (just supply more files as arguments)
# bmv /home/user/path/to/very/very/deep/directory 'cp -rv' foo/ bar.md baz.sh

# you can even use fileglobs
# bmv /home/user/path/to/very/very/deep/directory 'cp -rv' *

# if an alias exists, remove it in case bmv is re-sourced (see alias after the function)
alias bmv >/dev/null && unalias bmv
bmv(){
    [ -z "$3" ] && \
        print -f "bmv: error: please provide at least three arguments\nusage: bmv <directory> <command> <file>\nexample: bmv /path/to/directory 'cp -rv' foo\n" \
        && return 1

    for param in "${@:3}"; do
        eval "$2 $1/$param" .
    done
}
# adding noglob means that bmv won't see the fileglob as being in the *current directory*
# but when we run eval in the for loop, this is seen as a glob so this allows for fileglobbing
# the way one would expect it to work when using bmv
alias bmv='noglob bmv'
