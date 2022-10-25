# mc_auto_setup

Run `sh setup_main.sh` to get the Minecraft server .jar and create a systemd service to run it. Also downloads and compiles (not installs) mcrcon (https://github.com/Tiiffi/mcrcon).

Notes for some fixes:
* Sometimes JRE either does not install or fails to create `/usr/bin/java`. In the second case reinstalling it should work
* Alias for `mcrcon` won't create. It can be run from `/opt/minecraft/tools/mcrcon` directly, or run the alias line
* Change mcrcon password to something secure before running!
