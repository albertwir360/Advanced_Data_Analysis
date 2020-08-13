/* Solution code for Homework 1 in Stat 448 at 
   University of Illinois, Summer 2020 */
ods html close; 
options nodate nonumber;
title;
ods noproctitle;
/* The raw data in housing.data is from
   and described on https://archive.ics.uci.edu/ml/datasets/Housing
   Bache, K. & Lichman, M. (2013). UCI Machine Learning Repository 
   [http://archive.ics.uci.edu/ml]. Irvine, CA: University of California, 
   School of Information and Computer Science.
*/
data wines;
	infile '' delimiter=',';
	input Alcohol Malic Ash Alcalinity Magnesium Totalphenols Flavanoids 
			Nonflavanoids Proanthocyanins Color Hue OD280315 Proline;
	keep Alcohol Color Hue Alcalinity Magnesium;
run;

* Exercise 1;
* a;
proc univariate data=wines normal;
	var Magnesium;
	histogram Magnesium /normal;
	probplot Magnesium;
	ods select Moments BasicMeasures Histogram ProbPlot TestsforNormality;
run;
* b;
proc univariate data=wines normal;
	var Magnesium;
	histogram Magnesium /normal;
	probplot Magnesium;
	by Alcohol;
	ods select Moments BasicMeasures Histogram ProbPlot TestsForNormality;
run;

* Exercise 2;
* a;
proc ttest data=wines h0=20 sides=u;
	var Magnesium;
	where Alcohol=2;
	ods select TTests;
run;
* b;
proc ttest data=wines sides=l;
	class Alcohol;
	var Magnesium;
	where Alcohol ne 2;
	ods select TTtests EqualityTest;
run;

* Exercise 3;
* a;
proc univariate data=wines normal;
	var Color;
	histogram Color /normal;
	probplot Color;
	by Alcohol;
	where Alcohol ne 2;
	ods select Histogram ProbPlot TestsForNormality;
run;
* b;
proc npar1way data=wines wilcoxon;
	class Alcohol;
	var Color;
	where Alcohol ne 2;
	ods exclude KruskalWallisTest;
run;

* Exercise 4;
* a;
proc sgscatter data=wines;
	matrix Alcalinity Color Hue Magnesium;
run;
proc corr data=wines pearson;
	var Alcalinity Color Hue Magnesium;
	ods select PearsonCorr;
run;
* b;
proc sgscatter data=wines;
	matrix Alcalinity Color Hue Magnesium;
	by Alcohol;
run;
proc corr data=wines pearson;
	var Alcalinity Color Hue Magnesium;
	by Alcohol;
	ods select PearsonCorr;
run;

ods rtf close;
