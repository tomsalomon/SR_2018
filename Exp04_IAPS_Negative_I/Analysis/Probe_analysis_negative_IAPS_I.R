
library(lme4)

rm(list=ls())

## Original Sample
#For iMac
path="~/Dropbox/Experiment_Israel/Codes/Boost_IAPS_Negative_I/Output/"
# For PC
#path="C:/Users/Tom/Dropbox/Experiment_Israel/Codes/Boost_IAPS_Negative_I/Output/"
subjects=c(100:101,104,106:110,112:115,118:124,126:134) # Define here your subjects' codes.
# exclude:
# 103, 111 - did not complete the task
# 102, 105, 116, 125 - did not follow the instructions
# 117 - missing?


filelist=c()
for (s in subjects){
	filelist=c(filelist,Sys.glob(paste(path, "*",s,"_probe_block*.txt",sep="")))
}

BMI_neg=c()

for (f in filelist){
	BMI_neg=rbind(BMI_neg,read.table(f,header=T,na.strings=c(999,999000)))
}


BMI_neg$PairType2[BMI_neg$PairType==1]="High_Value"
BMI_neg$PairType2[BMI_neg$PairType==2]="Low_Value"
BMI_neg$PairType2[BMI_neg$PairType==3]="Sanity_Go"
BMI_neg$PairType2[BMI_neg$PairType==4]="Sanity_NoGo"

BMI_neg$PairType3[BMI_neg$bidIndexLeft %in% c(7:14) & BMI_neg$bidIndexRight %in% c(7:14)]="Highest_4"
BMI_neg$PairType3[BMI_neg$bidIndexLeft %in% c(15:30) & BMI_neg$bidIndexRight %in% c(15:30)]="High_mid_4"
BMI_neg$PairType3[BMI_neg$bidIndexLeft %in% c(31:46) & BMI_neg$bidIndexRight %in% c(31:46)]="Low_mid_4"
BMI_neg$PairType3[BMI_neg$bidIndexLeft %in% c(47:54) & BMI_neg$bidIndexRight %in% c(47:54)]="Lowest_4"

tapply(BMI_neg$Outcome,BMI_neg$PairType2,mean,na.rm=T)
tapply(BMI_neg$Outcome,BMI_neg$PairType3,mean,na.rm=T)

summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_neg,(BMI_neg$PairType2=='High_Value')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_neg,(BMI_neg$PairType2=='Low_Value')),na.action=na.omit,family=binomial))

# Highest and lowest 4
tapply(BMI_neg$Outcome,BMI_neg$PairType3,mean,na.rm=T)
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_neg,(BMI_neg$PairType3=='Highest_4')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_neg,(BMI_neg$PairType3=='High_mid_4')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_neg,(BMI_neg$PairType3=='Low_mid_4')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_neg,(BMI_neg$PairType3=='Lowest_4')),na.action=na.omit,family=binomial)) 
