#!/bin/bash

if [[ ! $(pgrep -x "openconnect") ]]; then
    sudo openconnect -b --useragent 'AnyConnect' --user=x7lice2@uni-jena.de --pid-file=/var/run/vpn.pid --timestamp --syslog vpn.uni-jena.de
else
    sudo pkill --signal SIGINT openconnect
fi
