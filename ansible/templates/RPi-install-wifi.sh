#!/bin/bash
#set -e

# origin-source:  http://www.fars-robotics.net/install-wifi
# install-wifi - v9.4 - by MrEngman.
# After downloading this script:
#   $  sudo mv ./install-wifi /usr/bin/install-wifi
#   $  sudo chmod +x /usr/bin/install-wifi
#   $  sudo install-wifi -h
#


UPDATE_SELF=${UPDATE_SELF:-1}
UPDATE_URI="http://www.fars-robotics.net/install-wifi"

ROOT_PATH=${ROOT_PATH:-"/"}
WORK_PATH=${WORK_PATH:-"${ROOT_PATH}/root"}
OPTION=${1:-""}
DRIVE=${2:-""}
COMMIT=${3:-""}

function update_self() {
        echo " *** Performing self-update"
        _tempFileName="$0.tmp"

        if ! curl -Ls --output "${_tempFileName}" "${UPDATE_URI}"; then
                echo " !!! Failed to download update for install-wifi!"
                echo " !!! Make sure you have ca-certificates installed and that the time is set correctly"
                exit 1
        fi

        OCTAL_MODE=$(stat -c '%a' "$0")
        if ! chmod ${OCTAL_MODE} "${_tempFileName}" ; then
                echo " !!! Failed: Error while trying to set mode on ${_tempFileName}"
                exit 1
        fi

        cat > "${WORK_PATH}/.updateScript.sh" << EOF
        if mv "${_tempFileName}" "$0"; then
                rm -- "\$0"
                exec env UPDATE_SELF=0 /bin/bash "$0" "${OPTION}" "${DRIVE}" "${COMMIT}"
        else
                echo " !!! Failed!"
        fi
EOF

        echo " *** Relaunching after update"
        exec /bin/bash "${WORK_PATH}/.updateScript.sh"
}

display_help() {
	echo "#"
	echo "# usage:"
	echo "#"
	echo "# sudo install-wifi [[-h | --help] |"
	echo "#		[-c | --check [driver] [rpi-update | commit_id]] |"
	echo "#		[-u | --update [driver] [rpi-update | commit_id]] |"
	echo "#		[driver [rpi-update | commit_id]]]"
	echo "#"
	echo "# options:"
	echo "#  none - install the driver for the wifi module connected to the Pi for the currently running kernel."
	echo "#"
	echo "# -h|--help  - display usage."
	echo "#"
	echo "# -c|--check [driver] [option]  - check if a driver is available, does not install it."
	echo "#			 driver - specific driver to check for, one of: 8188eu, 8192eu, 8812au, mt7601, mt7610 or mt7612"
	echo "#	[option]:-	  blank - check driver for currently running kernel"
	echo "#		     rpi-update - check driver for latest version of rpi-update"
	echo "#		      commit-id - check driver for specific commit-id of rpi-update"
	echo "#"
	echo "# -u|--update [driver] [option] - update/install driver, can be used after running, but before rebooting, rpi-update"
	echo "#                                 to update the driver to the one needed for the new kernel installed by rpi-update."
	echo "#			 driver - specific driver to update/install, one of: 8188eu, 8192eu, 8812au, mt7601, mt7610 or mt7612"
	echo "#	[option]:- 	  blank - update/install driver for currently running kernel"
	echo "#		     rpi-update - update/install driver for latest version of rpi-update"
	echo "#		      commit-id - update/install driver for specific commit-id of rpi-update"
	echo "#"
	echo "# driver [option] - install specific driver, enables installing the driver for a module not currently connected to"
	echo "#		    the Pi, or installing a driver for a different module if you want to change your wifi module."
	echo "#			 driver - specific driver to install, one of: 8188eu, 8192eu, 8812au, mt7601, mt7610 or mt7612"
	echo "#	[option]:- 	  blank - update/install driver for currently running kernel"
	echo "#		     rpi-update - update/install driver for latest version of rpi-update"
	echo "#		      commit-id - update/install driver for specific commit-id of rpi-update"
	echo "#"
	read -n1 -r -p "Press any key to continue..."
	echo
	echo "#"
	echo "# install-wifi examples:"
	echo "#"
	echo "#   Install/update the wifi driver for the wifi module connected to the Pi for the currently running kernel"
	echo "#"
	echo "#	sudo install-wifi"
	echo "#"
	echo "#   If you want to change your wifi module to one using a different driver that is compatible with this script"
	echo "#   you can install the driver for the new wifi module, one of: 8188eu, 8192eu, 8812au, mt7601, mt7610 or mt7612"
	echo "#   In this example it will install the 8192eu wifi module driver. After installing the driver shutdown the"
	echo "#   Pi, remove the currently connected wifi module and connect the new 8192eu wifi module and restart your Pi"
	echo "#   and it should start up with the new wifi adapter connected to your network."
	echo "#"
	echo "#	sudo install-wifi 8192eu - this will install the 8192eu module for the current kernel"
	echo "#"
	echo "#   if you want to run rpi-update, first check a driver is available before you update your code. If the check"
	echo "#   indicates a driver is available run rpi-update to update the firmware/kernel and then before rebooting"
	echo "#   update the wifi driver."
	echo "#"
	echo "#	sudo install-wifi -c rpi-update - check for driver if rpi-update is run."
	echo "#	sudo rpi-update                 - if a driver is available you can run rpi-update to update firmware."
	echo "#	sudo install-wifi -u rpi-update - then update the driver for the new kernel installed by rpi-update."
	echo "#	sudo reboot		        - now reboot to update the kernel with the new wifi driver."
	echo "#"
	echo "#   if you want to run, say rpi-update b2f6c103e5 to install 3.18.7+ #755, first check a driver is available"
	echo "#   before you update your code. Then, if a driver is available update the code, and then before rebooting"
	echo "#   update the wifi driver."
	echo "#"
	echo "#	sudo install-wifi -c b2f6c103e5 - check for driver if rpi-update b2f6c103e5 is run to install kernel 3.18.7+ #755."
	echo "#	sudo rpi-update b2f6c103e5      - if a driver is available you can run rpi-update b2f6c103e5 to update firmware."
	echo "#	sudo install-wifi -u b2f6c103e5 - then update the driver for the new kernel installed by rpi-update b2f6c103e5."
	echo "#	sudo reboot		        - now reboot to update the kernel with the new wifi driver."
	echo "#"
	echo "#   and finally, you can change the wifi module you are using and install the new driver for it as well as"
	echo "#   running rpi-update to update the kernel, and assuming in this example the new adapter uses the 8812au"
	echo "#   driver, using something like:"
	echo "#"
	echo "#	sudo install-wifi -c 8812au rpi-update - check for 8812au driver if rpi-update is run."
	echo "#	sudo rpi-update	                       - if a driver is available you can run rpi-update to update firmware."
	echo "#	sudo install-wifi -u 8812au rpi-update - install the 8812au driver for the new kernel installed by rpi-update."
	echo "#	sudo halt			       - shutdown the Pi, replace the wifi adapter with the 8812au wifi adapter."
	echo "#					       - restart the Pi with the new kernel and new 8812au wifi module."
	echo "#"
}

fetch_driver() {
	echo "Checking for a wifi module to determine the driver to install."
	echo
	echo -n "Your wifi module is "
	lsusb > .lsusb
	# check for rtl8188eu compatible driver
	if   cat .lsusb | grep -i '056E:4008\|2001:3311\|0DF6:0076\|2001:3310\|2001:330F\|07B8:8179\|0BDA:0179\|0BDA:8179' ; then
		driver=8188eu
	# check for rtl8812au compatible driver
	elif cat .lsusb | grep -i '7392:A813\|7392:A812\|7392:A811\|2019:AB32\|2001:3318\|2001:3314\|0E66:0023\|0BDA:A811\|0846:9052\|04BB:0953\|0411:0242\|0BDA:0823\|0BDA:0820\|0BDA:8822\|0BDA:0821\|0BDA:0811\|7392:A822\|2357:0103\|2357:0101\|20F4:805B\|2019:AB30\|2001:3316\|2001:3315\|2001:3313\|2001:330E\|1740:0100\|148F:9097\|13B1:003F\|1058:0632\|0E66:0022\|0DF6:0074\|0B05:17D2\|07B8:8812\|0789:016E\|0586:3426\|050D:1109\|050D:1106\|04BB:0952\|0409:0408\|0BDA:881C\|0BDA:881B\|0BDA:881A\|0BDA:8812' ; then
		driver=8812au
	# check for rtl8192eu compatible driver
	elif cat .lsusb | grep -i '2357:0109\|2357:0108\|2357:0107\|2001:3319\|0BDA:818C\|0BDA:818B' ; then
		driver=8192eu
	# check for mt7601Usta compatible driver
	elif cat .lsusb | grep -i '148F:7650\|0B05:17D3\|0E8D:760A\|0E8D:760B\|13D3:3431\|13D3:3434\|148F:6370\|148F:7601\|148F:760A\|148F:760B\|148F:760C\|148F:760D\|2001:3D04\|2717:4106\|2955:0001\|2955:1001\|2955:1003\|2A5F:1000\|7392:7710' ; then
		driver=mt7601
	# check for mt7610u compatible driver
        elif cat .lsusb | grep -i '0E8D:7650\|0E8D:7630\|2357:0105\|0BDB:1011\|7392:C711\|20F4:806B\|293C:5702\|057C:8502\|04BB:0951\|07B8:7610\|0586:3425\|2001:3D02\|2019:AB31\|0DF6:0075\|0B05:17DB\|0B05:17D1\|148F:760A\|148F:761A\|7392:B711\|7392:A711\|0E8D:7610\|13B1:003E\|148F:7610' ; then
		driver=mt7610
	# check for mt7612u compatible driver
	elif cat .lsusb | grep -i '0E8D:7662\|0E8D:7632\|0B05:17C9\|0E8D:7612\|045E:02E6\|0B05:17EB\|0846:9053\|0B05:180B\|0846:9014' ; then
		driver=mt7612
	fi

	if [[ ! $driver ]] ; then
		echo "unrecognised."
		echo
		echo "**** Unable to identify your wifi module ****"
		echo
		echo "The script only works for wifi modules using the rtl8188eu, rtl8192eu, rtl8812au, mt7601, mt7610 and mt7612 drivers."
		echo
		echo "Looking for your wifi module the script detected the following USB devices:-"
		echo
		cat .lsusb
		echo
		echo "If you are certain your module uses one of the drivers the script installs check the output of command"
		echo "'lsusb' shows your wifi module. If lsusb shows your wifi module try running the script again. If the"
		echo "script fails to detect your wifi module again the driver may need updating to add your module USB id."
		echo
		echo "If lsusb does not show your wifi module you will need to resolve that issue before the script can be"
		echo "used to install the driver you need."
		echo
		exit 1
	else
		echo
		echo "And it uses the $driver driver."
		echo
	fi
}

check_driver() {

	if [[ $kernelcommit == "rpi-update" ]] ; then
		rpi_firmware_commit_id=master
	elif [[ $kernelcommit ]] ; then
		rpi_firmware_commit_id=$kernelcommit
	fi

	if [[ $kernelcommit ]] ; then
		# check if Pi2 B or earlier version of Pi and select the relevant kernel image
		if (grep -Fq BCM2709 /proc/cpuinfo) ; then
			pi=2
			image=kernel7.img
			uname=uname_string7
                elif (grep -Fq ARMv7 /proc/cpuinfo) ; then
                        pi=2
                        image=kernel7.img
			uname=uname_string7
		elif (grep -Fq BCM2708 /proc/cpuinfo) ; then
			pi=1
			image=kernel.img
			uname=uname_string
                elif (grep -Fq ARMv6 /proc/cpuinfo) ; then
                        pi=1
                        image=kernel.img
			uname=uname_string
		else
			echo "Processor type unknown - you do not appear to be running this script on a Raspberry Pi. Exiting the script"
			exit 1
		fi

		echo -n "Please wait ... checking the kernel revision and build you will have after running command 'sudo rpi-update"
		if [[ $kernelcommit != "rpi-update" ]] ; then
			echo " $kernelcommit'."
		else
			echo "'."
		fi

# download uname string if it exists
		if ! (wget -q https://github.com/Hexxeh/rpi-firmware/raw/$rpi_firmware_commit_id/$uname -O .uname_string) ; then
		
		
# download the relevant kernel image if uname_string doesn't exist
			if ! (wget -q https://github.com/Hexxeh/rpi-firmware/raw/$rpi_firmware_commit_id/$image -O .kernel) ; then
				echo "Invalid commit-id, kernel not available for your version of the Pi, Pi $pi."
				exit 1
			fi

# extract uname_string from kernel image

			strings -n 10 .kernel | grep "Linux version" > .uname_string

			if [ ! -s .uname_string ] ; then
				if [ ! -f /usr/bin/mkknlimg1 ] ; then
					if [ -f /usr/bin/mkknlimg ] ; then
						sudo rm /usr/bin/mkknlimg
					fi
					sudo wget -q http://www.fars-robotics.net/mkknlimg1 -O /usr/bin/mkknlimg1
					sudo chmod +x /usr/bin/mkknlimg1
				fi
				mkknlimg1 .kernel .kernel1
				mv .kernel1 .kernel
				strings -n 10 .kernel | grep "Linux version" > .uname_string
			fi
		fi

		kernel=$(cat .uname_string | awk '{print $3}' | tr -d '+')
		build=$(grep -Po '(?<=#)[^[]*' .uname_string | awk '{print $1}')

		echo
		if [[ $kernelcommit == "rpi-update" ]] ; then
			echo -n "Running command 'sudo rpi-update"
		elif [[ $kernelcommit ]] ; then
			echo -n "Running command 'sudo rpi-update $kernelcommit"
		fi
		echo "' will load:"
		echo
		echo "        kernel revision = $kernel+"
		echo "        kernel build    = #$build"
		echo
	fi

	echo -n "Checking for a new $driver wifi driver module"
	if [[ $kernelcommit ]] ; then
		if [[ $kernelcommit == "rpi-update" ]] ; then
			echo " if you run command 'sudo rpi-update'."
		else
			echo " if you run command 'sudo rpi-update $rpi_firmware_commit_id'."
		fi
	else
		echo " for your current kernel."
	fi

	if (wget --spider -o .wgetlog http://www.fars-robotics.net/$driver\-$kernel\-$build.tar.gz) ; then
		echo "There is a driver module available for this kernel revision."
	else
		if cat .wgetlog | grep -iq "404 Not Found" ; then
			echo "A driver does not yet exist for this update."
		else
			echo "The script cannot access Dropbox to check a driver is available."
		fi

	exit 2
	fi
}

install_driver() {

	echo "Downloading the $driver driver."

	if (wget -q http://www.fars-robotics.net/$driver\-$kernel\-$build.tar.gz -O wifi-driver.tar.gz) ; then
		echo "Installing the $driver driver."
		echo
		tar xzf wifi-driver.tar.gz
		rm install.sh > /dev/null 2>&1

		module_dir="/lib/modules/$kernel+/kernel/drivers/net/wireless"
		
		if [ -f RT2870STA.dat ] ; then
			sudo mkdir -p /etc/Wireless/RT2870STA/
			sudo mv RT2870STA.dat /etc/Wireless/RT2870STA/
		
			if [ -f 95-ralink.rules ] ; then
				sudo mv 95-ralink.rules /etc/udev/rules.d/
			elif [ -f /etc/udev/rules.d/95-ralink.rules ] ; then
				sudo rm /etc/udev/rules.d/95-ralink.rules
			fi
		fi
		
		if [ -f $driver.conf ] ; then
			sudo cp $driver.conf /etc/modprobe.d/.
			rm $driver.conf
		fi

		if [ -f mt7662u_sta.ko ] ; then
			driver1=mt7662u_sta
		elif [ -f mt7610u_sta.ko ] ; then
			driver1=mt7610u_sta
		elif [ -f mt7610u.ko ] ; then
			driver1=mt7610u
			sudo mv *.bin /lib/firmware
		elif [ -f mt7601Usta.ko ] ; then
			driver1=mt7601Usta
		elif [ -f 8812au.ko ] ; then
			driver1=8812au
		elif [ -f 8192eu.ko ] ; then
			driver1=8192eu
		elif [ -f 8188eu.ko ] ; then
			driver1=8188eu
		fi

		echo "Installing driver module $driver1.ko."
		sudo install -p -m 644 $driver1.ko $module_dir
		sudo depmod $kernel+

		rm $driver1.ko

                if [[ $kernelcommit ]] ; then
			echo "Syncing changes to disk"
			sync
                        echo "You will need to reboot to load the new driver."
		elif (lsmod | grep $driver1 > /dev/null) ; then
			echo "Syncing changes to disk"
			sync
			echo "A version of the $driver driver is already loaded and running."
			echo "You will need to reboot to load the new driver, $driver1.ko."
		else
			echo "Loading and running the new $driver driver, $driver1.ko."
			sudo modprobe $driver1
		fi
		
	else
		echo
		echo "A driver does not yet exist for this kernel."
	fi
}

display_current() {
	echo
	echo "Your current kernel revision = $kernel+"
	echo "Your current kernel build    = #$build"
	echo
}

tmpdir=$(mktemp -d)
trap "\rm -rf $tmpdir" EXIT
cd $tmpdir

#initialise some variables
command=$0
option=$1
kernelcommit=$2

driver=""
kernel=$(uname -r | tr -d '+')
build=${build:-$(uname -v | awk '{print $1}' | tr -d '#')}

if [[ ${EUID} -ne 0 ]]; then
        echo " !!! This tool must be run as root"
        exit 1
fi

echo
echo " *** Raspberry Pi wifi driver installer by MrEngman."

if [[ ${UPDATE_SELF} -ne 0 ]]; then
        update_self
fi

case "$1" in
	8188eu|8192eu|8812au|mt7601|mt7610|mt7612)
		driver=$1
		display_current
		check_driver
		install_driver
		;;
	-c|--check)
		case "$2" in
			8188eu|8192eu|8812au|mt7601|mt7610|mt7612)
				driver=$2
				kernelcommit=$3
				;;
		esac
		display_current
		if [ ! $driver ] ; then
			fetch_driver
		fi
		check_driver
		;;
	-u|--update)
		case "$2" in
			8188eu|8192eu|8812au|mt7601|mt7610|mt7612)
				driver=$2
				kernelcommit=$3
				;;
		esac
		display_current
		if [ ! $driver ] ; then
			fetch_driver
		fi
		check_driver
		install_driver
		;;
	-h|--help)
		display_help
		exit 0
		;;
	"")
		display_current
		fetch_driver
		check_driver
		install_driver
		;; # proceed to install
	*)
		echo "unknown command: $1" >&2
		~/$command --help
		exit 1
		;;
esac

exit 0
