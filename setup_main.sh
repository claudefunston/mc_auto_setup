
sudo -s -- <<EOF
    apt update
    apt install -y git build-essential
    apt install -y openjdk-17-jre-headless

    useradd -r -m -U -d /opt/minecraft -s /bin/bash minecraft
    cp ./minecraft.service /etc/systemd/system/minecraft.service
EOF

sudo su -c 'sh ./minecraft_user_scripts.sh' minecraft

sudo -s -- <<EOF
    cp server.properties /opt/minecraft/server/
    chown minecraft /opt/minecraft/server/server.properties

    ufw allow 25565/tcp

    systemctl enable minecraft
    systemctl start minecraft
EOF