Steps to setup WiFi Connect on Raspberry Pi with auto-run on boot (if no wifi connection)

- Downloading and installing Wifi-Connect. Run in pi terminal (equivalent to running setup-wifi-connect.sh script):
    bash <(curl -L https://github.com/balena-io/wifi-connect/raw/master/scripts/raspbian-install.sh)
- Copy contents of curl_files directory:
    - Copy start-wifi-connect.sh to /home/pi
    - Copy wifi-connect-start.service to /etc/systemd/system
- Making start-wifi-connect.sh executable. Run in pi terminal:
    sudo chmod +x /home/pi/start-wifi-connect.sh
- Enabling wifi-connect-start.service boot service. Run in pi terminal:
    sudo systemctl enable wifi-connect-start.service

WiFi Connect should now run on boot if the Pi is not already connected to a network.