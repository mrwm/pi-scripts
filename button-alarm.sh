#!/bin/bash
# button-alarm.sh
# Usage: ./button-alarm.sh "$TIME" "$CUSTOM_MESSAGE" $pin1_# $pin2_#
#
# Requires espeak TTS
#
# Written by William Chung (wiiliamchung360@gmail.com)
#

date=$1
c_message=$2
pin1=$3
pin2=$4

if [ -z $pin1 ]; then
  pin1=7
  pin2=1
elif [ -z $pin2 ]; then
  pin2=1
fi

gpio mode $pin1 input
gpio mode $pin2 out
######## BLINK + BUTTON ########
# Loop
while true; do
  mode1=$(gpio read $pin1)
  mode2=$(gpio read $pin2)
  sleep 0.5

  # Check if the button is pressed
  if [ $mode1 -eq 1 ]; then
    : # Do nothing
  elif [ $mode1 -eq 0 ]; then
    echo "PRESSED!"
    exit # Exit the whole script
  fi

  # Switch the LED on/off
  if [ $mode2 -eq 1 ]; then
    gpio write $pin2 0
  elif [ $mode2 -eq 0 ]; then
    gpio write $pin2 1
  fi
done &
############# ALARM ############
if [ -z $@ ]; then
  printf "What time are you setting this alarm for? "
  read date
  printf "Do you want to use a custom message? [y/N] "
  read c_message_yn
  if [ $c_message_yn = "y" ] || [ $c_message_yn = "Y" ]; then
    printf "What would you want me to say? "
    read c_message
  fi
fi

if [ -z $c_message ]; then
  echo "Okay! Will ring you on $(date --date="$date")."
  delay=$( echo $(( $(date --date="$date" +%s) - $(date +%s) )) )
  #echo $delay
  sleep $delay
  echo "Wake up!"
  while true; do
    espeak "wake up" &>/dev/null
    espeak "Wake up" &>/dev/null
    espeak "Wake up" &>/dev/null
    espeak "it is now" &>/dev/null
    h=$(date +%_I)
    espeak $h &>/dev/null
    m=$(date +%M)
    espeak $m &>/dev/null
    sleep 1
  done
fi

echo "Okay! Will ring you on $(date --date="$date")."
delay=$( echo $(( $(date --date="$date" +%s) - $(date +%s) )) )
#echo $delay
sleep $delay
echo "Wake up!"
while true; do
  espeak $c_message &>/dev/null
#  echo $c_message
  sleep 1
done
