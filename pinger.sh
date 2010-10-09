#!/bin/bash

# Seperate by whitespace
HOSTS="192.168.1.1 mc.wearesquareone.com"
PING_COUNT=4
EMAIL="linuxsable@gmail.com"

echo '-- Pinger Running --'

for myHost in $HOSTS
do
  c=$(ping -c $PING_COUNT $myHost | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
  if [ $c -eq 0 ]; then
    # Host is down
    echo "Host: $myHost is down (ping failed) at $(date)"
    echo "Host: $myHost is down (ping failed) at $(date)" | mail -s "ALERT: Host $myHost is down!" $EMAIL
  else
    # Host is up
    echo "Host: $myHost is up"
  fi
done

echo '-- Pinger Done --'