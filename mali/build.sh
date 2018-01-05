#!/bin/bash
kerneldir=$(dirname $(pwd))
logfile=build.log
#echo $kerneldir
bld=debug
#bld=release

export ARCH=arm;export CROSS_COMPILE=arm-linux-gnueabihf-
cd src/devicedrv

#first build ump-driver
cd ump
ret=1
KDIR=$kerneldir CONFIG=default BUILD=$bld make 2> >( tee "$logfile" ) && ret=0
if [[ -z $ret ]];then
  echo "building mali-driver"
  cd ../mali
  ret=1
  KDIR=$kerneldir USING_UMP=1 BUILD=$bld make 2> >( tee "$logfile" ) && ret=0
fi
