options nodate nonumber;
title;
ods noproctitle;
/* data for Exercise 1 */
data cardata;
	set sashelp.cars;
	keep cylinders origin type mpg_highway;
	where type not in('Hybrid','Truck','Wagon','SUV') and 
		cylinders in(4,6) and origin ne 'Europe';
run;
/* data for Exercise 2 */
/* based on data from Chapter 6 of A Handbook of Statistical Analyses Using SAS, Third Edition */
data drinking;
 input country $ 1-12 alcohol cirrhosis;
cards;
France        24.7  46.1
Italy         15.2  23.6
W.Germany     12.3  23.7
Austria       10.9   7.0
Belgium       10.8  12.3
USA            9.9  14.2
Canada         8.3   7.4
E&W            7.2   3.0
Sweden         6.6   7.2
Japan          5.8  10.6
Netherlands    5.7   3.7
Ireland        5.6   3.4
Norway         4.2   4.3
Finland        3.9   3.6
Israel         3.1   5.4
;
data logdrinking;
	set drinking;
	logcir = log(cirrhosis);
	drop cirrhosis;
run;
/* data for Exercise 3 */
data running;
  infile '';
  input name $ 1-13 run100 Ljump shot Hjump run400 hurdle discus polevlt javelin run1500 dscore;
  keep run100 run400 run1500;
run;
/* Exercise 1 */
proc tabulate data=cardata;
	class cylinders origin type;
	var mpg_highway;
	table cylinders*origin*type, mpg_highway*(mean std n);
run;
proc glm data=cardata;
	class cylinders origin type;
	model mpg_highway=cylinders origin type;
	ods select ModelAnova;
run;
proc glm data=cardata;
	class cylinders origin type;
	model mpg_highway=cylinders type;
	ods select OverallAnova ModelAnova FitStatistics;
run;
proc glm data=cardata;
	class cylinders origin type;
	model mpg_highway=cylinders|type;
	lsmeans cylinders type cylinders*type/ tdiff=all pdiff cl;
	ods select OverallAnova ModelAnova FitStatistics LSMeans 
		LSMeanDiffCL;
run;
/* Exercise 2 */
proc reg data=logdrinking;
	model logcir = alcohol;
	ods select DiagnosticsPanel;
run;
proc reg data=logdrinking;
	model logcir = alcohol;
	where country ne 'France';
	ods select ANOVA FitStatistics ParameterEstimates DiagnosticsPanel;
run;
/* Exercise 3 */
proc reg data=running;
	model run400=run100;
	output out=runningcd CookD=cd;
	ods select DiagnosticsPanel;
run;
proc reg data=runningcd;
	model run400=run100;
	where cd<.2;
	ods select ANOVA FitStatistics ParameterEstimates DiagnosticsPanel;
run;
proc reg data=running;
	model run400=run1500;
	ods select ANOVA FitStatistics ParameterEstimates DiagnosticsPanel;
run;
ods rtf close;
