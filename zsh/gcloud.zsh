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
		cat <<EOF
ERROR: image-name and digest are required arguments

COMMAND:

	gcr-image-tag image-name digest

EXAMPLE:

	gcr-image-tag gcr.io/cloud-spanner-emulator/emulator cd2bc121ab99
	DIGEST        TAGS   TIMESTAMP
	cd2bc121ab99  1.4.5  2022-09-07T22:35:12
EOF
		return 43
	fi

	cmd="gcloud container images list-tags $image --filter='digest:$2'"
	echo $cmd
	eval $cmd
}
