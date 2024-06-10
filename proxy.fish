#!/usr/bin/env fish

set hostip (grep nameserver /etc/resolv.conf | awk '{ print $2 }')
set wslip (hostname -I | awk '{print $1}')
set port 7890

set PROXY_HTTP "http://$hostip:$port"

function setProxy
    export http_proxy="$PROXY_HTTP"
    export HTTP_PROXY="$PROXY_HTTP"
    export https_proxy="$PROXY_HTTP" 
    export HTTPS_PROXY="$PROXY_HTTP"
    export ALL_PROXY="$PROXY_HTTP"
    export all_proxy="$PROXY_HTTP"

    git config --global http.https://github.com.proxy "$PROXY_HTTP"
    git config --global https.https://github.com.proxy "$PROXY_HTTP"

    echo "Proxy has been set."
end

function unsetProxy
    set --erase http_proxy
    set --erase HTTP_PROXY
    set --erase https_proxy
    set --erase HTTPS_PROXY
    set --erase ALL_PROXY
    set --erase all_proxy

    git config --global --unset http.https://github.com.proxy
    git config --global --unset https.https://github.com.proxy

    echo "Proxy has been unset."
end

function debugProxy
    echo "Host IP: $hostip"
    echo "WSL IP: $wslip"
    echo "proxy: $PROXY_HTTP"
    echo "Try to connect to Google..."
    set resp (curl -I -s --connect-timeout 5 -m 5 -w "%{http_code}" -o /dev/null www.google.com)
    if [ "$resp" = 200 ]
        echo "Proxy setup succeeded!"
    else
        echo "Proxy setup failed!"
    end
end

if [ "$argv[1]" = "set" ]
    setProxy
else if [ "$argv[1]" = "unset" ]
    unsetProxy
else if [ "$argv[1]" = "debug" ]
    debugProxy
else
    echo "Unsupported arguments."
end
