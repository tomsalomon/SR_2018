
library(lme4)

rm(list=ls())

## Original Sample
#For iMac
path="~/Dropbox/Experiment_Israel/Codes/Boost_IAPS_Positive_II/Output/"
# For PC
path="C:/Users/Tom/Dropbox/Experiment_Israel/Codes/Boost_IAPS_Positive_II/Output/"
subjects=c(120,122:124,126:127,129:133,135:138,140,142,144,145,147:150,153:158); # Define here your subjects' codes.
# exclude:
# 121, 128, 134, 139, 143, 151, 152-  computer crashed
# 125, 141 - had poor training
# 143 - asked to leave (got bored)

# 144, 145 - not so good training. consider removal

filelist=c()
for (s in subjects){
	filelist=c(filelist,Sys.glob(paste(path, "p_",s,"_probe_block*.txt",sep="")))
}

boost_probe=c()

for (f in filelist){
	boost_probe=rbind(boost_probe,read.table(f,header=T,na.strings=c(999,999000)))
}


# boost_probe$PairType2[boost_probe$bidIndexLeft %in% c(7, 10, 12, 13, 8, 9, 11, 14,15, 18, 20, 21, 16, 17, 19, 22)]="HHHA"
# boost_probe$PairType2[boost_probe$bidIndexLeft %in% c(39, 42, 44, 45, 40, 41, 43, 46,47, 50, 52, 53, 48, 49, 51, 54)]="LLLA"
boost_probe$PairType2[boost_probe$PairType==1]="High_Value"
boost_probe$PairType2[boost_probe$PairType==2]="Low_Value"
boost_probe$PairType2[boost_probe$PairType==4]="Sanity"

tapply(boost_probe$Outcome,boost_probe$PairType2,mean,na.rm=T)


summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(boost_probe,(boost_probe$PairType2=='High_Value')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(boost_probe,(boost_probe$PairType2=='Low_Value')),na.action=na.omit,family=binomial))
     
summary(glmer(Outcome ~ 1 + PairType + (1|subjectID),data=subset(boost_probe,boost_probe$PairType %in% c(1,2)),na.action=na.omit,family=binomial)) #effect of Go choice for HH vs LL

# print results as sentences
HV=summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(boost_probe,(boost_probe$PairType2=='High_Value')),na.action=na.omit,family=binomial)) 
LV=summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(boost_probe,(boost_probe$PairType2=='Low_Value')),na.action=na.omit,family=binomial))
means=tapply(boost_probe$Outcome,boost_probe$PairType2,mean,na.rm=T)
paste("High value: Go items were chosen in ",round(means[1]*100,2),"%, p=",round(HV$coefficients[4],4),sep = "")
paste("Low value: Go items were chosen in ",round(means[2]*100,2),"%, p=",round(LV$coefficients[4],4),sep = "")




