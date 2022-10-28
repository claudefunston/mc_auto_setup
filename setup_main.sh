#!/bin/bash

printf "\n\n--Welcome to Minecraft Auto Setup--\n\n"

read -p "Would you like to install required packages? [y/N]" pk
case $pk in [Yy]* )
    sudo apt update
    sudo apt install -y build-essential
    sudo apt install -y git 
    sudo apt install -y openjdk-17-jre-headless; break;;
esac

printf "\nCreating Minecraft user...\n"

useradd -r -m -U -d /opt/minecraft -s /bin/bash minecraft || true

sudo cp ./minecraft.service /etc/systemd/system/minecraft.service

sudo su -c 'sh ./minecraft_user_scripts.sh' minecraft

printf "\n"

read -p "Enter a password for RCON. 

Please chose a sufficiently secure value: 

" rconpw

sudo -s -- <<-EOF
    cp server.properties.initial server.properties
    chgrp sudo server.properties
    chmod 660 server.properties

    echo "rcon.password=$rconpw" >> server.properties

    echo "eval export MCRCON_PASS=$rconpw" > vars
    echo "eval alias mcrcon=/opt/minecraft/tools/mcrcon/mcrcon" >> vars

    cp server.properties /opt/minecraft/server/
    chown minecraft /opt/minecraft/server/server.properties
EOF

read -p "Would you like to enable and start Minecraft? [y/N]" en
case $en in [Yy]* )
    sudo -s -- <<-EOF
    systemctl enable minecraft
    systemctl start minecraft
EOF
esac