#!/bin/bash
export CROSS_COMPILE=arm-linux-gnueabihf-
export ARCH=arm
LANG=C
CFLAGS=-j$(grep ^processor /proc/cpuinfo  | wc -l)
export INSTALL_MOD_PATH=$(pwd)/mod/
mkdir -p $INSTALL_MOD_PATH

case $1 in
"importconfig")
  echo "importconfig"
  #make mt7623n_evb_fwu_defconfig
  cp arch/arm/configs/mt7623n_evb_fwu_defconfig .config
  #make mt7623n_evb_bpi_defconfig
  ;;
"config")
  make menuconfig
  ;;
"install")
  cp uImage /media/$USER/BPI-BOOT/bananapi/bpi-r2/linux/
  sudo cp -r mod/lib/modules/4.9.44-bpi-r2+ /media/$USER/BPI-ROOT/lib/modules/
  sync
;;
*)
  make ${CFLAGS}
  if [[ $? -eq 0 ]];then
    cat arch/arm/boot/zImage arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dtb > arch/arm/boot/zImage-dtb
    mkimage -A arm -O linux -T kernel -C none -a 80008000 -e 80008000 -n "Linux Kernel 4.9" -d arch/arm/boot/zImage-dtb ./uImage
    make modules_install
  fi
  ;;
esac
