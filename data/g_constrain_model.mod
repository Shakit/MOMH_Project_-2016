#glpsol --model new_model.mod --data fusion.dat

param nbr;
param nbs;
param nbi;
param nbh;
param epsilon;
set I:=1..nbi;
set R:=1..nbr;
set S:=1..nbs;
set H:=1..nbh;
set H2:=2..nbh;

param p{i in I, r in R};
param p_prim{r in R, i in I};
param d{s in S, t in S};

var x{i in I,r in R,s in S,h in H} binary;
var y{i in I,h in H2};
var z{r in R,h in H2};
var f;

minimize g:  sum{h in H2}(sum{r in R} z[r,h] + sum{i in I} y[i,h]);

subject to
	c1 {i in I, h in H}: sum{r in R, s in S} x[i,r,s,h] <= 1;
	c2 {r in R, h in H}: sum{i in I, s in S} x[i,r,s,h] <= 1;
	c3 {s in S, h in H}: sum{i in I, r in R} x[i,r,s,h] <= 1;
	c4 {i in I, r in R}: sum{s in S, h in H} x[i,r,s,h] <= 1;

	c5 {s in S,t in S,i in I,h in H2}: d[s,t]*(sum{r in R} (x[i,r,s,h-1]+x[i,r,t,h]) - 1)<=y[i,h];
	c6 {s in S,t in S,r in R,h in H2}: d[s,t]*(sum{i in I} (x[i,r,s,h-1]+x[i,r,t,h])-1)<=z[r,h];
	
	c7 {i in I,h in H2}: y[i,h]>=0;
	c8 {r in R,h in H2}: z[r,h]>=0;
	c9: f =  sum{i in I, r in R, s in S, h in H} (p[i,r]+p_prim[r,i])*x[i,r,s,h];
	e1: f>=epsilon;
solve;
printf: "%.3f:%.3f\n",f,g;
printf: "%.3f",f > "f2.txt";
printf: "%.3f",g > "g2.txt";
end;
