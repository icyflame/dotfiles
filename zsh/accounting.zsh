function dock_hledger () {
    docker run --rm -v "$(pwd):/data:ro" -w /data dastapov/hledger:1.42.1 hledger $@
}

function dock_ledger () {
    docker run --rm -v "$(pwd):/data:ro" -w /data dcycle/ledger:1 $@
}
