# function for long running commands
# run as `long git push origin --all`
function long {
	eval $@;
	# echo "This command was executed"
	notify-send -t 2000 --urgency=low -i "terminal" "$@ done!"
}

