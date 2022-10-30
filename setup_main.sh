#!/bin/bash

# Functions
write_aliases() {
    mcrcon_var="export MCRCON_PASS=$2"
    mcrcon_alias="alias mcrcon=/opt/minecraft/tools/mcrcon/mcrcon"

    if [ ! -f "$1" ]; then
        touch "$1"
    fi
    
    grep -qxF "$mcrcon_alias" "$1" || echo "$mcrcon_alias" >> "$1"
    grep -qxF "$mcrcon_var" "$1" || echo "$mcrcon_var" >> "$1"
}

printf "\n\n--Welcome to Minecraft Auto Setup--\n\n"

read -p "Would you like to install required packages? [y/N]" pk
case $pk in [Yy]* )
    sudo apt update
    sudo apt install -y build-essential
    sudo apt install -y git 
    sudo apt install -y openjdk-17-jre-headless; break;;
esac

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
EOF

write_aliases ~/.bash "$rconpw"
write_aliases /opt/minecraft/.bash_aliases "$rconpw"

    #echo "eval export MCRCON_PASS=$rconpw" > vars
    #echo "eval alias mcrcon=/opt/minecraft/tools/mcrcon/mcrcon" >> vars

sudo cp server.properties /opt/minecraft/server/
chown minecraft /opt/minecraft/server/server.properties

read -p "Would you like to enable and start Minecraft? [y/N]" en
case $en in [Yy]* )
    sudo -s -- <<-EOF
    systemctl enable minecraft
    systemctl start minecraft
EOF
esac