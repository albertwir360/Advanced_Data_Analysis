ods rtf file=''; 
* read in the data and create a water data set;
data water;
    infile '';
    input flag $ 1 Town $ 2-18 Mortal 19-22 Hardness 25-27;
    if flag='*' then location='north';
        else location='south';
run;
proc print data=water;
run;
* get a scatter plot of hardness vs. mortality;
proc sgplot data=water;
  scatter y=mortal x=hardness;
run;
/* get basic univariate results for mortality and hardness individually */
proc univariate data=water;
  var mortal hardness;
run;
* add univariate visualizations;
proc univariate data=water;
  var mortal hardness;
  histogram mortal hardness;
  probplot mortal hardness;
  * add ods statement to just grab the plots;
  ods select Histogram ProbPlot;
run;
/* one sample t tests assume an underlying normal population, 
   so should check if that assumption seems reasonable 
   if we want to use a t test for location;
   option to histogram  for general EDF tests */
proc univariate data=water;
  var mortal hardness;
  histogram mortal hardness /normal;
  probplot mortal hardness;
  ods select Histogram ProbPlot GoodnessOfFit; 
run;
* option to proc;
proc univariate data=water normal;
  var mortal hardness;
  ods select TestsForNormality;
run;
/* use both options to get a histogram and pdf, and to see difference in tests */
proc univariate data=water normal;
  var mortal hardness;
  histogram mortal hardness /normal;
  ods select Histogram GoodnessOfFit TestsForNormality;
run;
* check correlations;
proc corr data=water;
  var mortal hardness;
run;
proc corr data=water pearson spearman;
  var mortal hardness;
  ods select PearsonCorr SpearmanCorr;
run;
* scatter plots by location;
proc sgplot data=water;
  scatter y=mortal x=hardness /group=location;
run;
* univariate results by location (will need to sort by location first....);
proc sort data=water;
  by location;
run;
proc univariate data=water normal;
  var mortal hardness;
  histogram mortal hardness /normal;
  probplot mortal hardness;
  by location; 
  ods select Moments BasicMeasures Histogram ProbPlot TestsForNormality;
run;
* correlations by location;
proc corr data=water pearson spearman;
  var mortal hardness;
  by location;
  ods select PearsonCorr SpearmanCorr;
run;
/* location test for mortal and hardness by geographic location with mu0=1500 45 */
proc univariate data=water mu0=1500 45 normal;
  var mortal hardness;
  by location; 
  ods select TestsForNormality TestsForLocation;
run;
/* location test for mortality ignoring geographic location */
proc univariate data=water mu0=1500;
  var mortal;
  ods select TestsForLocation;
run;
/* just the t-test using proc ttest */
proc ttest data=water h0=1500;
  var mortal;
  ods select ConfLimits TTests;
run;
/* again, this could be done by location to test the north and south samples separately */
proc ttest data=water h0=1500;
  var mortal;
  by location;
  ods select ConfLimits TTests;
run;
/* one-sided test to see if mortality is significantly greater than the null value */
proc ttest data=water h0=1500 sides=u;
  var mortal;
  by location;
  ods select ConfLimits TTests;
run;
/* t-test for equal mean mortality in each geographic location */
proc ttest data=water;
  class location;
  var mortal;
run;
/* demonstrate upper and lower tailed tests */
proc ttest data=water sides=u;
  class location;
  var mortal;
  ods select ConfLimits TTests Equality;
run;
proc ttest data=water sides=l;
  class location;
  var mortal;
  ods select ConfLimits TTests Equality;
run;
* rank sum test for calcium concentration;
proc npar1way data=water wilcoxon;
  class location;
  var hardness;
  ods exclude KruskalWallisTest;
run;
* add variable for log of hardness to data set;
data water;
  set water;
  lhardnes=log(hardness);
run;
* check normality assumption for entire sample 
  if we wanted to perform a test on the entire population;
proc univariate data=water normal;
  var lhardnes;
  ods select TestsForNormality;
run;
* test by group (geographic location in this case) if 
  we want to test for group differences;
proc univariate data=water normal;
  var lhardnes;
  by location;
  ods select TestsForNormality;
run;
/* given the normality tests, we shouldn't trust a t-test;
   if we could trust a t-test, we could use the following
   and pick out any results of interest */ 
proc ttest data=water;
  class location;
  var lhardnes;
run;
/* a rank based test could be used on lhardnes, but the results will be the
   same as for hardness because log will not change the order of the data values, 
   so the ranks will not change */
proc npar1way data=water wilcoxon;
  class location;
  var lhardnes;
  ods exclude KruskalWallisTest;
run;
