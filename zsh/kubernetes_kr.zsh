function selector_string {
    if [[ "$@" != "" ]]; then
        echo '| grep --color=never '"$@"
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

function kr {
    HELP_TEXT='
kr

A utility to print your Kubernetes resource information with concise commands

usage:
    kr [resource] [command] [pattern] [w]

    command options
        l / ls -> List all resources in current namespace
        w      -> Watch all resources in the current namespace
        la     -> List resources in all namespaces
        j      -> List all resources in current namespace in json format
        jl     -> List all resources in json format, pipe to less
        jq     -> List all resources in json format, pipe to jq then less

    resource options
        pod, rs, deployments, hpa, cronjobs, secrets, all

        You can get the list of all resources using kubectl api-resources

    pattern options
        you can provide text or regular expressions. be careful about the way
        your shell handles quotation marks

examples:
    $ kr pod l
    > show all pods in the current namespace

    $ kr pod l canary
    > show all pods that have canary in their name

    $ kr deployments l api w
    > watch the list of deployments with api in their name

    $ kr pod w api
    > alias for pod l api w

    $ kr pod l . w
    > watch the list of all pods in the current namespace

    $ kr pod w
    > alias for pod l . w

    $ kr pod jq
    > pretty-prints the JSON description of all pods in the current namespace

    $ kr pod jq canary
    > pretty-prints the JSON description all pods with the string canary in
    > their name

kr prints the command that will be run to stderr for easy inspection.

Siddharth Kannan 2019 <www.siddharthkannan.in>
    '

    COMMAND=("kubectl get --no-headers")
    
    RESOURCE="$1"
    SUBCOMMAND="$2"
    REGEX="$3"

    COMMAND+=("$1")

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

    if [[ "$SUBCOMMAND" == "w" ]]; then
        COMMAND="watch '"$COMMAND"'"
    fi

    echo "$COMMAND" >&2
    eval $COMMAND
}
