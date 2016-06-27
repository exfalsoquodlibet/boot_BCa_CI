myfun_bootBCaCI <- function(d, idx, group.var, iv){
    
    d <- d[idx,]                    #strata arg in boot() will do w/replacemente within the two Conditions separately
    d$subj <- 1:dim(d)[1]           #new subj index for each individual sampled subject
    
    rownames(d) <- 1:dim(d)[1]
    
    # reshape in long format
    d <- reshape(d, idvar = 'group.var', varying = list(3:14), 
                 timevar = "t", sep='.', times=names(d[,3:14]),
                 v.names = 'Y', direction ='long')
    rownames(d) <- 1:dim(d)[1]
    
    #clean levels of time variable
    source('myClean.timevar.R')
    d$t <- as.numeric(myClean.timevar(d$t,2))         
    
    ## orthogonal second order polynomial (growth model)
    tt <- poly((unique(d$t)), 2)
    d[,paste("t", 1:2, sep="")] <- tt[d$t, 1:2]
    
    # run grwoth model and extract fixed-effects regression coefficients
    thecoef <- tryCatch({boot.glmer <- glmer(Y ~ (t1 + t2)*Cond + (t1 + t2 |group.var), data=d, 
                                             family=binomial, glmerControl(optimizer='bobyqa', 
                                                                           optCtrl=list(maxfun=200000))
    )
    fixef(boot.glmer)}
    
    )  
    return(thecoef)
}



