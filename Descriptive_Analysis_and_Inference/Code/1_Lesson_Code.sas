* ods html close; 
* ods preferences;
* ods html newfile=proc;
ods rtf file='/folders/myfolders/Stat 448 SAS codes/Week_1/resultsweek1.rtf'; 
/* you will need to modify file paths to point to your data files 
  and write the rtf file to the appropriate place */
* define data set from raw data;
data bodyfat;
 input age pctfat sex $;
cards;
23  9.5 M
23 27.9 F
27  7.8 M
27 17.8 M
39 31.4 F
41 25.9 F
45 27.4 M
49 25.2 F
50 31.1 F
53 34.7 F
53 42.0 F
54 29.1 F
56 32.5 F
57 30.3 F
58 33.0 F
58 33.8 F
60 41.1 F
61 34.5 F
; 
* view data via proc print;
proc print data=bodyfat;
run;
* read in slimmingclub data using list format;
data slimmingclub;
  infile '/folders/myfolders/Stat 448 Data/Week_1_data/slimmingclub.dat';
  input idno team $ startweight weightnow;
run;
* view data;
proc print data=slimmingclub;
run;
* read in slimmingclub2 data using column format;
data slimmingclub2;
  infile '/folders/myfolders/Stat 448 Data/Week_1_data/slimmingclub2.dat';
  input name $ 1-18 team $ 20-25 startweight 27-29 weightnow 31-33;
run;
* view data;
proc print data=slimmingclub2;
run;
/* read in the same data using informats.
   note that this particular comment is written using the 
   slash-asterisk syntax for example purposes, 
   while the previous comments used the asterisk-semicolon syntax */
data slimmingclub3;
  infile '/folders/myfolders/Stat 448 Data/Week_1_data/slimmingclub2.dat';
  input name $19. team $7. startweight 4. weightnow 3.;
run;
* view the data;
proc print data=slimmingclub3;
run;
* add a new variable for the weight loss to the slimmingclub data set;
data slimmingclub;
  set slimmingclub;
  weightloss=startweight-weightnow;
run;
* see that the variable has been added to the data set;
proc print data=slimmingclub;
run;
* construct a new data set containing only the women from the bodyfat data set;
data women;
  set bodyfat;
  if sex='F';
run;
proc print data=women;
run;
* similarly for an age range;
data forties;
  set bodyfat;
  where 39<age<50;
run;
proc print data=forties;
run;
* begin proc examples;
* just print age and pctfat variables using a var statement;
proc print data=bodyfat;
  var age pctfat;
run;
* just print the female observations in the data set using where;
proc print data=bodyfat;
  where sex='F';
run;
* just print age and pctfat for female observations;
proc print data=bodyfat;
  var age pctfat;
  where sex='F';
run;
* sort slimming club data by team;
proc sort data=slimmingclub;
  by team;
run;
* print to see that the data set is now sorted;
proc print data=slimmingclub;
run;
* obtain means by team;
proc means data=slimmingclub;
	var weightloss;
	by team;
run;
* produce a scatter plot of age vs. pctfat;
proc sgplot data=bodyfat;
  scatter y=pctfat x=age;
run;
* add an option to plot the two genders separately;
proc sgplot data=bodyfat;
  scatter y=pctfat x=age /group=sex;
run;
* add a linear regression line ignoring gender in the regression;
proc sgplot data=bodyfat;
  scatter y=pctfat x=age /group=sex;
  reg y=pctfat x=age;
run;
/* leave out the data markers in the regression 
   plot so the markers from the grouped scatter plot
   do not get covered up... at least in the html result... */
proc sgplot data=bodyfat;
  scatter y=pctfat x=age /group=sex;
  reg y=pctfat x=age/ nomarkers;
run;
ods rtf close;
