# proxy for KGP
if [ $KGP ]; then
  PROXY_STRING="http://172.16.2.30:8080"
  export no_proxy="$no_proxy,10.0.0.0/8"
  export NO_PROXY="$NO_PROXY,10.0.0.0/8"
  echo "LOCAL: Importing KGP proxy settings"
else
  PROXY_STRING=""
  echo "LOCAL: Direct connection to the Internet"
fi
export http_proxy="$PROXY_STRING"
export https_proxy="$PROXY_STRING"
export HTTP_PROXY="$PROXY_STRING"
export HTTPS_PROXY="$PROXY_STRING"
export ALL_PROXY="$PROXY_STRING"
export all_proxy="$PROXY_STRING"
export ftp_proxy="$PROXY_STRING"
export socks_proxy="$PROXY_STRING"
