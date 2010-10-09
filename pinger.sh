#!/bin/bash
#
# Author: @_ty
#
# Enjoy!

# Seperate by whitespace
HOSTS="127.0.0.1 google.com"
EMAIL="test@example.com"
PING_COUNT=4

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