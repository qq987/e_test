ARCH ?=arm
CROSS_COMPILE ?= arm-buildroot-linux-gnueabihf-
CC ?= ${CROSS_COMPILE}cc

KERN_PATH ?= /home/lw/prj/mp157/sdk/Linux-5.4/

obj-m := test.o

.PHONY: all
all:
	make -C $(KERN_PATH) M=`pwd` modules
	scp test.ko root@169.254.243.125:/home/lw

clean:
	make -C $(KERN_PATH) M=`pwd` modules clean
