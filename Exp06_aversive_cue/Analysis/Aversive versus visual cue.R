
library(lme4)

rm(list=ls())

## Original Sample - Aversive
#For iMac
path="~/Dropbox/Experiment_Israel/Codes/Boost_aversive_cue/Output/"
# For PC
path="C:/Users/Tom/Dropbox/Experiment_Israel/Codes/Boost_aversive_cue/Output/"
subjects_aversive=c(101:107,109:111,113:115,117:123, 125,128,130,132); # Define here your subjects' codes.
# exclude: 108, 116, 124 - bad training
# 112 - missed over 50% of probe trials
# 129, 131 - were not excluded (skipped these number to keep even counter balance


filelist_aversive=c()
for (s in subjects_aversive){
  filelist_aversive=c(filelist_aversive,Sys.glob(paste(path, "*",s,"_probe_block*.txt",sep="")))
}

aversive=c()

for (f in filelist_aversive){
  aversive=rbind(aversive,read.table(f,header=T,na.strings=c(999,999000)))
}

aversive$sample=0

## Original Sample - Visual
#For iMac
path="~/Dropbox/Experiment_Israel/Codes/Boost_visual_cue/Output/"
# For PC
path="C:/Users/Tom/Dropbox/Experiment_Israel/Codes/Boost_visual_cue/Output/"
subjects=c(101:116,118:125,127)
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

BSOV$sample=1

boost_probe=rbind(aversive,BSOV)


# boost_probe$PairType2[boost_probe$bidIndexLeft %in% c(7, 10, 12, 13, 8, 9, 11, 14,15, 18, 20, 21, 16, 17, 19, 22)]="HHHA"
# boost_probe$PairType2[boost_probe$bidIndexLeft %in% c(39, 42, 44, 45, 40, 41, 43, 46,47, 50, 52, 53, 48, 49, 51, 54)]="LLLA"
boost_probe$PairType2[boost_probe$PairType==1]="High_Value"
boost_probe$PairType2[boost_probe$PairType==2]="Low_Value"
boost_probe$PairType2[boost_probe$PairType==4]="Sanity"

tapply(boost_probe$Outcome,boost_probe$PairType2,mean,na.rm=T)

# Difference Aversive vs visual - HV
summary(glmer(Outcome ~ 1 + sample + (1|subjectID),data=subset(boost_probe,(boost_probe$PairType2=='High_Value')),na.action=na.omit,family=binomial)) 
# Difference Aversive vs visual - LV
summary(glmer(Outcome ~ 1 + sample + (1|subjectID),data=subset(boost_probe,(boost_probe$PairType2=='Low_Value')),na.action=na.omit,family=binomial))
     
summary(glmer(Outcome ~ 1 + sample + PairType + (1|subjectID),data=subset(boost_probe,boost_probe$PairType %in% c(1,2)),na.action=na.omit,family=binomial)) #effect of Go choice for HH vs LL




