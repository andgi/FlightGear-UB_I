#!/bin/bash
# Copyright (C) 2012 - 2013  Anders Gidenstam  (anders(at)gidenstam.org)
# This file is licensed under the GPL license version 2 or later.
#
# Usage: create_experiment.sh <base dir> <name base>

# Setup paths for gerris.
. /opt/Gerris/setpaths.sh

BASEDIR=$1
BASE=$2

# Hydrodynamic reference point [m].
HRPX=14.0
HRPZ=1.0

ROLLRANGE="-15 -10 -5 0 5 10 15"
PITCHRANGE="-20 -10 -5 0 5 10 20"

# HRP above water level [m].
HAGL=-4.572   # -15ft
#HAGL=-2.1336 # -7ft
#HAGL=-1.2192 # -4ft
#HAGL=-0.3048 # -1ft
#HAGL=0.6096  # 2ft
#HAGL=1.524   # 5ft

# Compute actual model offsets.
XOFFSET=`echo -$HRPX | bc`
ZOFFSET=`echo -$HRPZ | bc`

#echo $ZOFFSET
#exit

if [ ! -d ${BASEDIR} ]
then
  mkdir ${BASEDIR}
fi
cd ${BASEDIR}

for roll in ${ROLLRANGE}; do
  for pitch in ${PITCHRANGE}; do
    dir=${BASE}_r${roll}_p${pitch}
    mkdir ${dir}
    transform --tx=$XOFFSET --tz=$ZOFFSET  < ../UB_I.gts.base | transform --rx ${roll} | transform --ry ${pitch} | transform --tz=$HAGL -v  > ${dir}/UB_I.gts

    (cd ${dir}; ln -s ../../buoyancy3D.gfs . )
  done;
done;
