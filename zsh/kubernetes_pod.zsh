function selector_string {
    if [[ "$@" != "" ]]; then
        echo '| ag --nocolor '"$@"
    else
        echo ''
    fi
}

function selector_string_json {
    if [[ "$@" != "" ]]; then
        PATTERN="$@"
        echo "| jq '{ items: [.items[] | select(.metadata.name | test(\"$@\")) ]}'"
    else
        echo ''
    fi
}

function pod {
    HELP_TEXT='
pod

A utility to print your Kubernetes pod information with concise commands

options:
    l / ls -> List all pods in current namespace
    w      -> Watch all pods in the current namespace
    la     -> List pods in all namespaces
    j      -> List all pods in current namespace in json format
    jl     -> List all pods in json format, pipe to less
    jq     -> List all pods in json format, pipe to jq then less

pattern matching:
    pod <option> <pattern>

watch:
    pod <option> <pattern> w

examples:
    $ pod l
    > show all pods in the current namespace

    $ pod l canary
    > show all pods that have canary in their name

    $ pod l api w
    > watch the list of pods with api in their name

    $ pod w api
    > alias for pod l api w

    $ pod l . w
    > watch the list of all pods in the current namespace

    $ pod w
    > alias for pod l . w

    $ pod jq
    > pretty-prints the JSON description of all pods in the current namespace

    $ pod jq canary
    > pretty-prints the JSON description all pods with the string canary in
    > their name

pod prints the command that will be run to stderr for easy inspection.

Siddharth Kannan 2019 <www.siddharthkannan.in>
    '

    COMMAND=("kubectl get pods")
    
    SUBCOMMAND="$1"
    REGEX="$2"
    WATCH="$3"

    case "$SUBCOMMAND" in
        "h" | "-h" | "--help")
            echo "$HELP_TEXT" >&2
            return
            ;;
        "l" | "ls" | "w")
            COMMAND+=(`selector_string $REGEX`)
            ;;
        "la")
            COMMAND+=("-A")
            COMMAND+=(`selector_string $REGEX`)
            ;;
        "j")
            COMMAND+=("-ojson")
            COMMAND+=(`selector_string_json $REGEX`)
            ;;
        "jl")
            COMMAND+=("-ojson")
            COMMAND+=(`selector_string_json $REGEX`)
			COMMAND+=("| less")
            ;;
        "jq")
            COMMAND+=("-ojson")
            COMMAND+=(`selector_string_json $REGEX`)
			COMMAND+=("| jq -C .")
			COMMAND+=("| less")
            ;;
    esac

    if [[ "$WATCH" == "w" || "$SUBCOMMAND" == "w" ]]; then
        COMMAND="watch '"$COMMAND"'"
    fi

    echo "$COMMAND" >&2
    eval $COMMAND
}
