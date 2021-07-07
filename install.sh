#!/bin/bash

# ============================== Define variables ==============================
USERVAR=''
PASSVAR=''
IPVAR=''
SNVAR=''

OPENHAB=''
TESTOPENHAB = ''

LUSER=''

RESTARTOH=''

# ============================== Define colors ==============================
DISPLTEXT=''
DISPLCOLOR=''

BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# ============================== Define functions ==============================
# Spin function, used while installing to hide output
spin()
{
  spinner="/|\\-/|\\-"
  while :
  do
    for i in `seq 0 7`
    do
      echo -n "${spinner:$i:1}"
      echo -en "\010"
      sleep 0.1
    done
  done
}

# Display text in color
echoInColor(){
	echo -e "$DISPLCOLOR$DISPLTEXT"
}

# Display password in color
echoInColorP(){
	echo -en "$DISPLCOLOR$DISPLTEXT"
}

# Download Qbus Client/Server to tmp location
downloadQbus(){
	spin &
	SPIN_PID=$!
	trap "kill -9 $SPIN_PID" `seq 0 15`
	sudo rm -R /tmp/qbus/
	git clone https://github.com/QbusKoen/QbusClientServer /tmp/qbus/ > /dev/null 2>&1
	
	kill -9 $SPIN_PID
}

# Qbus Client/Server is written in .net, so we have to install mono 
installMono(){
	spin &
	SPIN_PID=$!
	trap "kill -9 $SPIN_PID" `seq 0 15`
	
	sudo apt-get --assume-yes install mono-runtime mono-vbnc mono-complete > /dev/null 2>&1
	
	kill -9 $SPIN_PID
}

# 

# Create a script in home folder to change settings of the CTD
createChangeSettings(){
	spin &
	SPIN_PID=$!
	trap "kill -9 $SPIN_PID" `seq 0 15`
	
	sudo rm /tmp/qbus/setctd.sh > /dev/null 2>&1

	echo "#!/bin/bash" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1

	echo "echo '******************************************************************************************'" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo '*   ____  _                  _____ _ _            _      _____                           *'" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo '*  / __ \| |                / ____| (_)          | |    / ____|                          *'" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo '* | |  | | |__  _   _ ___  | |    | |_  ___ _ __ | |_  | (___   ___ _ ____   _____ _ __  *'" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo '* | |  | | |_ \| | | / __| | |    | | |/ _ \ |_ \| __|  \___ \ / _ \ |__\ \ / / _ \ |__| *'" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo '* | |__| | |_) | |_| \__ \ | |____| | |  __/ | | | |_   ____) |  __/ |   \ V /  __/ |    *'" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo '*  \___\_\_.__/ \__,_|___/  \_____|_|_|\___|_| |_|\__| |_____/ \___|_|    \_/ \___|_|    *'" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo '*                                                                                        *'" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo '******************************************************************************************'" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "read -p 'Enter username of your controller: ' USERVAR" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo -n 'Enter the password of your controller: '" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "unset password;" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "while IFS= read -r -s -n1 pass; do" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "  if [[ -z \$pass ]]; then" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "     echo" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "     break" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "  else" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "     echo -n '*'" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "     PASSVAR+=\$pass" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "  fi" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "done" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "if [[ \$PASSVAR == '' ]]; then" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "        PASSVAR='none'" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "fi" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "read -p 'Enter the ip address of your controller: ' IPVAR" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "read -p 'Enter the serial number of your controller: ' SNVAR" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "# Remove old service" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "sudo rm /lib/systemd/system/qbusclient.service" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "# Create Client service" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo '[Unit]' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo 'Description=Client for Qbus communication' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo 'After=multi-user.target qbusserver.service' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo '' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo '[Service]' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo 'Type=simple' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo 'ExecStart= mono /usr/bin/qbus/qbusclient/QbusClient.exe '\$IPVAR' '\$USERVAR' '\$PASSVAR' '\$SNVAR' 100' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo 'Restart=always' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo 'StandardOutput=append:/var/log/qbus/qbusclient.log' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo 'StandardError=append:/var/log/qbus/qbusclient_error.log' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo '' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo '[Install]' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "echo 'WantedBy=multi-user.target' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1

	echo "sudo systemctl daemon-reload" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1
	echo "sudo systemctl restart qbusclient.service" | sudo tee -a /tmp/qbus/setctd.sh > /dev/null 2>&1

	cp /tmp/qbus/setctd.sh ~/setctd.sh > /dev/null 2>&1
	sudo chmod +x ~/setctd.sh > /dev/null 2>&1
	
	LUSER=$(whoami)
	sudo chown $LUSER:$LUSER ~/setctd.sh
	
	kill -9 $SPIN_PID
}

# Main installation function to instal Qbus Client/Server
installQbus(){
	spin &
	SPIN_PID=$!
	trap "kill -9 $SPIN_PID" `seq 0 15`

	# Remove old files
	sudo rm -R /usr/bin/qbus > /dev/null 2>&1

	# Create software directory
	sudo mkdir /usr/bin/qbus > /dev/null 2>&1

	# Copy client and server to correct location
	sudo cp -R /tmp/qbus/QbusClient/. /usr/bin/qbus/qbusclient > /dev/null 2>&1
	sudo cp -R /tmp/qbus/QbusServer/. /usr/bin/qbus/qbusserver > /dev/null 2>&1

	# Modify config file
	sudo sed -i "s|<value>.\+</value>|<value>/usr/bin/qbus/qbusclient</value>|g" /usr/bin/qbus/qbusclient/QbusClient.exe.config > /dev/null 2>&1
	
	# Create cleanup.sh
	echo '#!/bin/bash' | sudo tee -a /usr/bin/qbus/qbusclient/cleanup.sh > /dev/null 2>&1
	echo '' | sudo tee -a /usr/bin/qbus/qbusclient/cleanup.sh > /dev/null 2>&1
	echo "sudo rm -R /usr/bin/qbus/qbusclient/'HomeCenter\Temp\'" | sudo tee -a /usr/bin/qbus/qbusclient/cleanup.sh > /dev/null 2>&1
	echo 'sudo rm /usr/bin/qbus/qbusclient/*.zip' | sudo tee -a /usr/bin/qbus/qbusclient/cleanup.sh > /dev/null 2>&1
	sudo chmod +x /usr/bin/qbus/qbusclient/cleanup.sh > /dev/null 2>&1
	
	# Changing ownership of qbus to local user
	LUSER=$(whoami)
	sudo chown -R $LUSER:$LUSER /usr/bin/qbus/

	# Create directory for logging
	sudo mkdir /var/log/qbus/ > /dev/null 2>&1

	# Deleting old service files
	sudo rm /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	sudo rm /lib/systemd/system/qbusserver.service > /dev/null 2>&1

	# Create Client service
	echo '[Unit]' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo 'Description=Client for Qbus communication' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo 'After=multi-user.target qbusserver.service' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo '' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo '[Service]' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo 'Type=simple' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo 'ExecStart= mono /usr/bin/qbus/qbusclient/QbusClient.exe '$IPVAR' '$USERVAR' '$PASSVAR' '$SNVAR' 100' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo 'Restart=always' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo 'StandardOutput=append:/var/log/qbus/qbusclient.log' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo 'StandardError=append:/var/log/qbus/qbusclient_error.log' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo '' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo '[Install]' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1
	echo 'WantedBy=multi-user.target' | sudo tee -a /lib/systemd/system/qbusclient.service > /dev/null 2>&1

	# Create Server service
	echo '[Unit]' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo 'Description=Server for Qbus communication' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo 'After=multi-user.target' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo '' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo '[Service]' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo 'Type=simple' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo 'ExecStart= mono /usr/bin/qbus/qbusserver/QServer.exe' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo 'Restart=always' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo 'StandardOutput=append:/var/log/qbus/qbusserver.log' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo 'StandardError=append:/var/log/qbus/qbusserver.log' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo '' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo '[Install]' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1
	echo 'WantedBy=multi-user.target' | sudo tee -a /lib/systemd/system/qbusserver.service > /dev/null 2>&1

	kill -9 $SPIN_PID
}

# Function for log rotation
createLogRotate(){
	spin &
	SPIN_PID=$!
	trap "kill -9 $SPIN_PID" `seq 0 15`

	sudo rm -R /etc/Logrotate.d/qbus > /dev/null 2>&1

	echo '/var/log/qbus/* {' | sudo tee -a /etc/Logrotate.d/qbus > /dev/null 2>&1
	echo '        daily' | sudo tee -a /etc/Logrotate.d/qbus > /dev/null 2>&1
	echo '        rotate 7' | sudo tee -a /etc/Logrotate.d/qbus > /dev/null 2>&1
	echo '        size 10M' | sudo tee -a /etc/Logrotate.d/qbus > /dev/null 2>&1
	echo '        compress' | sudo tee -a /etc/Logrotate.d/qbus > /dev/null 2>&1
	echo '        delaycompress' | sudo tee -a /etc/Logrotate.d/qbus > /dev/null 2>&1

	kill -9 $SPIN_PID	
}

# Function to start Qbus services
startQbus(){
	spin &
	SPIN_PID=$!
	trap "kill -9 $SPIN_PID" `seq 0 15`
	
	sudo systemctl daemon-reload > /dev/null 2>&1
	sudo systemctl enable qbusserver.service > /dev/null 2>&1
	sudo systemctl restart qbusserver.service > /dev/null 2>&1
	sudo systemctl enable qbusclient.service > /dev/null 2>&1
	sudo systemctl restart qbusclient.service > /dev/null 2>&1
	
	kill -9 $SPIN_PID
}

# Function to check openHAB
checkOH(){
	OH2=$(ls /usr/share/openhab2 2>/dev/null)
	OH3=$(ls /usr/share/openhab 2>/dev/null)

	if [[ $OH2 != "" ]]; then
	  # OH2 found
	  OPENHAB='openHAB2'
	elif [[ $OH3 != "" ]]; then
	  # OH3 found, checking release
	  OH3V=$(cat /etc/apt/sources.list.d/openhab.list)
	  if [[ $OH3V =~ "unstable" ]]; then
			OPENHAB="OH3Unstable"
	  elif [[ $OH3V =~ "stable" ]]; then
			OPENHAB="OH3Stable"
	  fi
	else
	  # OH not installed
	  OPENHAB = "None"
	fi
}

copyJar(){
	git clone https://github.com/QbusKoen/QbusOH3-JAR  /tmp/qbus/QbusOH3-JAR > /dev/null 2>&1
	sudo rm /usr/share/openhab/addons/org.openhab.binding.qbus* > /dev/null 2>&1
	sudo cp /tmp/qbus/QbusOH3-JAR/org.openhab.binding.qbus-3.1.0-SNAPSHOT.jar /usr/share/openhab/addons/ > /dev/null 2>&1
	sudo chown openhab:openhab  /usr/share/openhab/addons/org.openhab.binding.qbus-3.1.0-SNAPSHOT.jar
}

restartOH(){
	sudo systemctl stop openhab.service > /dev/null 2>&1
	sudo openhab-cli clean-cache
	sudo systemctl start openhab.service > /dev/null 2>&1
}



# ============================== Start installation ==============================
DISPLCOLOR=${ORANGE}
echo ''
DISPLTEXT='******************************************************************************************'
echoInColor
DISPLTEXT='*   ____  _                  _____ _ _            _      _____                           *'
echoInColor
DISPLTEXT='*  / __ \| |                / ____| (_)          | |    / ____|                          *'
echoInColor
DISPLTEXT='* | |  | | |__  _   _ ___  | |    | |_  ___ _ __ | |_  | (___   ___ _ ____   _____ _ __  *'
echoInColor
DISPLTEXT='* | |  | | |_ \| | | / __| | |    | | |/ _ \ |_ \| __|  \___ \ / _ \ |__\ \ / / _ \ |__| *'
echoInColor
DISPLTEXT='* | |__| | |_) | |_| \__ \ | |____| | |  __/ | | | |_   ____) |  __/ |   \ V /  __/ |    *'
echoInColor
DISPLTEXT='*  \___\_\_.__/ \__,_|___/  \_____|_|_|\___|_| |_|\__| |_____/ \___|_|    \_/ \___|_|    *'
echoInColor
DISPLTEXT='*                                                                                        *'
echoInColor
DISPLTEXT='******************************************************************************************'
echoInColor
DISPLTEXT="Release date 07/07/2021 by ks@qbus.be"
echoInColor
echo ''
DISPLTEXT="Welcome to the QbusClientServer installer."
echoInColor
DISPLTEXT="------------------------------------------"
echoInColor
DISPLCOLOR=${ORANGE}
DISPLTEXT="The Qbus Client Server is an application to make your controller 'open' for open source applications"
echoInColor
DISPLTEXT="This application is written in a .net environement, so on Linux distributions Mono is required."
echoInColor
DISPLTEXT="For the moment only openHAB is supported, but more applications will be enabled in the future."
echoInColor
DISPLTEXT="You can stop the installation process at any time by pressing <CTRL> - C."
echoInColor
echo ""

# ---------------- Check for Mono -----------------------
DISPLCOLOR=${YELLOW}
DISPLTEXT="-- Checking Mono..."
echoInColor

MONO=$(which mono 2>/dev/null)
if [[ $MONO != "" ]]; then
	DISPLCOLOR=${GREEN}
	DISPLTEXT='     Mono is already installed.'
	echoInColor
else
	read -p "$(echo -e $YELLOW"     We did not detect Mono on your system. For the moment the Qbus client/server is based on .net. Therefore Mono is neccesary to run the client/server. Do you agree to install Mono (y/n)? "$NC)" INSTMONO
	if [[ $INSTMONO == "n" ]]; then
		DISPLTEXT='     Sorry, if you do not install Mono, you can not use the Qbus Client/Server application.'
		DISPLCOLOR=${RED}
		echoInColor
		exit 1
	fi
fi
echo ''

# ---------------- Check for Qbus Client/Server -----------------------
DISPLCOLOR=${YELLOW}
DISPLTEXT='-- Checking Qbus client/server...'
echoInColor

QBUS=$(ls /lib/systemd/system/qbusclient.service 2>/dev/null)
if [[ $QBUS != "" ]]; then
	QBUS2=$(ls /usr/bin/qbus/ 2>/dev/null)
	if [[ $QBUS2 != "" ]]; then
		DISPLTEXT='     -You already have Qbus client and server installed. The files will be updated.'
		DISPLCOLOR=${GREEN}
		echoInColor
	else
		DISPLTEXT='     -We have detected the previous version of the Qbus client/server. This version will be removed and the newest will be installed. The directory ~/QbusOpenHab will no longer be used. '\
		'The Qbus Client/Server application will be installed in /usr/bin/qbus/. We will try to remove ~/QbusOpenHab if this fails, please remove the directory.'
		DISPLCOLOR=${YELLOW}
		echoInColor
	fi
else
	DISPLTEXT='     -Qbus client/server is not found on your sytem. We will install this.'
	DISPLCOLOR=${YELLOW}
	echoInColor
fi
echo ''

# ---------------- Ask Qbus credentials  -----------------------
DISPLCOLOR=${RED}
DISPLTEXT='      To communicate with your controller, it is necessary that the SDK (DLL) option is enabled. (see https://iot.qbus.be/nl/inleiding).'
echoInColor
DISPLTEXT='      Make sure the option is enabled before continuing'
echoInColor

echo ''

DISPLTEXT='-- Configure client to communicate with CTD controller...'
DISPLCOLOR=${YELLOW}
echoInColor

read -p "$(echo -e $YELLOW"     -Enter username of your controller: "$NC)" USERVAR


DISPLTEXT='     -Enter the password of your controller (just press enter if you have no pass) - be carefull (backspace is also considered as a char): '
echoInColorP

echo -e -n "$NC"
unset pass;
while IFS= read -r -s -n1 pass; do
  if [[ -z $pass ]]; then
     echo
     break
  else
     echo -n '*'
     PASSVAR+=$pass
  fi
done

if [[ $PASSVAR == '' ]]; then
        PASSVAR='none'
fi

read -p "$(echo -e $YELLOW"     -Enter the ip address of your controller: "$NC)" IPVAR
read -p "$(echo -e $YELLOW"     -Enter the serial number of your controller: "$NC)" SNVAR
echo ''

# ---------------- Install -----------------------
echo ''

DISPLCOLOR=${ORANGE}
DISPLTEXT='******************************************************'
echoInColor
DISPLTEXT='* Everything is set, we will start the installation. *'
echoInColor
DISPLTEXT='******************************************************'
echoInColor

echo ''

# ---------------- Qbus stuff -----------------------

DISPLCOLOR=${YELLOW}

if [[ $INSTMONO == "y" ]]; then
	DISPLTEXT='* Installing Mono...'
	echoInColor
	installMono
	echo ''
fi

DISPLTEXT='* Downloading Qbus client and server...'
echoInColor
downloadQbus
echo ''

DISPLTEXT='* Install Qbus client and server...'
echoInColor
installQbus
echo ''

DISPLTEXT='* Creating file for log rotation...'
echoInColor
createLogRotate
echo ''

DISPLTEXT='* Starting Qbus services'
echoInColor
startQbus
echo ''

DISPLTEXT='* Creating setctd.sh'
echoInColor
createChangeSettings
echo ''

# ---------------- Check openHAB -----------------------
DISPLTEXT='* Checking openHAB...'
echoInColor

checkOH

DISPLCOLOR=${GREEN}
case $OPENHAB in
	openHAB2)
		DISPLTEXT='     -We have detected openHAB2 running on your device. The Qbus Binding is developped for the newest version of openHAB (3). Please visit https://www.openhab.org/docs/configuration/migration/ for updating to the newest version. And https://www.openhab.org/download/ on how to install.'
		echoInColor
		;;
	OH3Unstable)
		DISPLTEXT='     -We have detected openHAB running the Snapshot version. The Qbus binding is included in the addons.'
		echoInColor
		;;
	OH3Stable)
		DISPLTEXT='     -We have detected openHAB running the Stable version. The Qbus binding is included in the addons.'
		echoInColor
		;;
	None)
		DISPLTEXT='     -We did not detected openHAB running on your system. For the moment our client/server is only compatible with openHAB. Plesae visit https://www.openhab.org/download/ to install openHAB.'
		echoInColor
		;;
esac

read -p "$(echo -e $GREEN"     -For the moment we are still developping the openHAB Binding. The latest version includes the ECM module, but is not yet released. Do you want to test this binding? If you do so, we will copy the test JAR to overwrite the released version. (y/n)")" TESTOPENHAB

if [[ $TESTOPENHAB == "y" ]]; then
	copyJar()
	read -p "$(echo -e $GREEN"     -To be able to use the test binding, it is necessary to stop openHAB - clean the cache - and restart openHAB to load the JAR. Do you want to do this now? (y/n)")" RESTARTOH
fi

if [[ $RESTARTOH == "y" ]]; then
	DISPLTEXT='* Stopping openHAB - Cleaning cache - Starting openHAB...'
	echoInColor
	DISPLTEXT='     - This procedure will take some time. Please be patient. To clean the cache, please answer with y when asked.'
	echoInColor
	restartOH
fi

echo ''

# ---------------- Cleaning up and reboot -----------------------
DISPLCOLOR=${YELLOW}
DISPLTEXT='* Cleaning up...'
echoInColor
sudo rm -R /tmp/qbus > /dev/null 2>&1
sudo rm -R ~/QbusClientServer-Installer > /dev/null 2>&1


DISPLTEXT='The installation is finished now. To make sure everything is set up correctly and to avoid problems, we suggest to do a reboot.'
echoInColor
read -p "$(echo -e $YELLOW"Do you want to reboot now? (y/n) " $NC)" REBOOT

if [[ $REBOOT == "y" ]]; then
	DISPLTEXT='* Rebooting the system...'
	echoInColor
	sudo reboot
else
	DISPLTEXT='* You choose to not reboot your system. If you run into problems, first try to reboot!'
	echoInColor
fi
