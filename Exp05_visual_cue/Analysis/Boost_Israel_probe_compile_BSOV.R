
library(lme4)

rm(list=ls())

## Original Sample
#For iMac
path="~/Dropbox/Experiment_Israel/Codes/Boost_Only_Visual/Output/"
# For PC
path="C:/Users/Tom/Dropbox/Experiment_Israel/Codes/Boost_Only_Visual/Output/"
subjects=c(101:116,118:125,127)
# Excluded:
# 117 - poor training
# 126 - no subject run under that code

## FollowUp
#For iMac
path="~/Dropbox/Experiment_Israel/Codes/Boost_Only_Visual/Output/RECALL/"
# For PC
path="C:/Users/Tom/Dropbox/Experiment_Israel/Codes/Boost_Only_Visual/Output/RECALL/"
subjects=c(102:106,108:110,112:116,118:125)
# Excluded:
# 117 - poor training
# 126 - no subject run under that code

filelist=c()
for (s in subjects){
	filelist=c(filelist,Sys.glob(paste(path, "BSOV_",s,"_probe_block*.txt",sep="")))
}

BSOV=c()

for (f in filelist){
	BSOV=rbind(BSOV,read.table(f,header=T,na.strings=c(999,999000)))
}


# BSOV$PairType2[BSOV$bidIndexLeft %in% c(7, 10, 12, 13, 8, 9, 11, 14,15, 18, 20, 21, 16, 17, 19, 22)]="HHHA"
# BSOV$PairType2[BSOV$bidIndexLeft %in% c(39, 42, 44, 45, 40, 41, 43, 46,47, 50, 52, 53, 48, 49, 51, 54)]="LLLA"
BSOV$PairType2[BSOV$PairType==1]="High_Value"
BSOV$PairType2[BSOV$PairType==2]="Low_Value"
BSOV$PairType2[BSOV$PairType==4]="Sanity"

tapply(BSOV$Outcome,BSOV$PairType2,mean,na.rm=T)


summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BSOV,(BSOV$PairType2=='High_Value')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BSOV,(BSOV$PairType2=='Low_Value')),na.action=na.omit,family=binomial))

## Save data file to ERC
#save(BSOV,file=paste("~/Dropbox/Experiment_Israel/Results/ERC_2015/OutputFiles/Faces_II.RData"))

     

summary(glmer(Outcome ~ 1 + PairType + (1|subjectID),data=subset(BSOV,BSOV$PairType %in% c(1,2)),na.action=na.omit,family=binomial)) #effect of Go choice for HH vs LL
# summary(glmer(Outcome ~ (1|subjectID),data=subset(BSOV,BSOV$PairType %in% c(1,2)),na.action=na.omit,family=binomial)) # OLD CODE: effect of Go choice for HH vs LL

