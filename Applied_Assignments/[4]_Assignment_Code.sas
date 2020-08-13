/* Solution code for Homework 4 in Stat 448 at 
  University of Illinois, Summer 2020 */
options nodate nonumber;
title ;
ods noproctitle;

/* variables in listed order for sashelp.heart:
Status DeathCause AgeCHDdiag Sex AgeAtStart Height Weight Diastolic Systolic 
MRW Smoking AgeAtDeath Cholesterol Chol_Status BP_Status Weight_Status Smoking_Status
*/
/* numeric variables in data below: 
AgeAtStart Diastolic Smoking Cholesterol
*/
/* character variables:
Sex Weight_Status HighBP HighChol
*/
data heartHW4;
	set sashelp.heart;
	where status='Alive' and AgeCHDdiag ne . and Chol_Status ne ' ';
	if BP_Status = 'High' then HighBP= 1;
		else HighBP=0;
	if Chol_Status = 'High' then HighChol= 1;
		else HighChol=0;
	keep HighBP HighChol Sex Weight_Status AgeAtStart Smoking Cholesterol Diastolic;
run;
/* Based on Epilepsy Data on pages 266 and 267 of Der and Everitt */
data epil;
    infile '' expandtabs;
    input Id P1 P2 P3 P4 Treat BL Age;
	drop Id P2 P3;
run;

* Exercise 1;
* a;
proc logistic data=heartHW4 desc;
	class Sex Weight_Status/desc;
	model HighChol = Sex Weight_Status AgeAtStart Smoking;
	ods select GlobalTests ParameterEstimates Type3;
run;

* b;
proc logistic data=heartHW4 desc;
	class Sex Weight_Status/desc;
	model HighChol = Sex Weight_Status AgeAtStart Smoking/
		selection=stepwise;
	ods select ModelBuildingSummary;
run;
proc logistic data=heartHW4 desc;
	class Sex Weight_Status/desc;
	model HighChol = AgeAtStart;
	ods select OddsRatios ParameterEstimates;
run;

* Exercise 2;
* a;
proc logistic data=heartHW4 desc;
	class Sex Weight_Status /desc;
	model HighBP = Sex Weight_Status AgeAtStart Smoking Cholesterol;
	ods select GlobalTests ParameterEstimates Type3;
run;

* b;
proc logistic data=heartHW4 desc;
	class Sex Weight_Status/desc;
	model HighBP = Sex Weight_Status AgeAtStart Smoking Cholesterol/
		selection=stepwise;
	ods select ModelBuildingSummary;
run;
proc logistic data=heartHW4 desc;
	class Sex Weight_Status/desc;
	model HighBP = Sex Weight_Status AgeAtStart Smoking Cholesterol/
		selection=stepwise;
	ods select OddsRatios ParameterEstimates;
run;

* Exercise 3;
* a;
proc genmod data=epil;
	model P4 = P1 Treat BL Age/ dist=poisson link=log type1 type3;
	ods select ModelFit ModelInfo;
run;

proc genmod data=epil;
	model P4 = P1 Treat BL Age/ dist=poisson link=log scale=d type1 type3;
	ods select ModelFit ParameterEstimates Type1 Type3;
run;

* b;
proc genmod data=epil plots=(stdreschi stdresdev);
	model P4 = BL/ dist=poisson link=log scale=d type1 type3;
	output out=outp4 pred=predp4 stdreschi=reschi stdresdev=resdev;
	ods select ModelFit ParameterEstimates Type1 Type3 DiagnosticPlot;
run;

proc sgscatter data=outp4;
	compare y=(reschi resdev) x=predp4;
	where predp4<30;
run;

* Exercise 4;
* a;
proc genmod data=epil;
	model P1 = Treat BL Age/ dist=poisson link=log type1 type3;
	ods select ModelFit ModelInfo;
run;

proc genmod data=epil;
	model P1 = Treat BL Age/ dist=poisson link=log scale=d type1 type3;
	ods select ModelFit ParameterEstimates Type1 Type3;
run;

* b;
proc genmod data=epil plots=(stdreschi stdresdev);
	model P1 = BL Age/ dist=poisson link=log scale=d type1 type3;
	output out=outp1 pred=predp1 stdreschi=reschi stdresdev=resdev;
	ods select ModelFit ParameterEstimates Type1 Type3 DiagnosticPlot;
run;

proc sgscatter data=outp1;
	compare y=(reschi resdev) x=predp1;
	where predp1<30;
run;

ods rtf close;
