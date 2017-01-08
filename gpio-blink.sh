#!/bin/bash
#
# gio-blink.sh
#
# Usage: ./gpio-blink.sh $pin_#
# If pin_# is not specified, it will default to pin 1
#
# Written by William Chung (wiiliamchung360@gmail.com)
#

pin=$1
if [ -z $1 ]; then
  pin=1
fi

gpio mode $pin out

# Loop
while true; do
  mode=$(gpio read $pin)
  sleep 1
  if [ $mode -eq 1 ]; then
    gpio write $pin 0
  elif [ $mode -eq 0 ]; then
    gpio write $pin 1
  fi
done
