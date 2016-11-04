#!/bin/bash

#USAGE: ./2_phase.sh instance

#inputs
instance=$1
echo "x:y" > ${instance}_results.txt

./fuse.sh ${instance} 0

#find best f
glpsol --model f_model.mod --data ${instance}_fuse.dat --display results.txt
b=`cat results.txt`
./fuse.sh ${instance} 0
#lex2 optimal
glpsol --model f_constrain_model.mod --data ${instance}_fuse.dat --display results.txt
#save the solution found
cat results.txt >> ${instance}_results.txt

echo "$b"
./fuse.sh ${instance} $b
#lex1 optimal
glpsol --model g_constrain_model.mod --data ${instance}_fuse.dat --display results.txt
#save the solution found
cat results.txt >> ${instance}_results.txt

f1=`cat f1.txt`
f2=`cat f2.txt`
g1=`cat g1.txt`
g2=`cat g2.txt`

./solve_recu.sh ${instance} f1 g1 f2 g2
