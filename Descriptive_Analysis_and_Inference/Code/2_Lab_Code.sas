ods rtf file='/folders/myfolders/Stat 448 SAS codes/Week_1/Chapter2LabSolutions.rtf';
/********
In this analysis, we will be examining a dataset of mortality rates and water
hardness in various English towns. Each record in the dataset contains four
variables: “Town”, which is a string for the name of the town; “Mortal”, which
is a numeric value corresponding to the mortality rate; “Hardness”, which is a
numeric score of the water hardness; and “location”, which details whether the
town is in north or south England.
********/
* read in the data and create a water data set;
data water;
    infile '/folders/myfolders/Stat 448 Data/Week_1_data/water.dat';
    input flag $ 1 Town $ 2-18 Mortal 19-22 Hardness 25-27;
    if flag='*' then location='north';
        else location='south';
run;
proc print data=water;
run;
/********
Let us first conduct an exploratory analysis of the data by looking at a
scatter plot and some summary statistics.
********/
* get a scatter plot of hardness vs. mortality;
proc sgplot data=water;
  scatter y=mortal x=hardness;
run;
/********
From the scatter plot, we observe a general negative trend in Mortality as
Hardness increases. The trend appears roughly linear, with a moderately strong
correlation between the two variables.
********/
/* get basic univariate results for mortality and hardness individually */
proc univariate data=water;
  var mortal hardness;
run;
/********
The mortal variable has a mean of 1520 and a standard deviation of 188. As the
median of 1555, the variable exhibits a slight negative skew of -0.0844. In this
sampled data, multiple modes were detected. However, we note that this does not
necessarily preclude the population distribution from being unimodal (and thus
normal).
********/
/********
The t-test against the null hypothesis that the true population mean equals 0 is
highly significant. The p-value of <.0001 suggests that there is very strong
evidence of the true population mean not being equal to 0.
********/
/********
There does not appear to be anything particularly noteworthy about the quantiles
or extreme observations. The quantiles seem to be located roughly symmetrically
around the median, so there is nothing to suggest that the population
distribution is not symmetric.
********/
/********
The mean for hardness is 47.2, and the standard deviation is 38.1. The mean does
seem somewhat greater than the median of 39.0, which is reflected in the
positive value for skewness, 0.692.
********/
/********
Again, the t-test shows that there is very strong evidence that the true
population mean is not equal to 0.
********/
/********
The quantiles for hardness reflect the positive skew of the sample. For example,
the first quantile is 25 units less than the median, but the third quantile is
36 units greater than the median. This is also reflected in the values for the
extreme observations. A variance-stabilizing transformation (e.g. taking the
logarithm) may be appropriate for this variable.
********/
* add univariate visualizations;
proc univariate data=water;
  var mortal hardness;
  histogram mortal hardness;
  probplot mortal hardness;
  * add ods statement to just grab the plots;
  ods select Histogram ProbPlot;
run;
/********
Both of the plots for Mortal reflect similar findings to those discerned from
the summary statistics. Since the Q-Q plot shows that the true percentiles
closely match the percentiles expected if Mortal were distributed normally,
there is no evidence against an assumption that Mortal is indeed normally
distributed.
********/
/********
The histogram provides a good visual indicator of the magnitude by which
Hardness is positively skewed. The Q-Q plot’s notable “S” shape also reflects
this, and visually representats the findings from our previous examination of
the quantiles for hardness.
********/
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
/********
In the above tests, we compute quantitative measures for adherence or departure
from normality. The plots are the same as those generated in the previous
section, except that the histograms also display a fitted normal distribution.
We can see from these fitted curves that the sample distribution for Mortal
closely matchs the curve for the fitted normal distribution, while the converse
is true for Hardness.
********/
/********
Similarly, none of the quantitative tests against the normality assumption are
significant at the 0.05 significance level for Mortal, but they are all
significant (all with p-values <0.01) for Hardness. This means that for
Hardness, the Goodness-of-Fit tests find significant evidence that the variable
does not follow a normal distribution.
********/
/********
Although the scatter plot showed a roughly linear trend between Hardness and
Mortal, it also shows that there is greater variance in Hardness as Mortal
decreases. This corroborates our subsequent findings that a variance-stabilizing
transformation may be appropriate for Hardness. This also means that it may be
prudent to use the Spearman correlation values, rather than the Pearson
correlation values. However, the Pearson and Spearman correlation values are
very similar anyway, with values of about -0.65, and are both highly
significant.
********/
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
/********
In this section, our findings for hardness and mortality are similar when
subsetting by town location (e.g. Mortal for North towns alone is still roughly
normal). Therefore, we will concentrate our analysis on comparisons between
North and South towns.
********/
* univariate results by location (will need to sort by location first....);
proc sort data=water;
  by location;
run;
/********
The scatter plot shows that at any given Hardness level, mortality is generally
greater for towns in the north than in the south. Likewise, at any given Mortal
level, water hardness is generally greater for towns in the north than in the
south.
********/
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
/********
In the above t-tests, we compare the means of Mortal for towns in the north and
south. The equality of variances F-test is not significant, indicating that an
assumption of equal variances is probably appropriate. Since the 95% confidence
intervals for the difference between the two means does not contain 0 (using
both the pooled and Satterthwaite estimates of variance), there is evidence at
the 0.05 significance level that the true population means for mortality are
different between north and south towns.
********/
/********
The above plot corroborates the findings of the previous t-test. We note again
that the samples follow a roughly normal distribution, this time illustrated
with a dashed curve generated using kernel density estimation.
********/
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
/********
For the Hardness variable, we compare north and south towns using the Wilcoxon
signed-rank test, which is a non-parametric test not requiring any assumptions
of normality. The test is significant at the 0.05 significance level, indicating
that there is evidence that the true population means for Hardness differ
between north and south towns.
********/
/********
The box plots corroborate the findings of the Wilcoxon signed-rank test. The
medians are substantially different, and even the samples’ interquartile ranges
barely overlap each other.
********/
/********
The above plots show that the densities estimated using kernel density
estimation are substantially different from the fitted normal curves. This
follows from our previous findings of substantial departure from normality for
the Hardness variable.
********/
