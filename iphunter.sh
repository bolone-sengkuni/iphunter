#!/bin/bash

if [[ -z $1 ]]; then
     echo ""
     echo "Usage: sh iphunter.sh <target IP>"
     echo ""
     echo "Example: sh iphunter.sh 113.211"
     echo ""
     exit 1
fi

echo ""
echo "Checking for AIO panel ..."
busybox wget -q -O /dev/null http://192.168.8.1:8989/cgi-bin/clearlogs.cgi
if [[ $? != 0 ]]; then
     echo ""
     echo "Error: Your modem doesn't have AIO installed!"
     echo ""
     exit 1
fi
echo ""
echo "AIO panel installed."
sleep 2
echo ""

TARGET_IP=$1

i=1
while true; do
    clear
    echo ""
    echo "Target IP : ${TARGET_IP}"
    echo ""
    echo "Starting IP Hunter (try ${i}) ..."
    echo ""
    publicIP=$(busybox wget -qO- ipv4.icanhazip.com)
    HUNT_IP=$(echo $publicIP | busybox cut -d. -f1,2)
    if [[ ${HUNT_IP} == ${TARGET_IP} ]]; then
        echo "Successfully connected to ${publicIP}."
        echo ""
        exit 0
    fi
    echo "Current IP : ${publicIP}"
    echo "Changing IP ..." && busybox wget -q -O /dev/null http://192.168.8.1:8989/cgi-bin/changeip.cgi
    echo "Retrying in 10 seconds ..."
    echo ""
    sleep 10
    i=$((i+1))
done
