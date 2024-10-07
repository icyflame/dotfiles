function echo_eval {
    CMD="$1"
    echo "$CMD"

    DEBUG="$2"
    if [[ "$DEBUG" == "--go" ]]; then
        eval "$CMD"
    fi
}
