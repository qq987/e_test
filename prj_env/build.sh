#!/bin/bash
# Kernel
#

if [ "$1"x == "mount"x ];then
	if [ ! -d /mnt/buildkern ];then
		sudo mkdir /mnt/buildkern
		sudo mount -t tmpfs tmpfs -o size=10G /mnt/buildkern
		sudo chown lw:lw /mnt/buildkern
		chmod 777 /mnt/buildkern
		#sudo mkfs.tmpfs -m 100M -o size=100M /dev/shm/mydisk
	fi
	#cp -r /home/lw/prj/mp157/sdk/Linux-5.4/!(.git|G*) /mnt/buildkern
	cp -r /home/lw/prj/mp157/sdk/Linux-5.4/* /mnt/buildkern
	cd /mnt/buildkern
	make 100ask_stm32mp157_pro_defconfig -j4
	time make uImage LOADADDR=0xC2000040 -j20
	make dtbs -j10
	# arch/arm/boot/uImage   , arch/arm/boot/dts/stm32mp157c-100ask-512d-v1.dtb
	# build_modules
	time make ARCH=arm CROSS_COMPILE=arm-buildroot-linux-gnueabihf- modules -j20
	# install_module
	#make ARCH=arm INSTALL_MOD_PATH=/home/lw/prj/mp157/sdk/Linux-5.4/module_lib INSTALL_MOD_STRIP=1 modules_install
	time make ARCH=arm INSTALL_MOD_PATH=/mnt/buildkern/module_lib INSTALL_MOD_STRIP=1 modules_install -j10

	scp /mnt/buildkern/arch/arm/boot/uImage root@169.254.243.125:/boot
	scp /mnt/buildkern/arch/arm/boot/dts/stm32mp157c-100ask-512d-v1.dtb root@169.254.243.125:/boot
	scp -r /mnt/buildkern/module_lib/lib/modules/ root@169.254.243.125:/lib/
	ssh root@169.254.243.125 /bin/sync
	ssh root@169.254.243.125 /sbin/reboot

elif [ "$1"x == "umount"x ];then
	#cp -r /mnt/buildkern/* /home/lw/prj/mp157/sdk/Linux-5.4/
	sudo umount /mnt/buildkern
	rm -rf /mnt/buildkern
fi
#
# Uboot:
