#!/bin/bash

printf "\n\n--Welcome to Minecraft Auto Setup--\n\n"

read -p "Would you like to install required packages? [y/N]" pk
case $pk in [Yy]* )
    sudo apt install -y git build-essential openjdk-17-jre-headless; break;;
esac

printf "Creating Minecraft user..."

useradd -r -m -U -d /opt/minecraft -s /bin/bash minecraft || true

sudo cp ./minecraft.service /etc/systemd/system/minecraft.service

sudo su -c 'sh ./minecraft_user_scripts.sh' minecraft

read -p "Enter a password for RCON. Please chose a sufficiently secure password" rconpw

sudu cp server.properties.setup server.properties
sudo chgrp sudo server.properties
sudo chmod 660 server.properties

sudo echo 'rcon.password=$rconpw' >> server.properties

sudo -s -- <<-EOF
    cp server.properties /opt/minecraft/server/
    chown minecraft /opt/minecraft/server/server.properties

    ufw allow 25565/tcp
EOF

read -p "Would you like to enable and start Minecraft? [y/N]" en
case $en in [Yy]* )
    sudo -s -- <<-EOF
    systemctl enable minecraft
    systemctl start minecraft
EOF
esac