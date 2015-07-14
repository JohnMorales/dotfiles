#!/bin/bash
default_dev=$(netstat -rnf inet | grep default | awk '{print $6}')
which ipcalc >/dev/null || { echo "please install ipcalc"; exit 1; }
broadcast=$(ifconfig $default_dev | grep broadcast | awk '{ print $2 " " $4}' | xargs ipcalc --nobinary | awk '/Network/ { print $2 }')
sudo nmap -sn $broadcast | awk '/scan report/ { ip = $5; getline;getline; print ip " " $0  }'
