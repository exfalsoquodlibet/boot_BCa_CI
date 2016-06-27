
#### simulate data for 40 subjects, each tested 12 times in one of two conditions

nTrials = 12
nSubjs = 40

simu <- expand.grid(t = 1:nTrials, subj = 1:nSubjs, stringsAsFactors = T)

#add between-subjects condition
simu$Cond <- as.factor(with(simu, rep(rep(c('C1', 'C2'), each = nTrials), each = nSubjs/2)))    #add between-subjects condition

# have a look at the design
with(simu, table(subj, Cond))
with(simu, table(subj, t))


### fix effects for Cond and time on the logit scale
B0 <- 0.8        # grand mean
B1 <- 0.4        # effect of Cond
B2 <- -.25       # negative trend effect of time
noise <- rnorm(nSubjs, 0, 1)      #error

# there are two true main effects and no interaction
logodds.success <- with(simu, B0 + c(B1, -B1)[Cond] + B2*t + noise[subj])


### simulate response (success =1)
set.seed(543)
simu$Y <- rbinom(n = length(logodds.success), size = 1, prob = plogis(logodds.success))


# plot mean probability of success across times for the two conditions
ggplot(simu, aes(as.factor(t), Y, color=Cond)) + 
    stat_summary(fun.data=mean_se, geom="pointrange") + 
    labs(y="mean prob", x="time") + 
    theme_bw(18) + scale_color_manual(values=c("red", "blue"))


#write.table(simu, 'simulated_data.csv', row.names=F, sep=',')
