library(lme4)
library(boot)



source('myfun_bootBCaCI.R')


# read simulated data (or your data)
simu <- read.csv('simulated_data.csv', header=T)


###### run original growth-curve model on Y

## orthogonal second order polynomials 
tt <- poly((unique(simu$t)), 2)
simu[,paste("t", 1:2, sep="")] <- tt[simu$t, 1:2]


# growth model
orig.glmer <- glmer(Y ~ (t1 + t2)*Cond + (t1 + t2 |subj), data=simu,
                    family=binomial, glmerControl(optimizer='bobyqa', optCtrl=list(maxfun=200000)))
summary(orig.glmer)  


#plot model predictions together raw mean probabilities
ggplot(simu, aes(as.factor(t), Y, color=Cond)) + 
    stat_summary(fun.data=mean_se, geom="pointrange") + 
    labs(y="mean prob", x="time") + 
    theme_bw(18) + scale_color_manual(values=c("red", "blue")) +
    stat_summary(aes(y=fitted(orig.glmer), group=Cond), fun.y=mean, geom="line")




### non-parametrically bootstrapped BCa 95% confidence intervals

## (1) re-shape data into wide format
wide.simu <- reshape(simu, v.names=c("Y"), idvar='subj', timevar=c("t"),
                     drop=c('t1', 't2'), 
                     direction='wide')
head(wide.simu)



# set number of iterations (10000 recommended)
niter = 100

set.seed(18)
wide.boot <- boot(wide.simu, myfun_bootBCaCI, R = niter, strata = wide.simu$Cond, 
                               group.var = subj, iv = Cond)


## plot the distribution of bootstrapped coefficients
for(n in 1:length(fixef(orig.glmer))){
    hist(wide.boot$t[,n], main = paste('histogram of',names(fixef(orig.glmer))[n]), 
                                       xlab = 'bootstrapped coefficients' )
}



# compute BCa 95% confidence intervals
lowerCI <- vector()
upperCI <- vector()
for(i in 1:length(fixef(orig.glmer))){
    lowerCI[i] <- round(boot.ci(wide.boot, type='bca', index = i)$bca[c(4)],3)
    upperCI[i] <- round(boot.ci(wide.boot, type='bca', index = i)$bca[c(5)],3)
}


# put original coefficients and boostrapped CI  together
Coef <- names(fixef(orig.glmer))
wide.boot.results <- cbind(Coef, summary(wide.boot)[,c(2,3,4)])
wide.boot.results <- as.data.frame(cbind(wide.boot.results, lowerCI, upperCI))
wide.boot.results



