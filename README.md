# mc_auto_setup
## Overview
A rapidly deployable testbed for creating Minecraft servers. There are two components:
* A Vagrant setup file to create recreateable, disposable, and safe Virtual Machines (optional)
* A series of Bash scripts to set up the Minecraft server environment and system service

With a few clicks, you will be able to connected to a Minecraft instance inside your local machine. Why operate like this? Before deploying Minecraft to your own server, you will likely want to modify settings from the setup here. Because of the disposable nature of the VM, you can make an incremental change to the setup scripts, and run a server install on a fresh machine without replicating any (human) work. 

This concept goes beyond Minecraft; any other configurations to your server can be similarly upgraded on an incremental, repeatedly testable basis. Because changes are made by script, the process is fundamentally self-documenting. No more "I know I had a command to fix that error, what was it?" -- you added it to your script and it's done right every time you spool up a fresh machine.

## Setup
### Using Vagrant
If you are bringing your own system, skip ahead to section Minecraft. Otherwise, install the following:

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://developer.hashicorp.com/vagrant/downloads)

Choose the appropriate version for your host platform. This author has only tested on Windows. Vagrant works with other virtualization software, but there are VB-specific sizing options in this particular configuration.

### Initialize VMs
From this repository, download _only_ the file `Vagrantfile`. Save it alone in any folder you wish. From your favorite terminal, navigate there:

`cd <PATH_TO_VAGRANTFILE>`

Activate the VM by typing
`vagrant up`

Vagrant will provision the machine. Once you have the command prompt back again (Vagrent will show various status output), log on to your new box with

`vagrant ssh`

If asked, the default password is `vagrant`.

### Minecraft

If you are using Vagrant, this repository is already cloned. Otherwise, clone it.

To get Minecraft going, enter

`cd mc_auto_setup && sudo sh setup_main.sh`

Finally, the script has created a file to set an alias and the RCON password: type

`source vars`

This sets an alias for `mcrcon`, and defines the `MCRCON_PASS` based on what you chose.

## Operating the Server

Open up a port to the outside world: for security, we are not enabling this in the scripts:

`sudo ufw allow 25565/tcp`

To connect, if you are using Vagrant: use the IP address from the `eth1` interface, not `eth0`. Otherwise connect as usual.

### Planned Features

* RCON can send commands to the server but can't read from the console. Adding `screen` support back to the system service would be nice
    * Note: `minecraft status` does show the previous 18 lines from the console
* Automated backups
* SFTP configuration for sharing world files
* ~~Some redundancy checks on the bash scripts. This would be to rerun scripts without making a new VM~~ Done, +interactivity
* ~~Consolidate references to RCON password; create environment variable~~ Done
* ~~Fix aliases!!~~ Aliases are created but do not persist after a reboot 

### Variables

| Parameter | Location | Default  | Comments |
|-----------|---------------|----------|----------|
| VM system memory |Vagrantfile|8192M|Change dependant on your physical system|
|VM core allocation|Vagrantfile|2 cores|Minecraft is not multi-threaded; increasing this will likely not change performance. Setting at 2 in case other processes can leverage it|
|VM guest OS|Vagrantfile|`hashicorp/bionic64`|Ubuntu 18.04 64 bit|
|Min Minecraft memory |`minecraft.service`|1024M|Lower limit. Do not change|
|Max Minecraft Memory|`minecraft.service`|4G|Observationally, Minecraft is more CPU-intensive than memory. 2-3G is plenty so we are safe here. Make sure this is lower than allocated VM memory|
|`SERVER_URL`|`minecraft_user_scripts.sh`|https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar|Downloads v1.19.2|
|Minecraft main port|`server.properties`|25565||
|RCON port|`server.properties`; `setup_main.sh`|25575|Passing no `-P` argument to `mcrcon` is leveraged multiple places. To change the port, any calls to `mcrcon` must also be modified.|
|`RCON_PW`|`server.properties`|None|IMPORTANT: Sete this to a secure value during setup.
|RCON IP|None|`localhost` (127.0.0.1)|See comments above. Again, the default value for `-H` in `mcrcon` is localhost; there is no need to change this|