/* Stat 448 UIUC Summer 2020 */
options nodate nonumber;
title;
ods noproctitle;
data crime100;
    infile '' expandtabs;
    input R Age S Ed Ex0 Ex1 LF M N NW U1 U2 W X;
	if R>100 then Greater100 = 'yes';
	if R<=100 then Greater100 = 'no';
	If S = 1 then South = 'yes';
	if S = 0 then South = 'no';
	keep greater100 South;
run;
data haireyes;
	input eyecolor $ haircolor $ count;
	datalines;
	light fair 688
	light medium 584
	light dark 188
	medium fair 343
	medium medium 909
	medium dark 412
	dark fair 98
	dark medium 403
	dark dark 681
	;
data heartbpchol;
	set sashelp.heart;
	where status='Alive' and AgeCHDdiag ne . and Chol_Status ne ' ';
	keep Cholesterol and BP_Status;
run;
/* Exercise 1 */
proc freq data=crime100;
	table South*Greater100/chisq riskdiff expected nocol nopercent;
	ods select CrossTabFreqs ChiSq RiskDiffCol1 FishersExact;
run;
/* Exercise 2 */
proc freq data=haireyes order=data;
	table eyecolor*haircolor/chisq expected nocol nopercent;
	weight count;
	ods select CrossTabFreqs ChiSq;
run;
proc freq data=haireyes order=data;
	table eyecolor*haircolor/chisq expected nocol nopercent riskdiff;
	weight count;
	where eyecolor ne '	dark' and haircolor ne 'dark';
	ods select CrossTabFreqs ChiSq RiskDiffCol1;
run;
/* Exercise 3*/
proc anova data=heartbpchol;
	class BP_Status;
	model Cholesterol = BP_Status;
	means BP_Status/ hovtest tukey cldiff;
	ods select HOVFTest ModelANOVA OverallANOVA FitStatistics CLDiffs;
run;
ods rtf close;
