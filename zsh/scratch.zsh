# scratch [-e] FILE_PATH FILE_STUB FILE_EXTENSION
#
# Options:
#     -e: Open the file in the editor defined by $EDITOR
#
# Created file name:
#     $FILE_PATH/$FILE_NAME
#     $FILE_NAME = scratch-YYYY-mm-dd-H-M-S-$FILE_STUB.$FILE_EXTENSION
#
# Defaults:
#     FILE_STUB: ""
#     FILE_EXTENSION: "md"
#     SCRATCH_PATH: "$HOME/sandbox/scratch"
#
# Usage:
#     scratch
#
function scratch {
    ARG1="$1"
    ARG2="$2"
    ARG3="$3"
    ARG4="$4"

    # Defaults
    OPEN_IN_EDITOR="NO"
    FILE_PATH="$ARG1"
    FILE_STUB="$ARG2"
    FILE_EXTENSION="$ARG3"

    # Check if we need to shift arguments ahead by 1 position
    if [[ "$ARG1" == "-e" ]]; then
        OPEN_IN_EDITOR="YES"
        FILE_PATH="$ARG2"
        FILE_STUB="$ARG3"
        FILE_EXTENSION="$ARG4"
    fi

    FILE_EXTENSION="${FILE_EXTENSION:="md"}"

    FILE_NAME="scratch-`hdate`"
    if [[ -n "$FILE_STUB" ]]; then
        FILE_NAME="$FILE_NAME-$FILE_STUB"
    fi

    FILE_NAME="$FILE_NAME.$FILE_EXTENSION"

    mkdir -p "$FILE_PATH"

    FULL_PATH="$FILE_PATH/$FILE_NAME"
    touch $FULL_PATH

    echo $FULL_PATH

    EDITOR="${EDITOR:-"vim"}"
    CMD="$EDITOR $FULL_PATH"

    if [[ "$OPEN_IN_EDITOR" == "YES" ]] {
        echo $CMD >&2;
        eval $CMD
    }
}

alias sc="scratch ~/sandbox/scratch"
alias sce="scratch -e ~/sandbox/scratch"

alias tf="scratch /tmp"
alias tfe="scratch -e /tmp"
