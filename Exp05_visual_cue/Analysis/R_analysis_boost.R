library(lme4)

Boost<-read.table("~/Dropbox/Documents/Trained_Inhibition/Boost/Analysis/boostprobe_choices_for_R.txt",header=T,na=9999)
library(lme4)
s1=subset(Boost,Boost$trialType==1)
subs1<-s1$subjid
choices1<-s1$choices
subs1=as.factor(subs1)

boost1=glmer(choices1~1+(1|subs1),s1,family=binomial,na.rm=T)


Boost<-read.table("~/Dropbox/Documents/Trained_Inhibition/Boost/Analysis/boostprobe_choices_for_R.txt",header=T,na=9999)

s2=subset(Boost,Boost$trialType==2)
subs2<-s2$subjid
choices2<-s2$choices
subs2=as.factor(subs2)

boost2=glmer(choices2~1+(1|subs2),s2,family=binomial,na.rm=T)

mean(Boost$choices[Boost$trialType==1],na.rm=T)
mean(Boost$choices[Boost$trialType==2],na.rm=T)
mean(Boost$choices[Boost$trialType==3],na.rm=T)
mean(Boost$choices[Boost$trialType==4],na.rm=T)


v1=tapply(Boost$choices[Boost$trialType==1],subjid,mean,na.rm=T)
v2=tapply(Boost$choices[Boost$trialType==2],subjid,mean,na.rm=T)
v3=tapply(Boost$choices[Boost$trialType==3],subjid,mean,na.rm=T)
v4=tapply(Boost$choices[Boost$trialType==4],subjid,mean,na.rm=T)

sd(v1)/sqrt(length(v1))
sd(v2)/sqrt(length(v2))
sd(v3)/sqrt(length(v3))
sd(v4)/sqrt(length(v4))
