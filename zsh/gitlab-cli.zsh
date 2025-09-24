pipeline-get-command () {
	local url=$1;
	[[ -z "$url" ]] && echo "ERROR: URL must be provided" >&2 || \
			echo "$url" | perl -lane 'm!(https://.+?)/(.+)/-/pipelines/(.+)! && print "GITLAB_HOST=\"$1\" glab pipeline get --repo $2 --pipeline-id $3"'
}

glab-wait-for-pipeline () {
	# https://ops.gitlab.net/gitlab-com/gl-infra/k8s-workloads/gitlab-com/-/pipelines/4697472
	local url=$1;
	if [[ -z "$url" ]];
	then
		echo "ERROR: Pipeline URL must be supplied as an argument.";
		return 43;
	fi

	local attempts=${2:-10}
	local interval=${3:-10}

	if [[ -z "$GITLAB_TOKEN" ]];
	then
		echo "ERROR: GITLAB_TOKEN must be set to a Personal access token for the appropriate environment";
		return 43;
	fi

	if [[ $(command -v perl >/dev/null) && $? -eq 0 ]];
	then
		echo "ERROR: Perl is required";
		return 43;
	fi

	local command=$(pipeline-get-command "$url")
	echo $command

	if [[ $(command -v glab >/dev/null) && $? -eq 0 ]];
	then
		echo "ERROR: GitLab CLI (glab) is required" && return 43;
	fi

	local pipeline_status_command="$command --output json | jq -r '.status'"

	echo "Checking pipeline status: $attempts attempts at $interval second interval";

	for i in `seq 1 $attempts`; do
		local pipeline_status=$(eval $pipeline_status_command 2>/dev/null)
		if [[ "$pipeline_status" == "success" ]];
		then
			local msg="Pipeline is complete."
			command -v notify-send >/dev/null && notify-send "$msg" || echo "$msg"
			return 0;
		else
			echo "$(date): Pipeline is in status \"$pipeline_status\" ..." >&2;
		fi

		sleep $interval;
	done

	local msg="Pipeline is still running: Polling expired. Try again!"
	command -v notify-send >/dev/null && notify-send "$msg" || echo "$msg"

	return 44;
}

glab-mr-get-command () {
	local url=$1;
	[[ -z "$url" ]] && echo "ERROR: URL must be provided" >&2 || \
			echo "$url" | perl -MURI::Escape -lane 'm!(https://.+?)/(.+)/-/merge_requests/(.+)! && print "GITLAB_HOST=\"$1\" glab api \"/projects/" . uri_escape($2) . "/merge_requests/$3\""'
}

glab-mr-merge-commit () {
	local mr_url=$1;
	command=$(glab-mr-get-command "$mr_url")
	commit_sha=$(eval $command | jq -r '.merge_commit_sha')
	if [[ $commit_sha == "null" ]];
	then
		echo "ERROR: MR has not been merged yet, so merge commit does not exist" >&2
	fi

	echo "$commit_sha"
}

glab-check-commit-contains-mr () {
	local commit=$1;
	while true; do
		shift;
		mr=$1;
		if [[ -z $mr ]];
		then
			echo "Done."
			return
		fi

		merge_commit=$(glab-mr-merge-commit "$mr")
		git log --pretty=format:'%H' "$commit" | grep -F -q -e "$merge_commit"
		direct_hit=$?

		cherry_picked_hit=-1
		if [[ $direct_hit -ne 0 ]];
		then
			git log "$commit" | grep -F -q -e "(cherry picked from commit $merge_commit)"
			cherry_picked_hit=$?
		fi

		if [[ $direct_hit -eq 0 || $cherry_picked_hit -eq 0 ]];
		then
			echo -n "INFO: $commit contains $mr (merge commit $merge_commit)"
			if [[ $direct_hit -eq 0 ]];
			then
				echo " (direct)"
			else
				echo " (cherry picked)"
			fi
		else
			echo "ERROR: $commit does not contain $mr (merge commit $merge_commit)";
		fi
	done
}
