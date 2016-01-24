#!/bin/bash
if [ "$EUID" != "0" ]; then
  exec sudo $0
fi
yum install -y gcc git openssl-devel readline-devel zlib-devel
