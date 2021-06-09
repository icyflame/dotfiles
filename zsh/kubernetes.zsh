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

alias kns="kubens"

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

# ksetimagecmds outputs the commands that can be used later to revert the
# deployment to the current version
function ksetimagecmds {
    local DEPLOY_NAME=$1
    [ -z "$DEPLOY_NAME" ] && echo "ERROR: Must provide deployment name as the first argument" && return 42
    k get deploy -ojson $DEPLOY_NAME | jq -r '.metadata.name as $name | .["spec"]["template"]["spec"]["containers"][] as $c | "k set image deploy \($name) \($c | .name)=\($c | .image)"'
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
