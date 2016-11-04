#!/bin/bash

#USAGE: ./fuse.sh instance_name epsilon

#inputs
instance=$1
epsilon=$2

sed '$d' ${instance}_pref.dat > ${instance}_fuse.dat
echo "param epsilon:=${epsilon};" >> ${instance}_fuse.dat
cat ${instance}_room.dat >> ${instance}_fuse.dat
