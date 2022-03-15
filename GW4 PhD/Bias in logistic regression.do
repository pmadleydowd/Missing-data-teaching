********************************************************************************
* Author: 		Paul Madley-Dowd
* Date: 		15/03/2023
* Description: 	Code to illustrate bias from missing data in logistic regression using a simple example
********************************************************************************

clear   
set seed 5786923 						// set seed so we can replicate results
set obs 1000000  						// set number of observations

gen x = runiform()>0.3            		// generate binary x
gen y = exp(x)/(1+exp(x))>runiform()    // generate binary y dependent on x


gen Mx= x*(runiform()<0.4)    			// generate missing indicator dependent on x only
gen My= y*(runiform()<0.4)    			// generate missing indicator dependent on y only
gen Mxy = x*y*(runiform()<0.4)      	// generate missing indicator dependent on x and y jointly


tab Mx x, col 							// 40% y missing if x=1
tab My y, col 							// 40% y missing if true y=1

bysort y: tab Mxy x, col  				// 40% y missing if x=1 and true y=1
bysort x: tab Mxy y, col  				// 40% y missing if true y=1 and x=1


gen yObs1 = y if Mx==0 & My==0    		// implement missing data influenced by x and y independently
gen yObs2 = y if Mxy==0           	 	// implement missing data influenced by x and y jointly


logistic y x            				// Model 1 - full data (unbiased) - OR = 2.72
logistic yObs1 x        				// Model 2 - independent influence of x and y on missingness (unbiased)  - OR = 2.72
logistic yObs2 x        				// Model 3 - missingness dependent on x and y jointly (biased)  - OR = 1.62
 


