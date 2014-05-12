#!/bin/bash
#Filename: proxycheck.sh
#Purpose: Simple Proxy Checker

echo "Welcome to $0, a simple proxy checker"
echo "Enter the name of the proxy list file to use"
echo "The proxies should be in IP:PORT format"
read list
resultfile=goodproxies$(date "+%m%d%y%H%M%S").txt
failurefile=badproxies$(date "+%m%d%y%H%M%S").txt
touch $resultfile
touch $failurefile

echo "Checking proxies from the list file $list"
for i in $(cat $list)
do
    results=$(curl -fsx $i google.com &) 
    shift #multi-threading
    if  [ -z "$results" ]
    then
        echo $i >> $failurefile
    else
        echo $i >> $resultfile
    fi
done
wait 
echo "Finished after $SECONDS seconds"
echo "Good proxies written to $resultfile"
echo "Bad proxies written to $failurefile"

echo "Do you want to open the good proxies list file?"
select yn in "Yes" "No"
do
    case $yn in
        Yes ) xdg-open $resultfile; break;;
        No ) exit;;
    esac
done
