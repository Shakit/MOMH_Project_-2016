#!/bin/bash

#USAGE: ./solve_recu.sh instance f1 g1 f2 g2

#inputs
instance=$1
f1=$2
g1=$3
f2=$4
g2=$5

#calcul lambda
l1=$(($g1 - $g2))
l2=$(($f1-$f2))

echo "lambda1 = $l1"
echo "lambda2 = $l2"
./fuse_lambda.sh ${instance} $l1 $l2
#solve the first sub problem to find the next epsilon
glpsol --model lambda_model.mod --data ${instance}_fuse.dat --display results.txt
#save the solution found
cat results.txt >> ${instance}_results.txt
fx=`cat fx.txt`
gx=`cat gx.txt`
x=$(($l2*$gx-$l1*$fx))
x1=$(($l2*$g1-$l1*$f1))
echo "$x"
echo "$x1"
if [ $x1 -gt $x ]
then
   ./solve_recu.sh $f1 $g1 $fx $gx
   ./solve_recu.sh $fx $gx $f2 $g2
fi
