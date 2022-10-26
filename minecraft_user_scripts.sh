SERVER_URL="https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar"

echo "\n\nCreating file structure\n\n"

mkdir -p ~/backups
mkdir -p ~/server
mkdir -p ~/tools

if[ ! -d ~/tools/mcrcon ] then
    cd ~/tools
    git clone https://github.com/Tiiffi/mcrcon.git
    cd mcrcon
    printf "\n\nCompiling mcrcon\n\n"
    gcc -std=gnu99 -Wall -Wextra -Wpedantic -Os -s -o mcrcon mcrcon.c

    chmod +x mcrcon
else
    printf "\n\nmcrcon already present. Skipping compile\n\n"
fi

if[ ! -f ~/server/server.jar ] then
    printf "\n\nFetching server.jar and accepting EULA\n\n"
    wget "$SERVER_URL" -P /opt/minecraft/server
    echo "eula=true" >> /opt/minecraft/server/eula.txt
else
    printf "\n\nMinecraft server already present. Skipping download\n\n"
fi
