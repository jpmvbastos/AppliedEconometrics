import excel "/Users/joamacha/Downloads/columbus.xlsx", sheet("Sheet1") cellrange(C1:GH10889) firstrow clear

gen ncesname = ""
replace ncesname = "Bexley City" if ncesid==3904362
replace ncesname = "Columbus City" if ncesid==3904380
replace ncesname = "Grandview Heights" if ncesid==3904407 
replace ncesname = "South-Western City" if ncesid==    3904480 
replace ncesname = "Upper Arlington City" if ncesid==    3904493 
replace ncesname = "Westerville City" if ncesid==    3904504 
replace ncesname = "Whitehall City" if ncesid==    3904507 
replace ncesname = "Worthington City"	if ncesid==    3904513 
replace ncesname = "Pickerington Local" if ncesid==    3904689 
replace ncesname = 	"Canal Winchester Local" if ncesid==    3904694 
replace ncesname = 	"Hamilton Local" if ncesid==    3904695 
replace ncesname = 	"Gahanna-Jefferson City" if ncesid==    3904696 
replace ncesname = 	"Groveport Madison Local" if ncesid==    3904697 
replace ncesname = 	"Reynoldsburg City" if ncesid==    3904700 
replace ncesname = 	"Hilliard City" if ncesid==  3904701 
replace ncesname = 	"Dublin City" if ncesid== 3904702 
replace ncesname = 	"Licking Heights Local" if ncesid==    3904800 
replace ncesname = 	"Plain Local" if ncesid== 3904993 


gen hprice = exp(lnhprice)

gen pbath = .
replace pbath = 0 if partbath == 0
replace pbath = 1 if partbath > 0
