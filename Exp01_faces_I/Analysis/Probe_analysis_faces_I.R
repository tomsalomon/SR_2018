
library(lme4 )
library(ggplot2)

rm(list=ls())
# path="~/Dropbox/Schonberglab/Rotem/experiments/BMI_bs_032015/boost_israel_new_rotem_mac/Output/"

## Original Sample
#For iMac
path="~/Dropbox/Experiment_Israel/Codes/Boost_faces/Output/"
# For PC
#path="C:/Users/Tom/Dropbox/Experiment_Israel/Codes/Boost_faces/Output/"
subjects=c(101:116,119:120,125:134) # Define here your subjects' codes.
subjects=c(101:104,106,108:110,112:114,119:120,125:126,130,132:134) # Define here your subjects' codes.

# exclude:
# 117 - did snack version of the experiment 3 month prior to the experimnet
# 118 & 121 - were over 40 years old
# 122:124 - did the training part with the Psychtoolbox's audio function


filelist=c()
for (s in subjects){
	filelist=c(filelist,Sys.glob(paste(path, "BMI_bf_",s,"_probe_block*.txt",sep="")))
}

BMI_bf=c()

for (f in filelist){
	BMI_bf=rbind(BMI_bf,read.table(f,header=T,na.strings=c(999,999000)))
}


BMI_bf$PairType2[BMI_bf$PairType==1]="High_Value"
BMI_bf$PairType2[BMI_bf$PairType==2]="Low_Value"
BMI_bf$PairType2[BMI_bf$PairType==3]="Sanity_Go"
BMI_bf$PairType2[BMI_bf$PairType==4]="Sanity_NoGo"

BMI_bf$PairType3[BMI_bf$bidIndexLeft %in% c(7:14) & BMI_bf$bidIndexRight %in% c(7:14)]="Highest_4"
BMI_bf$PairType3[BMI_bf$bidIndexLeft %in% c(15:30) & BMI_bf$bidIndexRight %in% c(15:30)]="High_mid_4"
BMI_bf$PairType3[BMI_bf$bidIndexLeft %in% c(31:46) & BMI_bf$bidIndexRight %in% c(31:46)]="Low_mid_4"
BMI_bf$PairType3[BMI_bf$bidIndexLeft %in% c(47:54) & BMI_bf$bidIndexRight %in% c(47:54)]="Lowest_4"

tapply(BMI_bf$Outcome,BMI_bf$PairType2,mean,na.rm=T)
tapply(BMI_bf$Outcome,BMI_bf$PairType3,mean,na.rm=T)

summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bf,(BMI_bf$PairType2=='High_Value')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bf,(BMI_bf$PairType2=='Low_Value')),na.action=na.omit,family=binomial))

# Highest and lowest 4
tapply(BMI_bf$Outcome,BMI_bf$PairType3,mean,na.rm=T)
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bf,(BMI_bf$PairType3=='Highest_4')),na.action=na.omit,family=binomial))
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bf,(BMI_bf$PairType3=='High_mid_4')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bf,(BMI_bf$PairType3=='Low_mid_4')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bf,(BMI_bf$PairType3=='Lowest_4')),na.action=na.omit,family=binomial))

Results_by_subject=as.data.frame(tapply(BMI_bf$Outcome,list(BMI_bf$subjectID,BMI_bf$PairType3),mean,na.rm=T))
Results_by_subject$PHQ=c(10,3,11,10,15,14,13,11,14,11,4,5,1,3,0,4,1,3,8,3,15,12,10,2,NA,NA,NA,NA)
Results_by_subject$diff=Results_by_subject$Highest_4 - Results_by_subject$High_mid_4
ggplot(data = Results_by_subject, aes(x=diff, y=PHQ, color=PHQ)) +
  geom_point(shape = 16, size = 5, alpha= 0.9, na.rm = T)

