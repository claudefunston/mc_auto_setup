echo "--Welcome to Minecraft Auto Setup--\n\n"

read -p "Would you like to install packages? [y/N]" pk
case $pk in [Yy]* )
    sudo apt install -y git build-essential openjdk-17-jre-headless; break;;
esac

echo "\n\nCreating Minecraft user"

useradd -r -m -U -d /opt/minecraft -s /bin/bash minecraft || "User already exists ... skipping this step\n\n"

cp ./minecraft.service /etc/systemd/system/minecraft.service

sudo su -c 'sh ./minecraft_user_scripts.sh' minecraft

sudo -s -- <<EOF
    cp server.properties /opt/minecraft/server/
    chown minecraft /opt/minecraft/server/server.properties

    ufw allow 25565/tcp

    systemctl enable minecraft
    systemctl start minecraft
EOF