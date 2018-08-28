
rm(list=ls())
path="~/Dropbox/Experiment_Israel/Codes/Boost_fractals_I/Output/"

#BMI_bf_110_probe_block_ 1_run_ 1_18-Feb-2015_12h19m
#BMI_bfr_101_probe_block_ 1_run_ 1_16-Mar-2015_13h20m


list=c(101:102, 104:112, 115:128)

filelist=c()
for (s in list){
	filelist=c(filelist,Sys.glob(paste(path, "BMI_bfr_",s,"_probe_*m.txt",sep="")))
}

BMI_bfr=c()

for (f in filelist){
	BMI_bfr=rbind(BMI_bfr,read.table(f,header=T,na.strings=c(999,999000)))
}

BMI_bfr$PairType2[BMI_bfr$PairType==1]="High_Value"
BMI_bfr$PairType2[BMI_bfr$PairType==2]="Low_Value"
BMI_bfr$PairType2[BMI_bfr$PairType==3]="Sanity_Go"
BMI_bfr$PairType2[BMI_bfr$PairType==4]="Sanity_NoGo"

BMI_bfr$PairType3[BMI_bfr$bidIndexLeft %in% c(7:14) & BMI_bfr$bidIndexRight %in% c(7:14)]="Highest_4"
BMI_bfr$PairType3[BMI_bfr$bidIndexLeft %in% c(15:30) & BMI_bfr$bidIndexRight %in% c(15:30)]="High_mid_4"
BMI_bfr$PairType3[BMI_bfr$bidIndexLeft %in% c(31:46) & BMI_bfr$bidIndexRight %in% c(31:46)]="Low_mid_4"
BMI_bfr$PairType3[BMI_bfr$bidIndexLeft %in% c(47:54) & BMI_bfr$bidIndexRight %in% c(47:54)]="Lowest_4"

tapply(BMI_bfr$Outcome,BMI_bfr$PairType2,mean,na.rm=T)
tapply(BMI_bfr$Outcome,BMI_bfr$PairType3,mean,na.rm=T)

summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bfr,(BMI_bfr$PairType2=='High_Value')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bfr,(BMI_bfr$PairType2=='Low_Value')),na.action=na.omit,family=binomial)) 

summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bfr,(BMI_bfr$PairType3=='Highest_4')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bfr,(BMI_bfr$PairType3=='High_mid_4')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bfr,(BMI_bfr$PairType3=='Low_mid_4')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bfr,(BMI_bfr$PairType3=='Lowest_4')),na.action=na.omit,family=binomial)) 

