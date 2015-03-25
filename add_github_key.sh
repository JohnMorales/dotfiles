#!/bin/bash
[ -f ~/.ssh/id_rsa.pub ] || ssh-keygen -q -f ~/.ssh/id_rsa -N ''
read -p "github username? " username
read -p "github password? " password
curl -u "$username:$password" --data "$(awk '{ printf("{\042title\042:\042%s\042, \042key\042: \042%s\042 }", $3, $0);} ' ~/.ssh/id_rsa.pub)" https://api.github.com/user/keys
