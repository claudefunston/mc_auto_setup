# mc_auto_setup

A quick set of bash commands to download an easily controllable Minecraft server.

To set everything up:
* Clone the repo (`git clone https://github.com/claudefunston/mc_auto_setup`)
* `cd mc_auto_setup`
* For best security, you can change the RCON password in these files:
    * `server.properties` (line 40)
    * `minecraft.service` (line 16)
    * `setup_main` (Alias commands)
        * Note, for future try to condense this using environment variable `MCRCON_PASS` 
* Now run `sudo sh setup_main.sh`