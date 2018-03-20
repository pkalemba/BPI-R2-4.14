#!/bin/bash
export CROSS_COMPILE=arm-linux-gnueabihf-
export ARCH=arm
LANG=C
CFLAGS=-j$(grep ^processor /proc/cpuinfo  | wc -l)
export INSTALL_MOD_PATH=$(pwd)/mod/
mkdir -p $INSTALL_MOD_PATH

kernver=$(make kernelversion)
gitbranch=$(git rev-parse --abbrev-ref HEAD)
d=$(date +%Y%m%d)
gitrev=$(git rev-parse --short --verify $gitbranch)
export LOCALVERSION="-${gitbranch}"

export KDIR=$(pwd)

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
"clean")
  make clean
  cd cryptodev-linux
  make clean && cd -
  cd DX910-SW-99002-r8p1-00rel0/driver/src/devicedrv/mali/
  make clean && cd -
  ;;
"cryptodev")
  cd cryptodev-linux
  make KERNEL_DIR=${KDIR}
  ;;
"mali")
  cd DX910-SW-99002-r8p1-00rel0/driver/src/devicedrv/mali/
  KDIR=${KDIR} USING_UMP=0 BUILD=release make
  ;;
"install")
  cp uImage /media/$USER/BPI-BOOT/bananapi/bpi-r2/linux/
  sudo cp -r mod/lib/modules/4.9.44-bpi-r2+ /media/$USER/BPI-ROOT/lib/modules/
  sync
;;
"build")
  make ${CFLAGS}
  if [[ $? -eq 0 ]];then
    cat arch/arm/boot/zImage arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dtb > arch/arm/boot/zImage-dtb
    mkimage -A arm -O linux -T kernel -C none -a 80008000 -e 80008000 -n "Linux Kernel 4.9" -d arch/arm/boot/zImage-dtb ./uImage
    make modules_install
  fi
  ;;
*)
echo "This tool support following building command:"
echo "--------------------------------------------------------------------------------"
echo "  importconfig, import default configt and kernel and pack to download images."
echo "  config, kernel configure."
echo "  clean, clean all build."
echo "  cryptodev, build cryptodev kernel module."
echo "  mali, build mali kernel module."
echo "  install, copy kernel image and module into a mount SD"
echo "  build, build kernel image and module, cryptodev, mali"
echo "--------------------------------------------------------------------------------"
  ;;
esac
