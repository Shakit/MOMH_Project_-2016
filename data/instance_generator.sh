#!/bin/bash

#USAGE: ./instance_generator.sh instance_name nb_industrialist nb_researcher nb_rooms nb_hours

#inputs
instance=$1
industrialists=$2
researchers=$3
rooms=$4
hours=$5

g++ instance_generator_v2_gnu.cpp -o pref_gnu.exe
g++ room_generator_v2_gnu.cpp -o room_gnu.exe
g++ instance_generator.cpp -o pref.exe
g++ room_generator.cpp -o room.exe
seed=100
for i in {1..5}
do
./pref_gnu.exe --seed ${seed} --sci ${researchers} --inge ${industrialists} --hor ${hours} --name ${instance}_${i}_pref.dat
./room_gnu.exe --seed ${seed} --nbr ${rooms} --name ${instance}_${i}_room.dat
    seed=$((seed + 10))
./pref.exe --seed ${seed} --sci ${researchers} --inge ${industrialists} --name ${instance}_${i}_pref.xml
./room.exe --seed ${seed} --nbr ${rooms} --name ${instance}_${i}_room.xml
seed=$((seed + 10))
done