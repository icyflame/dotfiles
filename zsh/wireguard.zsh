# wgi
#
# Print the currently active wireguard interface for inspection
#
# Output: "client-aws" with return code 0 OR "" with return code 43
function wgi {
    INTERFACE=$(sudo wg | head -1 | awk -F': ' '{ print $2 }') && [ -n "$INTERFACE" ] && echo "$INTERFACE" || return 43
}

function switch-wg {
    set -x
    local final=$1
	if [[ -z $final ]];
	then
		echo "ERROR: Must provide interface name as first argument"
		return 42
	fi
	local current=$(wgi)
    if [[ -n $current ]];
    then
        sudo systemctl stop wg-quick@$current
    fi
    sudo systemctl start wg-quick@$final
}

function stop-wg {
    set -x
    if [[ -n $(wgi) ]];
    then
        sudo systemctl stop wg-quick@$(wgi)
    else
        return 43
    fi
}
