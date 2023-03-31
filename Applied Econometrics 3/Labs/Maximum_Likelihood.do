import excel "/Users/BASTOS/Downloads/Data/Fishing.xls", sheet("Sheet1") firstrow clear

* Clean
encode mode, gen(mode_d)
tab mode_d

/* Multinomial: only decision-maker characteristics

prob (y_i = j | income ) =  \frac{exp(\alpha_j + \beta_jincome_i}{\sum exp(\alpha_k + \beta_kincome}

*/

mlogit mode_d income, baseoutcome(1)

* As income goes up the probability of fishing at (charter, pier) goes down, compared to the beach.


* Tests the joint hypothesis that income is = 0 in all models
test income

* Marginal Effects (partial derivative)
mfx

* Computes the prob at evert x and average / See: https://www.stata.com/manuals/rmargins.pdf
margins 

* Computes probability at the means values
margins, dydx(income) pr(outcome(1))


* If doing conditional logit or nested, need to reshape the data by: 
gen id = _n
reshape long d p q, i(id) j(fishmode beach pier private charter) string 


* Conditional Logit: only choice attributes
asclogit d p q, case(id) alternatives(fishmode) 


* Mixed: decision maker and choice attributes
asclogit d p q, case(id) alternatives(fishmode) casevars(income)


* Nested Choice

nlogitgen type = fishmode (shore: pier|beach, boat: private|charter)

nlogittree fishmode type, choice(d)

nlogit d p q || type:, base(shore) || fishmode: income, case(id)
