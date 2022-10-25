
sudo apt update
sudo apt -y install git build-essential
sudo apt -y install openjdk-17-jre-headless

sudo useradd -r -m -U -d /opt/minecraft -s /bin/bash minecraft

sudo cp ./minecraft.service /etc/systemd/system/minecraft.service

sudo su -c 'sh ./minecraft_user_scripts.sh' minecraft

sudo chown minecraft server.properties

sudo cp server.properties /opt/minecraft/server/

alias mcrcon="/opt/minecraft/tools/mcrcon/mcrcon -p McRcOnPw"
