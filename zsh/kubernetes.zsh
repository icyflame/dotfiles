# Frequent
alias st="stern --exclude-container istio-proxy"
alias sts="stern --exclude-container istio-proxy --since 1s"

function stj {
    sts -ojson "$@" | jq -c '.message | fromjson?'
}

function ste {
    sts -ojson "$@" | jq -c '.message | fromjson? | select((.level | ascii_downcase) == "error")'
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

alias _kns="kubens"

function kns () {
    kubens 2>/dev/null $(kubectl 2>/dev/null get ns | awk 'NR != 1 { print $1 }' | fzf)
}

# kns_alias_based
#
# Context based namespace switching
# Usage: kns_alias_based dev app-dev prod app-prod dev-2 app-dev-2 [ctx ns]
#
# Even number of arguments must be provided to this function. Each pair of
# arguments that are provided are interpreted as context namespace pairs, with
# the namespace that you want to switch to, depending on the Kubernetes context
# that you are in.
#
# Example:
# -> check the current context's local name
# -> if dev then switch to app-dev
# -> if prod then switch to app-prod
# -> if neither print an error message and exit
function kns_alias_based {
    local current=`kwhat | jq -r '.alias'`
    _kns_alias_based_in_alias 0 "$current" $@
}

# _kns_alias_based_in_alias
#
# Internal function. End users should use the wrapper function kns_alias_based.
#
# This function is recursive but has a variable to put a limit on the amount of
# recursion.
function _kns_alias_based_in_alias {
    local level="$1"
    shift;

    if [[ $level -gt 10 ]];
    then
        echo "ERROR: Too many levels of recursion"
        return 41
    fi

    local current="$1"
    shift;

    if [[ $# -eq 0 ]];
    then
        echo "ERROR: No namespace provided for current context: $current"
        return 42
    fi

    local context="$1"
    shift;
    if [[ -z "$context" ]];
    then
        echo "ERROR: Empty context argument"
        return 43
    else
        local namespace="$1"
        shift;
        if [[ -z "$namespace" ]];
        then
            echo "ERROR: Namespace empty for current context"
            return 44
        fi

        if [[ "$context" == "$current" ]];
        then
            _kns "$namespace"
            kwhat
            return 0
        else
            _kns_alias_based_in_alias $(($level+1)) $current $@
        fi
    fi
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

# ksetimagecmds outputs the commands that can be used later to revert the
# deployment to the current version
function ksetimagecmds {
    local DEPLOY_NAME=$1
    [ -z "$DEPLOY_NAME" ] && echo "ERROR: Must provide deployment name as the first argument" && return 42
    k get deploy -ojson $DEPLOY_NAME | jq -r '.metadata.name as $name | .["spec"]["template"]["spec"]["containers"][] as $c | "k set image deploy \($name) \($c | .name)=\($c | .image)"'
}

# kshowrevisions outputs the current revisions of the given deployment or all
# deployments in the current namespace if no argument is given
#
# This number is useful for reverting a rollout using:
# kubectl rollout undo deployment/some-deployment --to-revision=<number>
function kshowrevisions {
    local DEPLOY_NAME=$1
    if [[ -z "$DEPLOY_NAME" ]];
    then
        k get deployment -o json | jq '.items[] | .metadata | [.name, .annotations["deployment.kubernetes.io/revision"]] | @tsv' -r | expand -t10
    else
        k get deployment -o json $DEPLOY_NAME | jq '.metadata | [.name, .annotations["deployment.kubernetes.io/revision"]] | @tsv' -r | expand -t10
    fi
}

## Infrequent
alias kex="kubectl exec -it"
alias klog="kubectl logs -f"

alias kcon="kubectx"

# Functions using kubectl-fzf
# https://github.com/at-ishikawa/kubectl-fzf

function kportforward {
    kubectl fzf "$1" | xargs -I{} kubectl port-forward $1/{} 9000:9000
}

function kshowsecret-filtered  {
    SECRET_NAME=$(kr secrets l $1 | head -1 | col1)
    echo "Secret $SECRET_NAME:"
    k get secrets $SECRET_NAME -o jsonpath="{.data}" | jq -r 'keys[] as $k | "\($k)=''\(.[$k]|@base64d|.[0:4])[FILTERED]''"'
}

function kshowsecret {
    SECRET_NAME=$(kr secrets l $1 | head -1 | col1)
    echo "Secret $SECRET_NAME:"
    k get secrets $SECRET_NAME -o jsonpath="{.data}" | jq -r 'keys[] as $k | "\($k)=''\(.[$k]|@base64d)''"'
}
