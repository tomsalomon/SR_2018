
library(lme4)

rm(list=ls())

## Original Sample
#For iMac
path="~/Dropbox/Experiment_Israel/Codes/Boost_fractals_II/Output/"
# For PC
path="C:/Users/Tom/Dropbox/Experiment_Israel/Codes/Boost_fractals_II/Output/"
subjects=c(101:113,115:124,126:127)
#exclude:
# 114 - had problems with the sound at one training run
# 125 - stop responding in parts of training


## Follow-up
#For iMac
path="~/Dropbox/Experiment_Israel/Codes/Boost_fractals_II/Output/recall/"
# For PC
path="C:/Users/Tom/Dropbox/Experiment_Israel/Codes/Boost_fractals_II/Output/recall/"
subjects=c(102:104,106,108,110:111,113,115:116,118:120,123:124,126)
# Excluded:
# 114 - sound didn't work in some training parts
# 125 - stop responding at parts of training

filelist=c()
for (s in subjects){
	filelist=c(filelist,Sys.glob(paste(path, "BMI_*",s,"_probe_block*.txt",sep="")))
}

BMI_bfr_II=c()

for (f in filelist){
	BMI_bfr_II=rbind(BMI_bfr_II,read.table(f,header=T,na.strings=c(999,999000)))
}


# BMI_bfr_II$PairType2[BMI_bfr_II$bidIndexLeft %in% c(7, 10, 12, 13, 8, 9, 11, 14,15, 18, 20, 21, 16, 17, 19, 22)]="HHHA"
# BMI_bfr_II$PairType2[BMI_bfr_II$bidIndexLeft %in% c(39, 42, 44, 45, 40, 41, 43, 46,47, 50, 52, 53, 48, 49, 51, 54)]="LLLA"
BMI_bfr_II$PairType2[BMI_bfr_II$PairType==1]="High_Value"
BMI_bfr_II$PairType2[BMI_bfr_II$PairType==2]="Low_Value"
BMI_bfr_II$PairType2[BMI_bfr_II$PairType==4]="Sanity"

tapply(BMI_bfr_II$Outcome,BMI_bfr_II$PairType2,mean,na.rm=T)

summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bfr_II,(BMI_bfr_II$PairType2=='High_Value')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bfr_II,(BMI_bfr_II$PairType2=='Low_Value')),na.action=na.omit,family=binomial))

# save(BMI_bfr_II,file=paste("~/Dropbox/Rotem/Analysis/behavior/BMI_bs_n21_20150803.Rdata")
# file_name=paste("BMI_bf_n",length(subjects),Sys.Date(),sep = "_")
# save(BMI_bfr_II,file=paste(path,"../Analysis/",file_name,".Rdata",sep=""))
     

summary(glmer(Outcome ~ 1 + PairType + (1|subjectID),data=subset(BMI_bfr_II,BMI_bfr_II$PairType %in% c(1,2)),na.action=na.omit,family=binomial)) #effect of Go choice for HH vs LL
# summary(glmer(Outcome ~ (1|subjectID),data=subset(BMI_bfr_II,BMI_bfr_II$PairType %in% c(1,2)),na.action=na.omit,family=binomial)) # OLD CODE: effect of Go choice for HH vs LL


# Save data file to ERC 2015 
save(BMI_bfr_II,file=paste("~/Dropbox/Experiment_Israel/Results/ERC_2015/OutputFiles/Fractals_II.RData"))

