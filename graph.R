#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
file.names<-args[1]

data<-read.table(file=file.names[1], header=TRUE, sep=":")
x<-data[,1]
y<-data[,2]
xmax<-max(x)*2
ymax<-max(y)*2
png(file="results.png", width=1600, heigh=800)
par(mfrow=c(1,1))
plot(x,y, main="Solutions", type="p",xlim=c(0,xmax), ylim=c(0,ymax), lwd = 5
, col="red")

#ceci est un commentaire