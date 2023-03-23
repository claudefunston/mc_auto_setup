# mc_auto_setup
## Overview
A rapidly deployable testbed for creating Minecraft servers. There are two components:
* A Vagrant setup file to create recreateable, disposable, and safe Virtual Machines (optional)
* A series of Bash scripts to set up the Minecraft server environment and system service

TEST PUSH

With a few clicks, you will be able to connected to a Minecraft instance inside your local machine. Why operate like this? Before deploying Minecraft to your own server, you will likely want to modify settings from the setup here. Because of the disposable nature of the VM, you can make an incremental change to the setup scripts, and run a server install on a fresh machine without replicating any (human) work. 

This concept goes beyond Minecraft; any other configurations to your server can be similarly upgraded on an incremental, repeatedly testable basis. Because changes are made by script, the process is fundamentally self-documenting. No more "I know I had a command to fix that error, what was it?" &mdash; you added it to your script and it's done right every time you spool up a fresh machine.

## Setup
### Using Vagrant
If you are bringing your own system, you can skip most of this section. Pay attention to the firewall setup, as it will apply to your server as well.

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://developer.hashicorp.com/vagrant/downloads)

Choose the appropriate version for your host platform. This author has only tested on Windows. Vagrant works with other virtualization software, but there are VB-specific sizing options in this particular configuration.

#### Initialize VMs
From this repository, download _only_ the file `Vagrantfile`. Save it alone in any folder you wish. From your favorite terminal, navigate there:

    cd <PATH_TO_VAGRANTFILE>

Activate the VM by typing

    vagrant up

Vagrant will provision the machine. If asked for network interface, chose the physical one on your system. Vagrant can be configured to use a fixed private IP address, but in this mode it acts like another machine plugged into your router.

Once you have the command prompt back again (Vagrant will show various status outputs), log on to your new box with

    vagrant ssh

#### Enable firewall and connecting

Let's limit how we're allowed to connect to our new VM. First, enable it:

    sudo ufw enable

The firewall won't start untill a reboot &mdash; but if you reboot now, you can't log back in via SSH! Let's open up:

    sudo ufw allow ssh

This is equivalent to `ufw allow 22/tcp`.

_If you enable the firewall and reboot_ before opening 22: Don't worry. Go to the VirtualBox GUI, and you can interact with the system directly. From there punch port 22 open and log back in via SSH. May as well open Minecraft's port while we're here:

    sudo ufw allow 25565/tcp

Once the Minecraft server is running, you will need to look for your IP address under `eth1`, not `eth0`.

#### Program-specific notes:
* Vagrant should have given you a private key to log in via ssh. The default password is `vagrant`, but if you are asked for this something may be wrong with your setup. This password can also be used if you lock yourself out of SSH.
* Access to physical machine files: The folder in which you kept `Vagrantfile` is accessible from the VM, and is mounted at `/vagrant` in there. Files are shared and synced in both directions.
* If using Visual Studio Code with NVIDIA: graphics oddities may appear when changing focus windows/moving things around. To fix it:
    * NVIDIA Control Panel &rarr; Manage 3D Settings &rarr; Program Settings &rarr; Antialising - FXAA: set to "Off". Then restart VSCode.

### Minecraft

If you are using Vagrant, this repository is already cloned. Otherwise, clone it.

To run the installer, enter

    cd mc_auto_setup && sudo sh setup_main.sh

We have a couple of steps to export our environment variables and aliases:

    source ~/.bash_aliases && source /opt/minecraft/.bash_aliases

Finally, start up the server:

    sudo systemctl start minecraft

### Planned Features

* RCON can send commands to the server but can't read from the console. Adding `screen` support back to the system service would be nice
    * Note: `minecraft status` does show the previous 18 lines from the console
* Automated backups
* SFTP configuration for sharing world files


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
|RCON port|`server.properties`|25575|Passing no `-P` argument to `mcrcon` is leveraged multiple places. To change the port, any calls to `mcrcon` must also be modified.|
|`RCON_PW`|`server.properties`|None|IMPORTANT: Sete this to a secure value during setup.
|RCON IP|None|`localhost` (127.0.0.1)|See comments above. Again, the default value for `-H` in `mcrcon` is localhost; there is no need to change this|