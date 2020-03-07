alias gmod="GO111MODULE=on go"

alias gmv="GO111MODULE=on go mod vendor"

function go13 {
    docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app golang:1.13 $@
}

function go12 {
    docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app golang:1.12 $@
}

function go11 {
    docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app golang:1.11 $@
}

function go10 {
    docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app golang:1.10 $@
}

function print_go_version {
    echo
    echo "---"
    echo "$@"
    echo "---"
    echo
}

function goeval {
    cmd=$*

    print_go_version "# Go 1.10"
    eval go10 $cmd

    print_go_version "# Go 1.11"
    eval go11 $cmd

    print_go_version "# Go 1.12"
    eval go12 $cmd

    print_go_version "# Go 1.13"
    eval go13 $cmd
}
