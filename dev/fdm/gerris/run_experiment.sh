#!/bin/bash
# Copyright (C) 2012 - 2013  Anders Gidenstam  (anders(at)gidenstam.org)
# This file is licensed under the GPL license version 2 or later.
#
# Usage: run_experiment.sh <base dir> <name base>

# Setup paths for gerris.
. /opt/Gerris/setpaths.sh

BASEDIR=$1
BASE=$2

cd ${BASEDIR}

for dir in $BASE*; do
  echo Running $dir
  (cd ${dir}; rm f; gerris3D buoyancy3D.gfs)
done;
