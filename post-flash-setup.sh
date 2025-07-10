#!/usr/bin/env bash

#change password
passwd

#enable ssh
sudo systemctl enable ssh
sudo systemctl start ssh

#run WiFi Connect setup script (REQUIRES ETHERNET)
chmod u+x /home/pi/chips-client/src/scripts/wifi/setup-wifi-connect.sh
yes | ./home/pi/chips-client/src/scripts/wifi/setup-wifi-connect.sh
#move WiFi Connect on-boot files
cp /home/pi/chips-client/src/scripts/wifi/curl_files/start-wifi-connect.sh /home/pi
sudo cp /home/pi/chips-client/src/scripts/wifi/curl_files/wifi-connect-start.service /etc/systemd/system
#make WiFi Connect on-boot script executable
chmod u+x /home/pi/start-wifi-connect.sh
#enable on-boot WiFi Connect
sudo systemctl enable wifi-connect-start.service

#install mosquitto
sudo apt-get update
sudo apt-get install -y mosquitto mosquitto-clients
#enable on-boot mosquitto
sudo systemctl enable mosquitto.service
sudo systemctl start mosquitto.service

#install required packages for docker
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
#install docker
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
     $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install -y --no-install-recommends docker-ce cgroupfs-mount
#enable on-boot docker
sudo systemctl enable docker
sudo systemctl start docker

#install docker-compose
sudo apt-get update
sudo apt-get install -y python3-pip libffi-dev
sudo pip3 install docker-compose
#run docker-compose up
(cd /home/pi/chips-client/ && sudo docker-compose up -d)

#setup chips client
pip3 install paho-mqtt pygatt pexpect
cp /home/pi/chips-client/examples/entry.py chips-client/src
sudo cp /home/pi/chips-client/src/scripts/chips-client-start.service /etc/systemd/system
#enable on-boot chips client
sudo systemctl enable chips-client-start.service

#make scripts executable
chmod u+x /home/pi/chips-client/src/scripts/check-for-pull.sh
chmod u+x /home/pi/chips-client/src/scripts/on-boot.sh
sudo cp /home/pi/chips-client/src/scripts/on-boot-start.service /etc/systemd/system
sudo systemctl enable on-boot-start.service

#set git credentials with oauth token
(cd /home/pi/chips-client/ && git remote set-url origin #SECRET OAUTH TOKEN HERE FOR REPO# )

#unplug ethernet and reboot. WiFi Connect should run on boot
