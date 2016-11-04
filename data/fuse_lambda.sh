#!/bin/bash

#USAGE: ./fuse.sh instance_name lambda1 lambda2

#inputs
instance=$1
l1=$2
l2=$3

sed '$d' ${instance}_pref.dat > ${instance}_fuse.dat
echo "param lambda1:=${l1};">> ${instance}_fuse.dat
echo "param lambda2:=${l2};">> ${instance}_fuse.dat
cat ${instance}_room.dat >> ${instance}_fuse.dat
