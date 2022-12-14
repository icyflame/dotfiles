#!/usr/bin/bash

option=$1
if [[ -z "$option" || "$option" == "help" ]];
then
	cat <<EOF

COMMAND
    mount_home2.sh (help|mount|unmount) cryptsetup-device-name final-mount-point /dev/...

EXAMPLES
    mount_home2.sh help
    mount_home2.sh mount home2 /home2 /dev/sda10
    mount_home2.sh unmount home2 /home2
EOF
	exit 0
fi

if [ "$option" == "mount" ];
then
	dev_name=$2
	mount_point=$3
	device=$4

	if [[ -z "$device" || -z "$dev_name" || -z "$mount_point" ]];
	then
		echo "ERROR: Run '$0 help' to find the correct command."
		exit 42
	fi

    set -xe
	sudo /usr/lib/systemd/systemd-cryptsetup attach $dev_name $device - fido2-device=auto
	sudo mount /dev/mapper/$dev_name $mount_point
    exit 0
fi

if [ "$option" == "unmount" ];
then
	dev_name=$2
	mount_point=$3

	if [[ -z "$dev_name" || -z "$mount_point" ]];
	then
		echo "ERROR: Run '$0 help' to find the correct command."
		exit 43
	fi

    set -xe
	sudo umount $mount_point
	sudo cryptsetup close /dev/mapper/$dev_name
    exit 0
fi

echo "ERROR: Run '$0 help' to find the correct command."
