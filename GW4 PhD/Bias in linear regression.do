********************************************************************************
* Author: 		Paul Madley-Dowd
* Date: 		15/03/2023
* Description: 	Code to illustrate bias from missing data in linear regression using a simple example
********************************************************************************

clear   
set seed 5786923 // set seed so we can replicate results
set obs 1000000  // set number of observations

gen x = runiform()>0.8          // generate binary x
gen y = rnormal(x, 1)    		// generate normal y dependent on x
tab x							// 20% of observations "exposed"
bysort x: summ y				// mean of outcome is 1 among exposed and 0 if unexposed 


gen Mx= runiform()<0.4 if x == 1 // generate missing indicator dependent on x only
replace Mx = 0 if Mx == . 
gen My= runiform()<0.4 if y > 1 // generate missing indicator dependent on y only
replace My = 0 if My == . 

tab Mx x , col mis     			// 40% missing if x=1
tab My if y>1 					// 40% missing if y>1


regress y x              // Model 1 - full data (unbiased) - Mean difference = 1
regress y x if Mx == 0   // Model 2 - missing data dependent on exposure (unbiased) - Mean difference = 1
regress y x if My == 0   // Model 3 - missing data dependent on the outcome (biased)  - Mean difference = 0.9
 
* Note that it doesn't matter what variable the missing data is in (above we have not actually made data missing, we have just restricted to observations where Mx or My say the data are not missing)
* What matters is what the probability of missing data depends on
* Alternatively, we could actually remove data from any variable and get the same result
* Below we will remove data in the exposure and run the models again 

gen x_misdepx = x if Mx == 0 
gen x_misdepy = x if My == 0 

tab Mx
tab x_misdepx, mis // number missing matches the number with Mx == 1
tab My
tab x_misdepy, mis // number missing matches the number with My == 1

regress y x             // Model 1 - full data (unbiased) - Mean difference = 1 
regress y x_misdepx	    // Model 2 - missing data dependent on exposure (unbiased) - Mean difference = 1
regress y x_misdepy		// Model 3 - missing data dependent on the outcome (biased) - Mean difference = 0.9
* we get the same values as before

