
library(lme4)

rm(list=ls())

## Original Sample
#For iMac
path="~/Drive/Experiment_Israel/Codes/Boost_faces_new/Output/"
subjects=c(101:120,122:126)
# Excluded:
# 121 - did not look at the images during training

## Follow-up
#For iMac
path="~/Drive/Experiment_Israel/Codes/Boost_faces_new/Output/recall/"
subjects=c(101:103,105:107,109:111,113,116:120,122:123,125)



filelist=c()
for (s in subjects){
	filelist=c(filelist,Sys.glob(paste(path, "BMI_bf_",s,"_probe_block*.txt",sep="")))
}

BMI_bf_II=c()

for (f in filelist){
	BMI_bf_II=rbind(BMI_bf_II,read.table(f,header=T,na.strings=c(999,999000)))
}


# BMI_bf_II$PairType2[BMI_bf_II$bidIndexLeft %in% c(7, 10, 12, 13, 8, 9, 11, 14,15, 18, 20, 21, 16, 17, 19, 22)]="HHHA"
# BMI_bf_II$PairType2[BMI_bf_II$bidIndexLeft %in% c(39, 42, 44, 45, 40, 41, 43, 46,47, 50, 52, 53, 48, 49, 51, 54)]="LLLA"
BMI_bf_II$PairType2[BMI_bf_II$PairType==1]="High_Value"
BMI_bf_II$PairType2[BMI_bf_II$PairType==2]="Low_Value"
BMI_bf_II$PairType2[BMI_bf_II$PairType==4]="Sanity"

tapply(BMI_bf_II$Outcome,BMI_bf_II$PairType2,mean,na.rm=T)

summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bf_II,(BMI_bf_II$PairType2=='High_Value')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bf_II,(BMI_bf_II$PairType2=='Low_Value')),na.action=na.omit,family=binomial))

HV=summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bf_II,(BMI_bf_II$PairType2=='High_Value')),na.action=na.omit,family=binomial)) 
LV=summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bf_II,(BMI_bf_II$PairType2=='Low_Value')),na.action=na.omit,family=binomial))
HV_CI=c(HV$coefficients[1]-1.96*HV$coefficients[2],HV$coefficients[1]+1.96*HV$coefficients[2]) # HV Confidence interval (in log odds)
LV_CI=c(LV$coefficients[1]-1.96*LV$coefficients[2],LV$coefficients[1]+1.96*LV$coefficients[2]) # LV Confidence interval (in log odds)
exp(HV_CI)/(1+exp(HV_CI)) # HV Confidence interval (in proportions)
exp(LV_CI)/(1+exp(LV_CI)) # LV Confidence interval (in proportions)

summary(glmer(Outcome ~ 1 + PairType + (1|subjectID),data=subset(BMI_bf_II,BMI_bf_II$PairType %in% c(1,2)),na.action=na.omit,family=binomial)) #effect of Go choice for HH vs LL
# summary(glmer(Outcome ~ (1|subjectID),data=subset(BMI_bf_II,BMI_bf_II$PairType %in% c(1,2)),na.action=na.omit,family=binomial)) # OLD CODE: effect of Go choice for HH vs LL
data_by_subject=as.data.frame(tapply(BMI_bf_II$Outcome,list(SubjID=BMI_bf_II$subjectID,PairType=BMI_bf_II$PairType2),mean,na.rm=T))
ggplot(data_by_subject,aes(High_Value,Low_Value,color=High_Value))+
  ylim(0,1) + xlim(0,1) +
  geom_hline(yintercept = 0.5, linetype=2) +
  geom_vline(xintercept = 0.5, linetype=2) +
  geom_point(shape = 16, size = 5, alpha= 0.9) +
  theme_bw()

