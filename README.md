# Qbus Client-Server Installer
 Client Server application installer for openHAB to be used on a Linux machine (raspberryPi)

![Qbus Logo](https://github.com/QbusKoen/QbusClientServer-Installer/blob/main/images/Logo.JPG)

## This repository contains
* The installation script which
  * Installs Mono (Client and server are written in .net)
  * Downloads Client and Server from github
  * Creates services for the Client and Server
 
## Preparing your Qbus controller
Make sure your controller is protected with a username & password.
 
## How to use
First make sure you've got git installed:

```sudo apt-get install git```

Then clone this repository:

```git clone https://github.com/QbusKoen/QbusClientServer-Installer```

Go into the directory:

```cd QbusClientServer-Installer```

Give executable rights to installer:

```chmod +x install.sh```

Run the installer:
```./install.sh```

The installer will then ask for Username, Password, IP address and Serial nr of your controller.

## Qbus Client-Server Updater
With the installer, there also comes an update script.
You can run this script when the Username, Password, IP address or Serial nr of your controller has changed.
