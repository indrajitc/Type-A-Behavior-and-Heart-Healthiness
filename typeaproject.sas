/*Data Analysis Project*/
libname proj 'C:\Users\Owner\Documents\Grad School\MS Statistics\Spring 2017\Advanced Regression Methods for PH\Data Analysis Project\SAS';
/*Data Importing*/
PROC IMPORT OUT= proj.heart 
			DATAFILE= "C:\Users\Owner\Documents\Grad School\MS Statistics\Spring 2017\Advanced Regression Methods for PH\Data Analysis Project\SAS\SAheart.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
RUN;
PROC PRINT DATA = proj.heart;
RUN; 
/*Model Selection*/
DATA proj.heart;
SET proj.heart;
familyhistory = 0;
Smoker = 0; 
Drinker = 0;  
IF (famhist = "Present") THEN familyhistory = 1; 
IF (tobacco > 5.5) THEN Smoker = 1; /*Smokers have higher than 75% percentile for tobacco*/
IF (alcohol > 23.89) THEN Drinker = 1; /*Drinkers have higher than 75% percentile for alcohol*/  
RUN;
PROC REG DATA = proj.heart;
MODEL typea = sbp Smoker ldl adiposity familyhistory obesity Drinker age chd /selection=stepwise slentry = 0.15 slstay = 0.25 details = all; 
RUN; 
QUIT;
/*Main Effects for Chosen Model*/
PROC REG DATA = proj.heart;
MODEL typea = chd age obesity adiposity; 
RUN; 
QUIT;
PROC REG DATA = proj.heart;
MODEL typea = chd age obesity; 
RUN; 
QUIT;
/*Model Checking*/
PROC CORR DATA = proj.heart;
VAR typea chd age obesity;
RUN; 
PROC sgscatter DATA = proj.heart;
matrix typea chd age obesity; 
run; 
/*Possible Interactions*/
DATA proj.heart;
SET proj.heart;
chd_age = chd*age;
chd_obesity = chd*obesity;
RUN;
PROC REG DATA = proj.heart;
MODEL typea = chd age obesity chd_age chd_obesity; 
RUN; 
QUIT;
/*Influential Points*/
PROC REG DATA = proj.heart;
model typea = chd age obesity/influence;
output out = proj.heart1 predicted = y_hat residual = e student = r1 rstudent = rst1
h = leverage cookd = cd dffits = diffit; 
RUN; 
QUIT; 
PROC PRINT DATA = proj.heart1;
RUN; 
/*Final Model*/
PROC REG DATA = proj.heart;
MODEL typea = obesity age chd; 
RUN; 
QUIT;
