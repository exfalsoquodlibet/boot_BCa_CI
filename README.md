### boot_BCa_CI

A function and an example to estimate non-parametrically bootstrapped BCa 95% CI for a mixed-effect logit growth-curve model (responses are 0 or 1, and responses are collected from the same participant on a repeated number of times).

* simulate_data.R creates a simulated dataset with one independent (between-subjects) independent variable (Cond) and time-dependent repeated-measures per each participant. The dataset is available as simulated_data.csv and can be run directly in RunExample.R

* myfun_bootBCaCI.R contains the function to be inputted in the boot function from the {boot} package in R to compute non-parametrically bootstrapped BCa 95% CI. The function follows randomly sampling the grouping variable (participants) with replacement, as recommended for longitudinal data (“cluster bootstrap”, Sherman & le Cassie, 1997) 

* myClean.timevar.R contains a function read by myfun_bootBCaCI.R

* RunExample.R provides an example based on simulated_data.csv
