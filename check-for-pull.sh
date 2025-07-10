#!/bin/bash

sleep 15
cd /home/pi/chips-client

while :
do
  git remote update
  var="$(git status --branch --porcelain)" 

  if [[ $var =~ "behind" ]]; then
      # PULL NEEDED behavior goes here
      echo "need to pull"
      git pull # SECRET OAUTH TOKEN HERE FOR REPO
      sudo reboot
      # end PULL NEEDED behavior
  else
      # PULL NOT NEEDED
      echo "up to date"
  fi
  sleep 3600
done
