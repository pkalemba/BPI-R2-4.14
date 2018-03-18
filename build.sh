#!/bin/bash
export CROSS_COMPILE=arm-linux-gnueabihf-
export ARCH=arm
#export INSTALL_MOD_PATH=$(pwd)/mod/
#mkdir -p $INSTALL_MOD_PATH

case $1 in

"importconfig")
  make mt7623n_evb_bpi_defconfig
  ;;
"config")
  make menuconfig
  ;;
*)
  make
  if [[ $? -eq 0 ]];then
    cat arch/arm/boot/zImage arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dtb > arch/arm/boot/zImage-dtb
    mkimage -A arm -O linux -T kernel -C none -a 80008000 -e 80008000 -n "Linux Kernel 4.9" -d arch/arm/boot/zImage-dtb ./uImage
  fi
#  make modules_install
  ;;
esac
