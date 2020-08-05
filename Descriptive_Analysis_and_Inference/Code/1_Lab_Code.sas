/* Stat 448 Lab 1 Solutions-Week 1: Chapter 1 */

/* Set-ups */
/* Include the ods statements to close all html files and create
a new html file*/
/* Comments:
  At the beginning, you can use “ods html close” to close all the existing html files, so that
  the upcoming results would be written into a new, editable file.
  When creating the new file, you’ll need to specify the path.
  At the end of your codes, it’s also advisable to add “ods html close” to ensure that the file
  you generated is editable. 
*/

ods html close; 
ods preferences;
/* You need to modify the path for your files */
ods rtf file='/folders/myfolders/Stat 448 SAS codes/Week_1/Chapter1LabSolutions.rtf';


/* Data Generation*/
/* Comments:
  The following are some common methods that we use to generate data sets.
    1. define data set from raw data;
    2. import data set from some existing files using “infile” statement.
    3. import data set from some existing files and then generate some new variables.
  And there are three main modes of input:
    1. List
       by specifying a list of variable names;
    2. Column
       by specifying after each variable name the columns with the corresponding data values;
    3. Formatted
       by specifying after each variable name the input format.
*/

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
/* view data */ 
proc print data=bodyfat;
run;

* read in slimmingclub data using list format;
data slimmingclub;
  * modifiy path to match your files;
  infile '/folders/myfolders/Stat 448 Data/Week_1_data/slimmingclub.dat';
  input idno team $ startweight weightnow;
run;
/* view data with proc print */
proc print data=slimmingclub;
run;

* read in slimmingclub2 data using column format;
data slimmingclub2;
  * modifiy path to match your files;
  infile '/folders/myfolders/Stat 448 Data/Week_1_data/slimmingclub2.dat';
  input name $ 1-18 team $ 20-25 startweight 27-29 weightnow 31-33;
run;
/* view data */
proc print data=slimmingclub2;
run;

/* read in the same data using informats.
   note that this particular comment is written using the 
   slash-asterisk syntax for example purposes, 
   while the previous comments used the asterisk-semicolon syntax */
data slimmingclub3;
  * modifiy path to match your files;
  infile '/folders/myfolders/Stat 448 Data/Week_1_data/slimmingclub.dat';
  input name $19. team $7. startweight 4. weightnow 3.;
run;
/* view the data */
proc print data=slimmingclub3;
run;

/* add a new variable for the weight loss to the slimmingclub data set */
data slimmingclub;
	set slimmingclub;
	weightloss=startweight-weightnow;
run;
/* see that the variable has been added to the data set using proc print */
proc print data=slimmingclub;
run;


/* Data Selection */
/* Comments: 
  After generating the data set, we can select only a subset of observations or variables. 
  To select a subset of observations, we can use “where” statement and specify the conditions;
  To select a subset of variables, we can directly specify the variable names by using “var” 
  statement.
*/

/* construct and view a new data set containing only the women from the bodyfat data set */
data females;
	set bodyfat;
	where sex='F';
run;

/* similarly for an age range-- people in their 40's */
data forties;
  set bodyfat;
  where 39<age<50;
run;
proc print data=forties;
run;

/* begin proc examples */
/* just print age and pctfat variables using a var statement */
proc print data=bodyfat;
  var age pctfat;
run;

/* just print the female observations in the data set using where */
proc print data=bodyfat;
  where sex='F';
run;

/* just print age and pctfat for female observations */
proc print data=bodyfat;
  var age pctfat;
  where sex='F';
run;


/* Data Sorting */
/* Comments:
  We can also sort the data according to the values of some specific variable by using 
  “proc sort”. The variable used to sort the data needs to be specified after “by”.
*/

/* sort slimmingclub data by team */
proc sort data=slimmingclub;
  by team;
run;

/* print to see that the data set is now sorted */
proc print data=slimmingclub;
run;


/* Sample Mean */
/* Comments:
  The sample mean can be computed by “proc means”. 
  If only a subset of variables is of interest, you can specify them by the “var” statement.
  If there exist some categorical variables, you can compute the sample mean within each group 
  by using the “by” statement. Otherwise, the overall sample mean would be returned, i.e. 
  ignoring the categories.
*/

/* obtain means by team using proc means */
proc means data=slimmingclub;
	var weightloss;
	by team;
run;


/* Plotting */
/* Comments:
  Scatterplots can be drawn by using “proc sgplot”. You need to specify the variables to be 
  shown on the x-axis and y-axis, respectively. 
  If there exist some categorical variables, and you want the data in different groups to differ
  from each other, you can add “/ group = (variable name)” in the “scatter” statement. 
  Also, a regression line can be added by using the “reg” statement.
*/

/* produce a scatter plot of age vs. pctfat */
proc sgplot data=bodyfat;
  scatter y=pctfat x=age;
run;

/* add an option to plot the two genders separately */
proc sgplot data=bodyfat;
  scatter y=pctfat x=age /group=sex;
run;

/* add a linear regression line ignoring gender in the regression */
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