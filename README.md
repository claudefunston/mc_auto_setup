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

And you're ready to go! The scripts don't start up minecraft; as usual kick it off with
* `sudo systemctl start minecraft` and to enable on startup,
* `sudo systemctl enable minecraft` if desired

Right away, `systemctl status minecraft` will show helpful information while the server is spooling up. The first time takes a bit longer, but you will see helpful information showing basic status. In particular, look out for RCON listening on port 25575. If it worked, `mcrcon` will bring up the server console with all commands available.

Potential troubleshooting
* If the server isn't starting (shows errors on `status`), make sure Java is correctly installed with `java -version1`
* If `mcrcon` shows command not found, take a look at `~/.bashrc` to make sure they are defined. If not, navigtate to `/opt/minecraft/tools/mcrcon/` and launch from there, or define the aliases