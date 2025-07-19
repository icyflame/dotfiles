# Document: https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration

# Once all computers have a new enough version of fzf, we will not need the fzf.zsh-completion and
# fzf.zsh-keybindings file. We can just use `fzf --zsh` instead.

# The version of fzf on Debian 11 is 0.24 and Debian 12 is 0.38. So, Debian is still using quite an
# old version of fzf.

if command -v fzf >/dev/null 2>&1;
then
	if fzf --zsh >/dev/null 2>&1;
	then
		# Version of fzf which are newer than 0.48.0 support this.
		source <(fzf --zsh)
	else
		if [[ "$(uname)" == "Linux" ]];
		then
			# The path to these files was given inside the document that is listed at
			# =apt show fzf=. The package documentation can be fetched using different
			# commands depending on the distribution that you are using.
			[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
			[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
		fi

		if [[ "$(uname)" == "Darwin" ]];
		then
			# The path to these files depends on where the package fzf was installed by
			# Homebrew. The path can be found through =brew info fzf=.
			[ -f "/opt/homebrew/opt/fzf/shell/completion.zsh" ] && source "/opt/homebrew/opt/fzf/shell/completion.zsh"
			[ -f "/opt/homebrew/opt/fzf/shell/key-bindings.zsh" ] && source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
		fi

	fi
else
	echo "Fzf does not exist"
fi
