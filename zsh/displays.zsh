function disp-list {
    xrandr | awk '/ connected / { print $1 }'
}

function disp-external-only {
    xrandr --output eDP-1 --off
    xrandr --output DP-1 --auto
}

function disp-external-and-internal {
    xrandr --output eDP-1 --auto
    xrandr --output DP-1 --auto
}

function disp-one-only {
    local selected=$(disp-list | fzf)
	if [[ -z "$selected" ]];
	then
		echo "ERROR: Must select the display that must be turned on."
		return 41
	fi
	disp-only $selected
}

function disp-only {
    local selected=$1
    echo "Turn on: $selected"
    disp-list | while read disp; do
        if [[ "$disp" != "$selected" ]];
        then
            echo "Turn off: $disp"
            xrandr --output $disp --off;
        fi
    done
    xrandr --output $selected --auto;
}
