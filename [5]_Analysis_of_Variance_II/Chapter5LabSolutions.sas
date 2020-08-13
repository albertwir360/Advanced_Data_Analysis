options nodate nonumber;
title;
ods rtf file='' nogtitle startpage=no;
ods noproctitle;
/* create the data set */
data ozkids;
	* modify path to point to your files;
	infile '' dlm=' ,' expandtabs missover;
    input cell origin $ sex $ grade $ type $ days @;
	do until (days=.);
	  output;
	  input days @;
	end;
	input;
run;
/* see data */
proc print data=ozkids;
run;
/* get cell means and counts for days absent */
proc tabulate data=ozkids;
	class cell;
	var days;
	table cell,
		days*(mean n);
run;
/* four-way cross-tabulation */
proc tabulate data=ozkids;
	class origin sex grade type;
	var days;
	table origin*sex*grade*type,
		days*(mean n);
run;
/* fit the two-way main effects model with origin and grade */
proc glm data=ozkids;
	class origin grade;
	model days = origin grade;
run;
/* switch the order of terms */
proc glm data=ozkids;
	class grade origin;
	model days = grade origin;
	ods select IntPlot;
run;
/* add the interaction term */
proc glm data=ozkids;
	class origin grade;
	model days = origin|grade;
run;
/* switch ordering of main effects */
proc glm data=ozkids;
	class grade origin;
	model days = grade|origin;
	ods select IntPlot;
run;
/* four-way main effects getting only Type III SS and the resulting ANOVA tables and fit statistics */
proc glm data=ozkids;
	class origin sex grade type;
	model days = origin sex grade type/ ss3;
	ods select OverallANOVA FitStatistics ModelANOVA;
run;
/* get all the one-way results */
proc anova data=ozkids;
	class origin;
	model days = origin;
	ods select OverallANOVA FitStatistics ModelANOVA;
run;
proc anova data=ozkids;
	class sex;
	model days = sex;
	ods select OverallANOVA FitStatistics ModelANOVA;
run;
proc anova data=ozkids;
	class grade;
	model days = grade;
	ods select OverallANOVA FitStatistics ModelANOVA;
run;
proc anova data=ozkids;
	class type;
	model days = type;
	ods select OverallANOVA FitStatistics ModelANOVA;
run;
/* best main effects and all interactions between them;
   get Tukey tests for least squares means and main effect means */
/* add plots=diagnostics to also obtain model diagnostics*/
proc glm data=ozkids plots=diagnostics;
	class origin grade;
	model days= origin|grade;
	lsmeans origin|grade/pdiff=all cl;
	ods select OverallANOVA ModelANOVA LSMeans LSMeanDiffCL DiagnosticsPanel;
run;
/* consider model with all categorical variables and interactions and get the type I and type III sums of squares */
proc glm data=ozkids;
	class origin sex grade type;
	model days=origin|grade|sex|type/ ss1 ss3;
	ods select OverallANOVA ModelANOVA;
run;
ods rtf close;