#!/bin/bash
kerneldir=$(dirname $(pwd))
logfile=build.log
#echo $kerneldir
bld=debug
#bld=release
ump=0
#ump=1

export ARCH=arm;export CROSS_COMPILE=arm-linux-gnueabihf-
cd src/devicedrv
ret=0
if [[ $ump -eq 1 ]];then
  #first build ump-driver
  cd ump
  ret=1
  KDIR=$kerneldir CONFIG=default BUILD=$bld make 2> >( tee "$logfile" ) && ret=0
  cd ..
fi
if [[ $ret -eq 0 ]];then
  echo "building mali-driver"
  cd mali
  ret=1
  KDIR=$kerneldir USING_UMP=$ump BUILD=$bld make 2> >( tee "$logfile" ) && ret=0
fi
