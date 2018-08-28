
library(lme4)

rm(list=ls())

## Original Sample
#For iMac
path="~/Dropbox/Experiment_Israel/Codes/Boost_IAPS_Positive_I/Output/"
# For PC
#path="C:/Users/Tom/Dropbox/Experiment_Israel/Codes/Boost_Positive/Output/"
subjects=c(100:102,104:116,118:119,122:123,125:131) # Define here your subjects' codes.
# exclude:
# 103, 117, 120, 121 - did not complete the task
# 124 - 44 years old - added on april 2016

filelist=c()
for (s in subjects){
  filelist=c(filelist,Sys.glob(paste(path, "*",s,"_probe_block*.txt",sep="")))
}

BMI_pos=c()

for (f in filelist){
  BMI_pos=rbind(BMI_pos,read.table(f,header=T,na.strings=c(999,999000)))
}


BMI_pos$PairType2[BMI_pos$PairType==1]="High_Value"
BMI_pos$PairType2[BMI_pos$PairType==2]="Low_Value"
BMI_pos$PairType2[BMI_pos$PairType==3]="Sanity_Go"
BMI_pos$PairType2[BMI_pos$PairType==4]="Sanity_NoGo"

BMI_pos$PairType3[BMI_pos$bidIndexLeft %in% c(7:14) & BMI_pos$bidIndexRight %in% c(7:14)]="Highest_4"
BMI_pos$PairType3[BMI_pos$bidIndexLeft %in% c(15:30) & BMI_pos$bidIndexRight %in% c(15:30)]="High_mid_4"
BMI_pos$PairType3[BMI_pos$bidIndexLeft %in% c(31:46) & BMI_pos$bidIndexRight %in% c(31:46)]="Low_mid_4"
BMI_pos$PairType3[BMI_pos$bidIndexLeft %in% c(47:54) & BMI_pos$bidIndexRight %in% c(47:54)]="Lowest_4"

tapply(BMI_pos$Outcome,BMI_pos$PairType2,mean,na.rm=T)
tapply(BMI_pos$Outcome,BMI_pos$PairType3,mean,na.rm=T)

summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_pos,(BMI_pos$PairType2=='High_Value')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_pos,(BMI_pos$PairType2=='Low_Value')),na.action=na.omit,family=binomial))

# Highest and lowest 4
tapply(BMI_pos$Outcome,BMI_pos$PairType3,mean,na.rm=T)
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_pos,(BMI_pos$PairType3=='Highest_4')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_pos,(BMI_pos$PairType3=='High_mid_4')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_pos,(BMI_pos$PairType3=='Low_mid_4')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_pos,(BMI_pos$PairType3=='Lowest_4')),na.action=na.omit,family=binomial)) 
