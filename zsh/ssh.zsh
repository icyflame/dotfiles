function ssh_knife() {
	if command -v knife >/dev/null 2>&1 && \
			command -v fgrep >/dev/null 2>&1 && \
			command -v fzf >/dev/null 2>&1;
	then ssh $(knife node list | fgrep -v INFO | fzf);
	else echo "ERROR: knife, fgrep, and fzf must be present."
	fi
}
