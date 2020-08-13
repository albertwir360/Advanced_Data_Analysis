*data from princomp Procedure>> Getting Started;
data Crime;
   input State $1-15 Murder Rape Robbery Assault
         Burglary Larceny Auto_Theft;
   datalines;
Alabama        14.2 25.2  96.8 278.3 1135.5 1881.9 280.7
Alaska         10.8 51.6  96.8 284.0 1331.7 3369.8 753.3
Arizona         9.5 34.2 138.2 312.3 2346.1 4467.4 439.5
Arkansas        8.8 27.6  83.2 203.4  972.6 1862.1 183.4
California     11.5 49.4 287.0 358.0 2139.4 3499.8 663.5
Colorado        6.3 42.0 170.7 292.9 1935.2 3903.2 477.1
Connecticut     4.2 16.8 129.5 131.8 1346.0 2620.7 593.2
Delaware        6.0 24.9 157.0 194.2 1682.6 3678.4 467.0
Florida        10.2 39.6 187.9 449.1 1859.9 3840.5 351.4
Georgia        11.7 31.1 140.5 256.5 1351.1 2170.2 297.9
Hawaii          7.2 25.5 128.0  64.1 1911.5 3920.4 489.4
Idaho           5.5 19.4  39.6 172.5 1050.8 2599.6 237.6
Illinois        9.9 21.8 211.3 209.0 1085.0 2828.5 528.6
Indiana         7.4 26.5 123.2 153.5 1086.2 2498.7 377.4
Iowa            2.3 10.6  41.2  89.8  812.5 2685.1 219.9
Kansas          6.6 22.0 100.7 180.5 1270.4 2739.3 244.3
Kentucky       10.1 19.1  81.1 123.3  872.2 1662.1 245.4
Louisiana      15.5 30.9 142.9 335.5 1165.5 2469.9 337.7
Maine           2.4 13.5  38.7 170.0 1253.1 2350.7 246.9
Maryland        8.0 34.8 292.1 358.9 1400.0 3177.7 428.5
Massachusetts   3.1 20.8 169.1 231.6 1532.2 2311.3 1140.1
Michigan        9.3 38.9 261.9 274.6 1522.7 3159.0 545.5
Minnesota       2.7 19.5  85.9  85.8 1134.7 2559.3 343.1
Mississippi    14.3 19.6  65.7 189.1  915.6 1239.9 144.4
Missouri        9.6 28.3 189.0 233.5 1318.3 2424.2 378.4
Montana         5.4 16.7  39.2 156.8  804.9 2773.2 309.2
Nebraska        3.9 18.1  64.7 112.7  760.0 2316.1 249.1
Nevada         15.8 49.1 323.1 355.0 2453.1 4212.6 559.2
New Hampshire   3.2 10.7  23.2  76.0 1041.7 2343.9 293.4
New Jersey      5.6 21.0 180.4 185.1 1435.8 2774.5 511.5
New Mexico      8.8 39.1 109.6 343.4 1418.7 3008.6 259.5
New York       10.7 29.4 472.6 319.1 1728.0 2782.0 745.8
North Carolina 10.6 17.0  61.3 318.3 1154.1 2037.8 192.1
North Dakota    0.9  9.0  13.3  43.8  446.1 1843.0 144.7
Ohio            7.8 27.3 190.5 181.1 1216.0 2696.8 400.4
Oklahoma        8.6 29.2  73.8 205.0 1288.2 2228.1 326.8
Oregon          4.9 39.9 124.1 286.9 1636.4 3506.1 388.9
Pennsylvania    5.6 19.0 130.3 128.0  877.5 1624.1 333.2
Rhode Island    3.6 10.5  86.5 201.0 1489.5 2844.1 791.4
South Carolina 11.9 33.0 105.9 485.3 1613.6 2342.4 245.1
South Dakota    2.0 13.5  17.9 155.7  570.5 1704.4 147.5
Tennessee      10.1 29.7 145.8 203.9 1259.7 1776.5 314.0
Texas          13.3 33.8 152.4 208.2 1603.1 2988.7 397.6
Utah            3.5 20.3  68.8 147.3 1171.6 3004.6 334.5
Vermont         1.4 15.9  30.8 101.2 1348.2 2201.0 265.2
Virginia        9.0 23.3  92.1 165.7  986.2 2521.2 226.7
Washington      4.3 39.6 106.2 224.8 1605.6 3386.9 360.3
West Virginia   6.0 13.2  42.2  90.9  597.4 1341.7 163.3
Wisconsin       2.8 12.9  52.2  63.7  846.9 2614.2 220.7
Wyoming         5.4 21.9  39.7 173.9  811.6 2772.2 282.0
;
* check pairwise scatter plot of crime type rates;
proc sgscatter data=Crime;
	matrix Murder--Auto_Theft;
run;
* compute correlations;
proc corr data=Crime;
run;
* obtain principal components analysis;
proc princomp data=Crime;
   id State;
run;
* get visualizations of components;
proc princomp data=Crime plots= score(ellipse ncomp=3);
   id State;
   ods select ScorePlot;
run;
* start decathlon example;
data decathlon;
  infile '';
  input name $ 1-13 run100 Ljump shot Hjump 
		run400 hurdle discus polevlt javelin run1500 dscore;
run;
proc print data=decathlon;
run;
proc univariate data=decathlon;
 var dscore;
 id name;
 ods select Quantiles ExtremeObs;
run;
proc sgplot data=decathlon;
  vbox dscore / datalabel=name;
run;
* remove extreme point and multiple variables where smaller is better by -1 so increasing is better for all variables;
data decathlon;
  set decathlon;
  if dscore > 6000;
  run100=run100*-1;
  run400=run400*-1;
  hurdle=hurdle*-1;
  run1500=run1500*-1;
run;
proc print data=decathlon;
run;
* perform principal components analysis on the individual event measurements;
proc princomp data=decathlon out=pcout;
 var run100--run1500;
 id name;
run;
proc print data=pcout;
run;
* rank based on descending score and add a posn variable to the data set that contains the ranking;
proc rank data=pcout out=pcout descending;
 var dscore;
 ranks posn;
run;
proc print data=pcout;
run;
* use a scatter plot to visualize the ranks with respect to the first two principal components;
proc sgplot data=pcout;
  scatter y=prin1 x=prin2 / markerchar=posn;
run;
* compare the relationship of decathlon score to each of these principal components;
proc sgscatter data=pcout;
  compare y=dscore x=(prin1 prin2);
run;
* compare correlation of the dscore variable with the first 2 principal components;
proc corr data=pcout;
  var dscore prin1 prin2;
run;
* look at the correlation of dscore with all principal components;
proc corr data=pcout;
  var dscore prin1--prin10;
run;
* start pain data set;
data pain (type = corr);
	* modify file path to match your files;
	infile '' expandtabs missover;
	input _type_ $  _name_ $   p1 - p9;
run;
proc print data=pain;
run;
* get pca and interpret results-- note type option to princomp, though not needed;
* note some results cannot be obtained when using corr or other special data types;
proc princomp data=pain;
	var p1--p9;
run;
* brute force principal component regression example;
* linear regression for dscore on first 2 principal components;
proc reg data=pcout;
	model dscore = prin1--prin2;
run;
* forward selection with all 10 pc's;
proc reg data=pcout;
	model dscore = prin1--prin10/selection =forward sle=.05;
run;
* considering forward selected model;
proc reg data=pcout;
	model dscore = prin1--prin6;
run;