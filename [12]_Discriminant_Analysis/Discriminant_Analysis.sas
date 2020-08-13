*ods html close; 
*ods preferences;
*ods html newfile=proc;
/* read in and view skull data set */
data skulls;
  infile '' expandtabs;
  input length width height faceheight facewidth;
  if _n_ < 18 then type='A';
    else type='B';
run;
proc print data=skulls;
run;
/* obtain the discriminant and classification counts and errors using the resulting
  explanatory term */
proc discrim data=skulls out=outresub outd=outdens pool=test 
manova list simple wcov;
   class type;
   var length;
run;
/* create a data set containing the posterior probabilities for each data point and each group */
data postprobs;
	set outresub;
	g = 'A'; prob = A; output;
    g = 'B'; prob = B; output;
run;
/* sort based on length so we can use a series plot to visualize the probabilities */
proc sort data=postprobs;
	by length;
run;
/* look at the relevant variables in the data set */
proc print data=postprobs;
	var length type g prob;
run;
/* plot the posterior probabilities by group */
proc sgplot data=postprobs;
	series x=length y=prob / group=g;
run;
/* create a data set containing the densities for each data point and each group */
data densities;
	set outdens;
	g = 'A'; dens = A; output;
    g = 'B'; dens = B; output;
run;
/* sort based on length so we can use a series plot to visualize the densities */
proc sort data=densities;
	by length;
run;
/* look at the relevant variables in the data set */
proc print data=densities;
	var length type g dens;
run;
/* plot the densities by group */
proc sgplot data=densities;
	series x=length y=dens / group=g;
run;
/* use leave-one-out cross-validation */
proc discrim data=skulls pool=test 
   manova list simple wcov crossvalidate;
   class type;
   var length;
   ods select ClassifiedCrossVal ErrorCrossVal;
run;
/* Exercise: repeat assuming proportional prior probabilities*/
proc discrim data=skulls out=outresubp outd=outdensp manova;
   class type;
   var length;
   priors proportional;
   ods select ClassifiedResub ErrorResub;
run;
/* create a data set containing the posterior probabilities for each data point and each group */
data postprobsp;
	set outresubp;
	g = 'A'; prob = A; output;
    g = 'B'; prob = B; output;
run;
/* sort based on length so we can use a series plot to visualize the probabilities */
proc sort data=postprobsp;
	by length;
run;
/* look at the relevant variables in the data set */
proc print data=postprobsp;
	var length type g prob;
run;
/* plot the posterior probabilities by group */
proc sgplot data=postprobsp;
	series x=length y=prob / group=g;
run;
/* create a data set containing the densities for each data point and each group */
data densitiesp;
	set outdensp;
	g = 'A'; dens = A; output;
    g = 'B'; dens = B; output;
run;
/* sort based on length so we can use a series plot to visualize the densities */
proc sort data=densitiesp;
	by length;
run;
/* look at the relevant variables in the data set */
proc print data=densitiesp;
	var length type g dens;
run;
/* plot the densities by group */
proc sgplot data=densitiesp;
	series x=length y=dens / group=g;
run;
/* use leave-one-out cross-validation */
proc discrim data=skulls crossvalidate;
   class type;
   var length;
   priors proportional;
   ods select ClassifiedCrossVal ErrorCrossVal;
run;
/* univariate iris */
/* the following is based on "Example 32.1 Univariate Density Estimates and Posterior Probabilities"
   from the DISCRIM Procedure documentation */
/* following is the "test" data set generated in the documentation */
/* this data will be used to construct plots of the densities and 
   posterior probabilities */
data plotdata;
   do PetalWidth=-5 to 30 by 0.5;
      output;
   end;
run;
/* plotdata is used as a test data set so the classification results over a range of
  petal width values can be written out to data sets */
/* the testout data set will include results for the test data, including posterior probabilities */
/* the testoutd data set will contain density values rather than posterior probabilities */
proc discrim data=sashelp.iris method=normal pool=yes
       testdata=plotdata testout=plotp testoutd=plotd
	   short noclassify crosslisterr;
   class Species;
   var PetalWidth;
run;
/* obtain posterior probabilities for each species */
data irisprobs;
	set plotp;
	g = 'Setosa    '; prob = setosa;     output;
    g = 'Versicolor'; prob = versicolor; output;
    g = 'Virginica '; prob = virginica;  output;
run;
proc print data=irisprobs;
run;
/* plot the posterior probabilities by group */
proc sgplot data=irisprobs;
	series x=PetalWidth y=prob / group=g;
run;
/* create a data set containing the densities for each data point and each group */
data irisdens;
	set plotd;
	g = 'Setosa    '; dens = setosa;     output;
    g = 'Versicolor'; dens = versicolor; output;
    g = 'Virginica '; dens = virginica;  output;
run;
proc print data=irisdens;
run;
/* sort based on PetalWidth so we can use a series plot to visualize the densities */
proc sort data=irisdens;
	by PetalWidth;
run;
/* plot the densities by group */
proc sgplot data=irisdens;
	series x=PetalWidth y=dens / group=g;
run;
/* repeat the same steps, but first test for equality of covariance */
/* if equality is rejected (and it will be here...), QDA will be used */
proc discrim data=sashelp.iris method=normal pool=test
       testdata=plotdata testout=plotpQ testoutd=plotdQ
	   short noclassify crosslisterr;
   class Species;
   var PetalWidth;
run;
data irisprobsQ;
	set plotpQ;
	g = 'Setosa    '; prob = setosa;     output;
    g = 'Versicolor'; prob = versicolor; output;
    g = 'Virginica '; prob = virginica;  output;
run;
* plot the posterior probabilities by group;
proc sgplot data=irisprobsQ;
	series x=PetalWidth y=prob / group=g;
run;
* create a data set containing the posterior probabilities for each data point and each group;
data irisdensQ;
	set plotdQ;
	g = 'Setosa    '; dens = setosa;     output;
    g = 'Versicolor'; dens = versicolor; output;
    g = 'Virginica '; dens = virginica;  output;
run;
proc print data=irisdens;
run;
* sort based on PetalWidth so we can use a series plot to visualize the densities;
proc sort data=irisdensQ;
	by PetalWidth;
run;
* plot the densities by group;
proc sgplot data=irisdensQ;
	series x=PetalWidth y=dens / group=g;
run;
/* bivariate iris */
/* will look at parts of "Example 32.2 Bivariate Density Estimates 
  and Posterior Probabilities" in the SAS help */
/* classify skull types based on the 5 explanatory variables,
   test for equality of covariances, perform manova test, 
   and use cross-validation*/
proc discrim data=skulls pool=test crossvalidate manova;
  	class type;
  	var length--facewidth;
	ods select ChiSq MultStat ClassifiedCrossVal ErrorCrossVal;
run;
/* use stepwise selection to extract most significant explanatory variables */
proc stepdisc data=skulls sle=.05 sls=.05;
   	class type;
   	var length--facewidth;
	ods select Summary;
run;
/* discriminant analysis with the terms chosen by stepdisc*/
proc discrim data=skulls pool=test crossvalidate;
  	class type;
  	var faceheight;
   	ods select ChiSq ClassifiedCrossVal ErrorCrossVal;
run;
proc discrim data=skulls pool=test crossvalidate;
  	class type;
  	var faceheight;
   	priors proportional;
   	ods select ClassifiedCrossVal ErrorCrossVal;
run;
/* training and test sets */
/* have seen some use use of test sets to create plots in the iris example
   will see more realistic example via 
   "Example 32.4 Linear Discriminant Analysis of Remote-Sensing Data on Crops"
   in the docs
*/

