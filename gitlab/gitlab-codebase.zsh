# gitlab-codebase-find-commit
#
# List the auto-deploy branches that contain a given commit hash
#
# $ g branch --list --all | rg -F security | rg -F auto-deploy | while read branch;
# do
# 	git log --pretty=format:'%H' $branch | rg -q -F cbabf140639be4ea964781fdb45946ae6f8e0856;
# 	[[ $? -ne 0 ]] && return 2 || echo "$branch";
# done | tail -1
# remotes/security/17-10-auto-deploy-2025022100
# [snip]
# tail -1  0.00s user 0.00s system 0% cpu 10.325 total
gitlab-codebase-find-commit() {
	COMMIT="$1"
	if [[ -z "$COMMIT" ]];
	then
		echo "ERROR: Must specify COMMIT"
		echo "  gitlab-codebase-find-commit COMMIT"
		echo "  gitlab-codebase-find-commit bb3a6eb3c78ce2e2b4773a89e11357d6c554aaf9"
		return 42
	fi

	REMOTE="security"
	g branch --list --all | rg -F $REMOTE | rg -F auto-deploy | while read branch;
	do
		git log --pretty=format:'%H' $branch | rg -q -F $COMMIT;
		[[ $? -ne 0 ]] && return 2 || echo "$branch";
	done
}
