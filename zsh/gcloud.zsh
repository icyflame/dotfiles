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
