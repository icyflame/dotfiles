function gcauth {
    gcloud auth print-access-token;
    if [ $? -ne 0 ];
    then
        gcloud auth login --update-adc &
    else
        echo "Token valid";
    fi
}
