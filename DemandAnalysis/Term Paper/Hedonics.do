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
replace ncesname = 	"Gahanna-Jefferson City" if ncesid==   3904696 
replace ncesname = 	"Groveport Madison Local" if ncesid==    3904697 
replace ncesname = 	"Reynoldsburg City" if ncesid==    3904700 
replace ncesname = 	"Hilliard City" if ncesid==  3904701 
replace ncesname = 	"Dublin City" if ncesid== 3904702 
replace ncesname = 	"Licking Heights Local" if ncesid==    3904800 
replace ncesname = 	"Plain Local" if ncesid== 3904993 


rename buildingsqft size
rename agehouse age

gen sizet= size/1000
gen sizet2 = sizet*sizet

gen lotsizet = lotsize/1000
gen lotsizet2 = lotsizet*lotsizet

gen age2 = age*age

gen hprice = exp(lnhprice)
gen yardsize = exp(lnyardsize)

gen pbath = .
replace pbath = 0 if partbath == 0
replace pbath = 1 if partbath > 0


drop if rooms > 20
drop if hprice > 2000000


* Table 1

sum hprice lnhprice lotsize size age rooms fullbath onestory air


* Table 2 

eststo clear 
eststo: reg hprice rooms fullbath partbath lotsizet age age2 air, vce(robust)
eststo: reg hprice sizet fullbath partbath lotsizet age age2 air, vce(robust)
eststo: reg hprice rooms fullbath partbath lotsizet lotsizet2 age age2 air hlat hlong, vce(robust)
eststo: reg hprice sizet sizet2 fullbath partbath lotsizet lotsizet2 age age2 air hlat hlong, vce(robust)
test sizet + sizet2 = 0
lincom sizet+sizet2

esttab using "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/DemandAnalysis/Term Paper/Table2.tex", replace se r2

* Table 3

eststo clear 
eststo: reg lnhprice rooms fullbath partbath lotsizet age age2 air, vce(robust)
eststo: reg lnhprice sizet fullbath partbath lotsizet age age2 air, vce(robust)
eststo: reg lnhprice rooms fullbath partbath lotsizet lotsizet2 age age2 air hlat hlong, vce(robust)
eststo: reg lnhprice sizet sizet2 fullbath partbath lotsizet lotsizet2 age age2 air hlat hlong, vce(robust)

esttab using "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/DemandAnalysis/Term Paper/Table3.tex", replace se r2


* Table 4

eststo: reg hprice rooms fullbath partbath lotsizet age age2 air i.schoolid, cluster(schoolid)
eststo: reg lnhprice rooms fullbath partbath lotsizet age age2 air i.schoolid, cluster(schoolid)




* Appendix 

twoway (scatter rooms hprice) (lfit rooms hprice)

graph export "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/DemandAnalysis/Term Paper/RoomsPrice.png", as(png) name("Graph")

twoway (scatter size hprice) (lfit size hprice)

graph export "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/DemandAnalysis/Term Paper/SizePrice.png", as(png) name("Graph")

eststo clear 
eststo: reg hprice rooms , vce(robust)
eststo: reg hprice sizet, vce(robust)
eststo: reg hprice sizet rooms , vce(robust)

esttab using "/Users/joamacha/Library/CloudStorage/OneDrive-TexasTechUniversity/Personal/Projects/Code/GitHub/AppliedEconometrics/DemandAnalysis/Term Paper/TableA2.tex", replace se r2
