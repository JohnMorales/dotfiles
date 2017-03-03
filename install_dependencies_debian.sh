#!/bin/bash
if [ "$EUID" != "0" ]; then
  exec sudo $0
fi
apt-get update
apt-get install -y libssl-dev libreadline-dev zlib1g-dev
