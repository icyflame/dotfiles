alias kgpods="kubectl get pods"
alias pods="kubectl get pods"
alias podj="kubectl get pods -ojson | jqcl"
alias podw="watch kubectl get pods"

alias kgsvc="kubectl get services"

alias kgpod="kubectl get pod -o json"
alias kgsvc="kubectl get service -o json"

alias kdpod="kubectl describe pod"
alias kdsvc="kubectl describe service"

alias kex="kubectl exec -it"

alias klog="kubectl logs -f"

alias kst="stern --exclude-container istio-proxy --since 1s"

alias kg="kubectl get"

alias st="stern --exclude-container istio-proxy"
alias sts="stern --exclude-container istio-proxy --since 1s"

alias kcon="kubectx"

function kns() {
    PARAM="$@"
    if [[ "$PARAM" == "" ]]; then
        kubens
    else
        kubectl config set-context --current --namespace "$@"
    fi
}

function k() {
    kubectl $@
}

function kwhat() {
    kubectl config view -ojson | jq '.["current-context"] as $curctx | .contexts[] | select(.context.cluster == $curctx) | .context | {cluster,namespace}'
}

functions kdef() {
    kubectl config set-context --current --namespace default
    kwhat
}

