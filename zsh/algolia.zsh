# Basic curl command
algolia_monitoring_curl () {
    cluster=${1:-"1"}
    shift

    case "${cluster}" in
        "2" | "prod2")
            application_id="${ALGOLIA_PROD2_APP_ID}"
            api_key="${ALGOLIA_PROD2_MONITORING_KEY}"
            ;;
        "3" | "prod3")
            application_id="${ALGOLIA_PROD3_APP_ID}"
            api_key="${ALGOLIA_PROD3_MONITORING_KEY}"
            ;;
        "4" | "prod4")
            application_id="${ALGOLIA_PROD4_APP_ID}"
            api_key="${ALGOLIA_PROD4_MONITORING_KEY}"
            ;;
        "5" | "prod5")
            application_id="${ALGOLIA_PROD5_APP_ID}"
            api_key="${ALGOLIA_PROD5_MONITORING_KEY}"
            ;;
        *)
            application_id="${ALGOLIA_PROD_APP_ID}"
            api_key="${ALGOLIA_PROD_MONITORING_KEY}"
            ;;
    esac

    curl -s \
        -H "X-Algolia-Application-Id: ${application_id}" \
        -H "X-Algolia-API-Key: ${api_key}" $@
}

# API methods without logic
algolia_inventory () {
    cluster=${1:-"1"}
    shift

    echo "## Inventory: Production ${cluster}" >&2

    algolia_monitoring_curl ${cluster} \
        "https://status.algolia.com/1/inventory/servers" $@
    }

algolia_status () {
    cluster=${1:-"1"}
    if [[ -n "${1}" ]];
    then
        shift
    fi

    algolia_monitoring_curl "${cluster}" \
        -s "https://status.algolia.com/1/status" $@
}

# Functions that make the API calls and accumulate logic together
algolia_incidents () {
    cluster=${1:-"1"}

    algolia_status "${cluster}" | \
        jq -r '.status | keys | .[]' | \
        paste -d ',' $(seq 1 5 | while read p; do echo -n "- "; done;) | \
        gsed -e "s/,+$//g" | \
        xargs -n 1 -I {} echo "algolia_monitoring_curl \"${cluster}\" \"https://status.algolia.com/1/incidents/{}\"" | \
        while read p;
        do
            eval "$p";
        done | jq --slurp .

    }

# Summary methods
algolia_inventory_summary () {
    seq 1 5 | \
        xargs -n 1 -I = echo "algolia_inventory = -s | jq -r '.inventory[].name' | cat -n" | \
        while read p; do eval "$p" 2>&1; done;
}

algolia_status_summary () {
    MODE=${1}
    STATUS_SUMMARY=$(seq 1 3 | \
        xargs -n 1 -I = echo "algolia_status = -s | jq ." | \
        while read p; do eval "$p" 2>&1; done | jq --slurp .)

    if [[ "$MODE" == "-v" ]];
    then
        echo $STATUS_SUMMARY
    fi

    SERVER_STATUS_ARRAY=$(echo -n $STATUS_SUMMARY | \
        jq -c '[ .[].status | . as $v | (. | keys) as $k | reduce $k[] as $key ( [ ] ; . + [ [ $key, $v[$key] ] ] ) ]')

    echo "## Operational"
    echo -n "$SERVER_STATUS_ARRAY" | jq -r '.[] | .[] | @tsv' | tsv-filter --str-eq 2:operational | tsv-pretty
    echo "## Not operational"
    echo -n "$SERVER_STATUS_ARRAY" | jq -r '.[] | .[] | @tsv' | tsv-filter --str-ne 2:operational | tsv-pretty
}
