function dock_hledger () {
    docker run --rm -v "$(pwd):/data" -w /data dastapov/hledger:1.42.1 hledger $@
}

function dock_ledger () {
    docker run --rm -v "$(pwd):/data" -w /data dcycle/ledger:1 $@
}
