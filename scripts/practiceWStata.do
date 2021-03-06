										///										
capture log close
clear
set more off
set trace off
pause on
local projectpath /Users/Banjodan2/Dropbox/Stata
cd "`projectpath'"
capture log using "PracticeStataLog", replace
/*************************************************\
* Practice with Stata: data downloaded from internet***/
* Date modified:
* Output saved in: "/Users/Banjodan2/Desktop/StataPractice/"

label define binaryCode 0 "No" 1 "Yes"

import delimited datasets/KaggleV2-May-2016.csv //hospital no-show rates
//use


//clean the data:
drop if age < 0
foreach var of varlist noshow {
	encode `var', gen(_`var')
	replace _`var' = _`var' - 1
	label values _`var' binaryCode
}

foreach var of varlist scholarship hipertension diabetes alcoholism handcap sms_received `{

/*  ------- break line ------- (by the Stata editor for macOS (piu_sign) )  */ 
'	label values `var' binaryCode
}

numlabel, add

local categoricalVars "gender scholarship hipertension diabetes alcoholism handcap sms_received noshow neighbourhood"
local size : word count `categoricalVars'

di "We have `size' categorical variables."

*summarizing the categorical vars:
foreach var of varlist `categoricalVars' {
	sum `var'
	tabulate `var', missing plot
}


notes gender: there is no significant difference between the no-show rates of males and females

save "PracticeDataCleaned.dta", replace

*tabbout, eststo, esttab, estadd
eststo: regress _noshow sms_received age
esttab using "output/tables/table1_regress_noshow_sms.tex", replace se r2 nocons booktabs
eststo clear

//Great way to turn a string of numbers into integer values and remove unwanted characters from a variable:
* gen var2=regexr(var1,"[.\}\)\*a-zA-Z]+","")
* destring var2, replace

* or to extract strings:
* gen var2=regexr(var1,"[.0-9]+","")

* 1. -by:-. 

* 2. -foreach- or -forval- with varlists or numlists. 

* 3. -merge-. I rarely use it but -merge-masters have real leverage
* in file manipulations. 

* 4. -assert-. My candidate for the most underestimated command in
* Stata (second is -count-).  

* 5. -reshape-. 


*other stata commands to try:
/* margins
svtmat
coeffplot
collapse
bootstrap
assert
ds
 */

//snapshot or preserve
translate PracticeStataLog.smcl PracticeStataLogPDF.pdf, replace

/* shell echo -e "It's Done" | mail -s "STATA finished" "banjodan2@gmail.com" */

//leave blank