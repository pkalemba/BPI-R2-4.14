#!/bin/bash
export CROSS_COMPILE=arm-linux-gnueabihf-
export ARCH=arm
export INSTALL_MOD_PATH=$(pwd)/mod/
mkdir -p $INSTALL_MOD_PATH

case $1 in

"importconfig")
  make mt7623n_evb_bpi_defconfig
  ;;
"config")
  make menuconfig
  ;;
*)
  make
  make modules_install
  ;;
esac
