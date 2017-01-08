#!/bin/bash
#
# gio-blink.sh
#
# Usage: ./gpio-button.sh $pin_#
# If pin_# is not specified, it will default to pin 7
#
# Written by William Chung (wiiliamchung360@gmail.com)
#

pin=$1
if [ -z $1 ]; then
  pin=7
fi

gpio mode $pin input

# Loop
while true; do
  mode=$(gpio read $pin)
  sleep 1
  if [ $mode -eq 1 ]; then
    echo "Not pressed"
  elif [ $mode -eq 0 ]; then
    echo "PRESSED!"
  fi
done
