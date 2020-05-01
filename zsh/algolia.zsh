algolia_monitoring_curl () {
    cluster=${1:-"1"}
    if [[ -n "${cluster}" ]]; then
        shift
    fi

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

    curl \
        -H "X-Algolia-Application-Id: ${application_id}" \
        -H "X-Algolia-API-Key: ${api_key}" $@
}

algolia_inventory () {
    cluster=${1:-"1"}

    echo "## Inventory: Production ${cluster}" >&2

    algolia_monitoring_curl ${cluster} \
        "https://status.algolia.com/1/inventory/servers" $@
    }

algolia_inventory_summary () {
    seq 1 3 | \
        xargs -n 1 -I = echo "algolia_inventory = -s | jq -r '.inventory[].name' | cat -n" | \
        while read p; do eval "$p" 2>&1; done;
}
