#!/bin/bash
#
# gio-blink.sh
#
# Start blinking an LED at pin 1 until a button
# connected to pin 7 is pressed
#
# Usage: ./gpio-button-blink.sh $pin1_# $pin2_#
# If no arguments are passed, $pin1 will default to
# pin 7 and $pin2 will default to pin 1
#
# Written by William Chung (wiiliamchung360@gmail.com)
#

pin1=$1
pin2=$2
if [ -z $1 ]; then
  pin1=7
  pin2=1
elif [ -z $2 ]; then
  pin2=1
fi

gpio mode $pin1 input
gpio mode $pin2 out

# Loop
while true; do
  mode1=$(gpio read $pin1)
  mode2=$(gpio read $pin2)
  sleep 1

  # Check if the button is pressed
  if [ $mode1 -eq 1 ]; then
    : # Do nothing
  elif [ $mode1 -eq 0 ]; then
    echo "PRESSED!"
    break
  fi

  # Switch the LED on/off
  if [ $mode2 -eq 1 ]; then
    gpio write $pin2 0
  elif [ $mode2 -eq 0 ]; then
    gpio write $pin2 1
  fi
done
