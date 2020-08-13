/*STAT 448 Summer 2020
Homework6 Solution
*/
/*options nodate nonumber;
title;
ods rtf file='C:\Stat 448\HW6Solution.rtf' nogtitle startpage=no;
ods noproctitle;
*/

/*### Data for all exercises ###*/

data redwine;
	infile '' dlm=';' expandtabs;
	input fixed_acidity	volatile_acidity citric_acid residual_sugar	chlorides 
	free_sulfur_dioxide total_sulfur_dioxide density pH sulphates alcohol quality;
run;

data whitewine;
	infile '' dlm=';' expandtabs;
	input fixed_acidity	volatile_acidity citric_acid residual_sugar	chlorides 
	free_sulfur_dioxide total_sulfur_dioxide density pH sulphates alcohol quality;
run;

data wine; set redwine(in=l) whitewine(in=ll);
if l=1 then type='R';
if ll=1 then type='W';
id=_N_;
run;


/*data for exercise 3*/
proc surveyselect data=wine 
		method=srs sampsize=1000
		rep=1 seed=123456789 out=test; 
run;
proc sort data=test; 
	by id; 
run;
proc sort data=wine; 
	by id; 
run;
data traindata; 
	merge wine(in=l) test(in=ll); by id;
	if ll=1 then delete; 
run;


/*Exercise 1*/
/* 1a */
proc discrim data=wine pool=test crossvalidate manova noclassify;
   class type;
   var fixed_acidity--quality;
   priors proportional;
  ods select ChiSq MANOVA ClassifiedCrossVal ErrorCrossVal;
run;

/*Exercise 2*/
proc stepdisc data=wine sle=.05 sls=.05;
   class type;
   var fixed_acidity--quality;
  ods select Summary;
run;

/*8 variables are kept with the additional constraint that r square must increase by .02*/
proc discrim data=wine method=normal pool=test crossvalidate noclassify;
   class type;
   var fixed_acidity volatile_acidity residual_sugar chlorides 
	free_sulfur_dioxide total_sulfur_dioxide density alcohol;
   ods select ChiSq MANOVA ClassifiedCrossVal ErrorCrossVal;
   priors proportional;
run;

/*Exercise 3 */
proc discrim data=traindata pool=no testdata=test testout=tout noclassify;
   class type;
   var fixed_acidity volatile_acidity residual_sugar chlorides 
	free_sulfur_dioxide total_sulfur_dioxide density alcohol;
   testid id; 
   priors proportional;
  ods select ChiSq MANOVA ClassifiedTestClass ErrorTestClass;
run;


ods rtf close;
