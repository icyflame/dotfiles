# Frequent
alias st="stern --exclude-container istio-proxy"
alias sts="stern --exclude-container istio-proxy --since 1s"

# Shorthands
alias kg="kubectl get"

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

