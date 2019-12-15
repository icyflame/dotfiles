function get_ip_details {
    curl -s "https://ifconfig.co/json" | jq .
}
