#!/bin/bash
# Copyright (C) 2012 - 2013  Anders Gidenstam  (anders(at)gidenstam.org)
# This file is licensed under the GPL license version 2 or later.
#
# Usage: summarize_experiment.sh <base dir>/<name base>


BASE=$1

# Hydrodynamic reference point [m].
HRPX=14.0
HRPZ=1.0

ROLLRANGE="   -15    -10    -5     0     5     10     15"
PITCHRANGE="-20 -10 -5 0 5 10 20"

# Height offset above the HRP [m]. Input on the command line.
#HAGL=

# Note: We are only interested in 
#  z force and pitch and roll moment.
#  Output formatted as JSBSim tables with pitch angle
#  as row and roll angle as column index.
#
#  The resulting "coefficients" are scaled for imperial units
#  and expressed as
#    F/(Rho*G) and M/(Rho*G)

echo "Z Force (pitch, roll)"
echo ${ROLLRANGE}
for pitch in ${PITCHRANGE}; do
  ROW=${pitch}
  for roll in ${ROLLRANGE}; do
    dir=${BASE}_r${roll}_p${pitch}
    ROW=${ROW}`awk 'BEGIN {
            U = 40.0*3.2808399; Rho = 1.0; G = 1.0;
            k_F = U^3 * Rho * G;
            k_M = -U^4 * Rho * G;
          }
          /[0-9]*\.0/ { print "   " k_F*$4; }' ${dir}/f`
  done;
  echo ${ROW}
done;
echo;

echo "Y Moment (pitch, roll) (~pitch moment)"
echo ${ROLLRANGE}
for pitch in ${PITCHRANGE}; do
  ROW=${pitch}
  for roll in ${ROLLRANGE}; do
    dir=${BASE}_r${roll}_p${pitch}
    ROW=${ROW}`awk 'BEGIN {
             U = 40.0*3.2808399; Rho = 1.0; G = 1.0;
             k_F = -U^3 * Rho * G;
             k_M = -U^4 * Rho * G;
           }
           /[0-9]*\.0/ { print "   " k_M*$9; }' ${dir}/f`
  done
  echo ${ROW}
done;
echo;

echo "Z Moment (pitch, roll) (~roll moment)"
echo ${ROLLRANGE}
for pitch in ${PITCHRANGE}; do
  ROW=${pitch}
  for roll in ${ROLLRANGE}; do
    dir=${BASE}_r${roll}_p${pitch}
    ROW=${ROW}`awk 'BEGIN {
             U = 40.0*3.2808399; Rho = 1.0; G = 1.0;
             k_F = -U^3 * Rho * G;
             k_M = -U^4 * Rho * G;
           }
           /[0-9]*\.0/ { print "   " k_M*$10; }' ${dir}/f`
  done
  echo ${ROW}
done;
echo;
