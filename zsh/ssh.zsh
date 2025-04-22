function ssh_knife() {
	local ssh_user=$1
	if command -v knife >/dev/null 2>&1 && \
			command -v fgrep >/dev/null 2>&1 && \
			command -v fzf >/dev/null 2>&1;
	then
		selected_host=$(knife node list | fgrep -v INFO | fzf);
		echo "SSH to $selected_host" >/dev/stderr;
		if [ -n "$ssh_user" ];
		then
			echo "SSH as $ssh_user" >/dev/stderr;
			ssh $ssh_user@$selected_host;
		else
			ssh $selected_host;
		fi
	else echo "ERROR: knife, fgrep, and fzf must be present."
	fi
}
