/* Homework 5 solution code for Stat 448, Summer 2020 at
   University of Illinois at Urbana Champaign */
options nodate nonumber;
title ;
ods rtf file=''
nogtitle startpage=no;
ods noproctitle;

data pottery;
    infile "" expandtabs;
	input ID Kiln Al Fe Mg Ca Na K Ti Mn Ba;
	drop ID;
run;

*Exercise 1;
proc princomp data=pottery plot=score(ellipse ncomp=3);
	var Al--Ba;
	id Kiln;
    ods select Screeplot Eigenvalues Eigenvectors ScorePlot;
run;

*Exercise 2;
proc princomp data=pottery plot=score(ellipse ncomp=2) cov;
	var Al--Ba;
	id Kiln;
    ods select ScreePlot TotalVariance Eigenvalues Eigenvectors ScorePlot;
run;

* Exercise 3;
* a;
proc cluster data=pottery method=average ccc pseudo;
	var Al--Ba;
	copy Kiln;
	ods select CccPsfAndPsTSqPlot Dendrogram;
run;

proc tree noprint ncl=3 out=clusout;
	copy Kiln Al--Ba;
run;
proc sort data=clusout;
	by cluster;
run;
proc means data=clusout;
	var Al -- Ba;
	by cluster;
run;

* b;
proc freq data=clusout;
	tables Cluster*Kiln/ nopercent norow nocol;
run;


* Exercise 4;
* a;
proc cluster data=pottery method=average std ccc pseudo print=15;
	var Al--Ba;
	copy Kiln;
	ods select CccPsfAndPsTSqPlot Dendrogram;
run;

proc tree noprint ncl=3 out=clusout2;
	copy Kiln Al--Ba;
run;

proc sort data=clusout2;
	by cluster;
run;
proc means data=clusout2;
	var Al -- Ba;
	by cluster;
run;

* b;
proc freq data=clusout2;
	tables Cluster*Kiln/ nopercent norow nocol;
run;

ods rtf close;
