alias kgpods="kubectl get pods"
alias pods="kubectl get pods"
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
alias kns="kubens"

alias kdef="kubens default"
