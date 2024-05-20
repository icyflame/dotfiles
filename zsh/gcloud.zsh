function gcauth {
    gcloud auth print-access-token;
    if [ $? -ne 0 ];
    then
        gcloud auth login --update-adc &
    else
        echo "Token valid";
    fi
}

function gcexpiry {
    curl -s -H "Content-Type: application/x-www-form-urlencoded" -d "access_token=$(gcloud auth print-access-token)" https://oauth2.googleapis.com/tokeninfo | jq -r .expires_in
}

function gcr-image-tag {
	local image=$1
	local digest=$2

	if [[ -z "$image" || -z "$digest" ]];
	then
		usage_exit "
ERROR: image-name and digest are required arguments

COMMAND:

	gcr-image-tag image-name digest

EXAMPLE:

	gcr-image-tag gcr.io/cloud-spanner-emulator/emulator cd2bc121ab99
	DIGEST        TAGS   TIMESTAMP
	cd2bc121ab99  1.4.5  2022-09-07T22:35:12
" 43
	fi

	cmd="gcloud container images list-tags $image --filter='digest:$2'"
	echo $cmd
	eval $cmd
}

function gcp-deletion-protection {
	local project=$1
	local regex=$2
	local mode=$3
	local go=$4

	if [[ -z "$project" || -z "$regex" ]];
	then
		echo "ERROR: Project and regex required."
		usage_exit "function gcp-project-name regular-expression-for-instances --check|--disable [--go]" 2
	fi

	local gcloud=$(which gcloud)
	local rg=$(which rg)

	if [[ ! -x $gcloud || ! -x $rg ]];
	then
		echo "ERROR: gcloud and ripgrep (rg) are requirements for this command"
		usage_exit "function gcp-project-name regular-expression-for-instances --check|--disable [--go]" 3
	fi

	local awk_command=''
	case "$3" in
		"--check")
			awk_command='{printf "gcloud compute instances describe %s --zone=%s --project='$project' | rg -w deletionProtection\n", $1, $2}';
			;;
		"--disable")
			awk_command='{printf "gcloud compute instances update %s --zone=%s --no-deletion-protection --project='$project'\n", $1, $2}'
			;;
		"--enable")
			awk_command='{printf "gcloud compute instances update %s --zone=%s --deletion-protection --project='$project'\n", $1, $2}'
			;;
	esac

	if [[ -z "$awk_command" ]];
	then
		echo "ERROR: Usage must be one of --check or --disable"
		return 4
	fi

	gcloud compute instances list --project $project | rg $regex | \
		$(awk_cmd) -n "$awk_command" | \
		while read p; do
			echo $p;
			if [[ "$go" == "--go" ]];
			then
				eval $p;
			else
				echo "[INFO] --go required to exit dry-run mode"
			fi
		done
}
