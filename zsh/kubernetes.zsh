# Frequent
alias st="stern --exclude-container istio-proxy"
alias sts="stern --exclude-container istio-proxy --since 1s"

function stj {
    sts -ojson "$1" | jq -c '.message | fromjson?'
}

function ste {
    sts -ojson "$1" | jq -c '.message | fromjson? | select((.level | ascii_downcase) == "error")'
}

function sti {
    sts -ojson "$1" | jq -c '.message | fromjson? | select((.level | ascii_downcase) == "info")'
}

function kl {
    PARAM="$1"
    kr pod l "$PARAM" | col1 | while read p; do
        kubectl logs "$p";
    done
}

function klf {
    PARAM="$1"
    kr pod l "$PARAM" | head -n1 | col1 | while read p; do
        kubectl logs -f "$p";
    done
}

function kg {
    PARAM="$@"
    if [[ "$PARAM" == "" ]]; then
        kubectl get all
    else
        kubectl get "$@"
    fi
}

function kns {
    PARAM="$@"
    if [[ "$PARAM" == "" ]]; then
        kubectl config set-context --current --namespace $(kubectl get ns | gawk 'NR != 1 { print $1 }' | fzf)
    else
        kubectl config set-context --current --namespace "$@"
    fi
}

# Alias based namespace switching
# Eg: kns_alias_based dev app-dev prod app-prod
# -> check the current context's local name
# -> if dev then switch to app-dev
# -> if prod then switch to app-prod
# -> if neither print an error message and exit
function kns_alias_based {
    DEV_ALIAS="$1"
    DEV_NS="$2"
    PROD_ALIAS="$3"
    PROD_NS="$4"

    ALIAS=`kwhat | jq -r '.alias'`

    if [[ "$ALIAS" == "$DEV_ALIAS" ]]; then
        kns "$DEV_NS"
    elif [[ "$ALIAS" == "$PROD_ALIAS" ]]; then
        kns "$PROD_NS"
    else
        echo "unrecognized alias: $ALIAS"
        exit 42
    fi

    kwhat
}

function k {
    kubectl $@
}

function kwhat {
    kubectl config view -ojson | jq '.["current-context"] as $curctx | .contexts[] | select(.name == $curctx) | .context | {alias:$curctx,cluster,namespace}'
}

functions kdef() {
    kubectl config set-context --current --namespace default
    kwhat
}

## Infrequent
alias kex="kubectl exec -it"
alias klog="kubectl logs -f"

alias kcon="kubectx"
