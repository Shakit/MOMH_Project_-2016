#glpsol --model resol_exact.mod --data fusion.dat

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
var y{s in S,t in S,i in I,h in H2} binary;
var z{s in S,t in S,r in R,h in H2} binary;
var w{s in S,h in H2} integer;
var g integer;

maximize f: sum{i in I, r in R, s in S, h in H} (p[i,r]+p_prim[r,i])*x[i,r,s,h];

subject to
	c1 {i in I, h in H}: sum{r in R, s in S} x[i,r,s,h] <= 1;
	c2 {r in R, h in H}: sum{i in I, s in S} x[i,r,s,h] <= 1;
	c3 {s in S, h in H}: sum{i in I, r in R} x[i,r,s,h] <= 1;
	c4 {i in I, r in R}: sum{s in S, h in H} x[i,r,s,h] <= 1;

	c5 {s in S,t in S,i in I,h in H2}: sum{r in R} (x[i,r,s,h-1]+x[i,r,t,h])<=y[s,t,i,h]+1;
	c6 {s in S,t in S,r in R,h in H2}: sum{i in I} (x[i,r,s,h-1]+x[i,r,t,h])<=z[s,t,r,h]+1;
	c7 {s in S, h in H2}: sum{t in S} d[s,t]*(sum{i in I} y[t,s,i,h] + sum{r in R} z[t,s,r,h]) <= w[s,h];
	c8: g = sum{s in S,h in H2} (w[s,h]);
	e1: sum{s in S, h in H2} w[s,h]<=epsilon;
solve;
printf: "%.3f:%.3f",f,g;
end
