# Frequent
alias st="stern --exclude-container istio-proxy"
alias sts="stern --exclude-container istio-proxy --since 1s"

function kl {
    PARAM="$1"
    pod l "$PARAM" | col1 | while read p; do
        kubectl logs "$p";
    done
}

function klf {
    PARAM="$1"
    pod l "$PARAM" | head -n1 | col1 | while read p; do
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
        kubens
    else
        kubectl config set-context --current --namespace "$@"
    fi
}

function k {
    kubectl $@
}

function kwhat {
    kubectl config view -ojson | jq '.["current-context"] as $curctx | .contexts[] | select(.name == $curctx) | .context | {cluster,namespace}'
}

functions kdef() {
    kubectl config set-context --current --namespace default
    kwhat
}

## Infrequent
alias kex="kubectl exec -it"
alias klog="kubectl logs -f"

alias kcon="kubectx"
