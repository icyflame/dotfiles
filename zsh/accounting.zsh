function hledger () {
    docker run --rm -v "$(pwd):/data" -w /data dastapov/hledger hledger $@
}

function ledger () {
    docker run --rm -v "$(pwd):/data" -w /data dcycle/ledger:1 $@
}
