alias gmod="GO111MODULE=on go"

alias gmv="GO111MODULE=on go mod vendor"

function go13 {
    docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app golang:1.13 $@
}
