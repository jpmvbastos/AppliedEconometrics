* CLEAN DATA: START HERE

*** TABLE 1 BRIBES

* PANEL A: FEMALE MANAGER

* Bribe Incidence
reg pct_bribes female_manager b2.firm_size i.country i.year i.sector, cluster(country)

* Bribe Incidence Categorical

reg paid_bribes female_manager b2.firm_size i.country i.year i.sector, cluster(country)

logit paid_bribes female_manager b2.firm_size i.country i.year i.sector, cluster(country)

probit paid_bribes female_manager b2.firm_size i.country i.year i.sector, cluster(country)


* PANEL B: FEMALE OWNER

* Bribe Incidence

reg pct_bribes female_owner b2.firm_size i.country i.year i.sector, cluster(country)

* Bribe Incidence Categorical

reg paid_bribes female_owner b2.firm_size i.country i.year i.sector, cluster(country)

logit paid_bribes female_owner b2.firm_size i.country i.year i.sector, cluster(country)

probit paid_bribes female_owner b2.firm_size i.country i.year i.sector, cluster(country)



*** TABLE 2 - CORRUPTION

* PANEL A: FEMALE MANAGER

reg corr_obst female_manager b2.firm_size i.country i.year i.sector, cluster(country)

ologit corr_obst female_manager b2.firm_size i.country i.year i.sector, cluster(country)

oprobit corr_obst female_manager b2.firm_size i.country i.year i.sector, cluster(country)



* PANEL B: FEMALE OWNER

reg corr_obst female_owner b2.firm_size i.country i.year i.sector, cluster(country)

ologit corr_obst female_owner b2.firm_size i.country i.year i.sector, cluster(country)

oprobit corr_obst female_owner b2.firm_size i.country i.year i.sector, cluster(country)


*** TABLE 1 BRIBES

* PANEL A: FEMALE MANAGER

* Bribe Incidence
reg pct_bribes female_manager age ln_employees exp informal b2.firm_size i.country i.year i.sector, cluster(country)

* Bribe Incidence Categorical

reg paid_bribes female_manager age ln_employees exp informal b2.firm_size i.country i.year i.sector, cluster(country)

logit paid_bribes female_manager age ln_employees exp informal b2.firm_size i.country i.year i.sector, cluster(country)

probit paid_bribes female_manager age ln_employees exp informal b2.firm_size i.country i.year i.sector, cluster(country)


* PANEL B: FEMALE OWNER

* Bribe Incidence

reg pct_bribes female_owner age ln_employees exp informal b2.firm_size i.country i.year i.sector, cluster(country)

* Bribe Incidence Categorical

reg paid_bribes female_owner age ln_employees exp informal b2.firm_size i.country i.year i.sector, cluster(country)

logit paid_bribes female_owner age ln_employees exp informal b2.firm_size i.country i.year i.sector, cluster(country)

probit paid_bribes female_owner age ln_employees exp informal b2.firm_size i.country i.year i.sector, cluster(country)



*** TABLE 2 - CORRUPTION

* PANEL A: FEMALE MANAGER

reg corr_obst female_manager age ln_employees exp informal b2.firm_size i.country i.year i.sector, cluster(country)

ologit corr_obst female_manager age ln_employees exp informal b2.firm_size i.country i.year i.sector, cluster(country)

oprobit corr_obst female_manager age ln_employees exp informal b2.firm_size i.country i.year i.sector, cluster(country)



* PANEL B: FEMALE OWNER

reg corr_obst female_owner age ln_employees exp informal b2.firm_size i.country i.year i.sector, cluster(country)

ologit corr_obst female_owner age ln_employees exp informal b2.firm_size i.country i.year i.sector, cluster(country)

oprobit corr_obst female_owner age ln_employees exp informal b2.firm_size i.country i.year i.sector, cluster(country)
