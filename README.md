# mc_auto_setup
## Overview
A rapidly deployable testbed for creating Minecraft servers. There are two components:
* A Vagrant setup file to create recreateable, disposable, and safe Virtual Machines
* A series of Bash scripts to set up the Minecraft server environment and system service

With a few clicks, you will be able to connected to a Minecraft instance inside your local machine. Why operate like this? Before deploying Minecraft to your own server, you will likely want to modify settings from the setup here. Because of the disposable nature of the VM, you can make an incremental change to the setup scripts, and run a server install on a fresh machine without replicating any (human) work. 

This concept goes beyond Minecraft; any other configurations to your server can be similarly upgraded on an incremental, repeatedly testable basis. Because changes are made by script, the process is fundamentally self-documenting. No more "I know I had a command to fix that error, what was it?" -- you added it to your script and it's done right every time you spool up a fresh machine.

## Setup
### Required Software
Install the following two pieces of software:
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://developer.hashicorp.com/vagrant/downloads)

Choose the appropriate version for your host platform. This author has only tested on Windows

### Initialize VMs
From this repository, download _only_ the file `Vagrantfile`. Save it alone in any folder you wish. From your favorite terminal, navigate there:

`cd <PATH_TO_VAGRANTFILE>`

Activate the VM by typing
`vagrant up`

Vagrant will provision the machine. Once you have the command prompt back again (Vagrent will show lots out output), log on to your new box with

`vagrant ssh`

If asked, the default password is `vagrant`.

### Minecraft

Vagrant has already downloaded this repository for you. (One optional step here is to change the default RCON password; see appendix for locations) 

To get Minecraft going, enter

`cd mc_auto_setup && sh setup_main.sh`

That's it!

Make sure Minecraft is running with

`sudo systemctl status minecraft`.

To connect, find your IP address with `ifconfig`. NOTE: Because of the configuration of the VM, you will need to use the IP address listed under `eth1`, not `eth0`. (More advanced Vagrant/VirtualBox settings can change this)

## Operating the Server

NB: To be updated. the aliase are not being created correctly in the scripts. FOR NOW either
```
cd /opt/minecraft/tools/mcrcon/
mcron
```
or set an alias:
```
alias mcrcon="/opt/minecraft/tools/mcrcon/mcrcon -p McRcOnPw"
```
PLANNED

Now that we can connect, aside from stopping/starting the service our main control is RCON. Run `mcrcon` to enter a console from which you can enter any server commands.

### Planned Features

* RCON can send commands to the server but can't read from the console. Adding `screen` support back to the system service would be nice
* Automated backups
* SFTP configuration for sharing world files
* Some redundancy checks on the bash scripts. This would be to rerun scripts without making a new VM
* Consolidate references to RCON password; create environment variable
* Fix aliases!!

### Fixed Parameters