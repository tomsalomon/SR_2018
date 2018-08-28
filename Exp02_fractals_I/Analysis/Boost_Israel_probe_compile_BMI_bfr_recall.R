
library(lme4)

rm(list=ls())
# path="~/Dropbox/Schonberglab/Rotem/experiments/BMI_bs_032015/boost_israel_new_rotem_mac/Output/"

# Recall
# for Tom's PC
path="C:/Users/Tom/Dropbox/Experiment_Israel/Codes/Boost_fractals_I_recall/Output/recall/"
# for Tom's iMAC - fractals recall
path="~/Dropbox/Experiment_Israel/Codes/Boost_fractals_I_recall/Output/recall/"
subjects=c(103,104,106,107,109,111,115,116,118:123,125)

# Original
# for Tom's PC
path="C:/Users/Tom/Dropbox/Experiment_Israel/Codes/Boost_fractals_MAC/Output/"
# for Tom's iMAC - fractals
path="~/Dropbox/Experiment_Israel/Codes/Boost_fractals_MAC/Output/"
subjects=c(101:102,104:112,115:128)

# exclude:
# 103 - did probe part twice
# 107 - had poor sanity results - decide later if you want it
# 113 - did the probe part too many times (due to bad code modification)
# 114 - had poor ranking (smaller.

filelist=c()
for (s in subjects){
	filelist=c(filelist,Sys.glob(paste(path, "BMI_bfr_",s,"_probe_block*.txt",sep="")))
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
BMI_bfr$PairType3[BMI_bfr$bidIndexLeft %in% c(47:54) & BMI_bfr$bidIndexRight %in% c(47:54)]="Lowest_4"

BMI_bfr$PairType4[BMI_bfr$bidIndexLeft %in% c(7:18) & BMI_bfr$bidIndexRight %in% c(7:18)]="Highest_6"
BMI_bfr$PairType4[BMI_bfr$bidIndexLeft %in% c(43:54) & BMI_bfr$bidIndexRight %in% c(43:54)]="Lowest_6"

tapply(BMI_bfr$Outcome,BMI_bfr$PairType2,mean,na.rm=T)

summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bfr,(BMI_bfr$PairType2=='High_Value')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bfr,(BMI_bfr$PairType2=='Low_Value')),na.action=na.omit,family=binomial))

# Highest and lowest 4
tapply(BMI_bfr$Outcome,BMI_bfr$PairType3,mean,na.rm=T)
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bfr,(BMI_bfr$PairType3=='Highest_4')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bfr,(BMI_bfr$PairType3=='Lowest_4')),na.action=na.omit,family=binomial))

# Highest and lowest 6
tapply(BMI_bfr$Outcome,BMI_bfr$PairType4,mean,na.rm=T)
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bfr,(BMI_bfr$PairType4=='Highest_6')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(BMI_bfr,(BMI_bfr$PairType4=='Lowest_6')),na.action=na.omit,family=binomial))



# save(BMI_bfr,file=paste("~/Dropbox/Rotem/Analysis/behavior/BMI_bs_n21_20150803.Rdata")
file_name=paste("BMI_bf_n",length(subjects),Sys.Date(),sep = "_")
save(BMI_bfr,file=paste(path,"../Analysis/",file_name,".Rdata",sep=""))
     

summary(glmer(Outcome ~ 1 + PairType + (1|subjectID),data=subset(BMI_bfr,BMI_bfr$PairType %in% c(1,2)),na.action=na.omit,family=binomial)) #effect of Go choice for HH vs LL

# Save data file to ERC
save(BMI_bfr,file=paste("~/Dropbox/Experiment_Israel/Results/ERC_2015/OutputFiles/Fractals_I.RData"))

## Old stuff from Tom's original codes:

#boost_isf_probe$PairType2[boost_isf_probe$bidIndexLeft %in% c(7, 10, 12, 13, 8, 9, 11, 14) & boost_isf_probe$bidIndexRight %in% c(7, 10, 12, 13, 8, 9, 11, 14)]="HHH"
#boost_isf_probe$PairType2[boost_isf_probe$bidIndexLeft %in% c(15, 18, 20, 21, 16, 17, 19, 22) & boost_isf_probe$bidIndexRight %in% c(15, 18, 20, 21, 16, 17, 19, 22)]="HHL"
#boost_isf_probe$PairType2[boost_isf_probe$bidIndexLeft %in% c(39, 42, 44, 45, 40, 41, 43, 46) & boost_isf_probe$bidIndexRight %in% c(39, 42, 44, 45, 40, 41, 43, 46)]="LLH"
#boost_isf_probe$PairType2[boost_isf_probe$bidIndexLeft %in% c(47, 50, 52, 53, 48, 49, 51, 54) & boost_isf_probe$bidIndexRight %in% c(47, 50, 52, 53, 48, 49, 51, 54)]="LLL"
#boost_isf_probe$PairType2[boost_isf_probe$order==1 & boost_isf_probe$bidIndexLeft %in% c(6, 23, 38, 55)]="HLNG"
#boost_isf_probe$PairType2[boost_isf_probe$order==1 & boost_isf_probe$bidIndexLeft %in% c(5, 24, 37, 56)]="HLG"
#boost_isf_probe$PairType2[boost_isf_probe$order==2 & boost_isf_probe$bidIndexLeft %in% c(6, 23, 38, 55)]="HLG"
#boost_isf_probe$PairType2[boost_isf_probe$order==2 & boost_isf_probe$bidIndexLeft %in% c(5, 24, 37, 56)]="HLNG"

#aaaa=subset(boost_isf_probe,(boost_isf_probe$PairType2=='HHH')) 
#bbbb=subset(boost_isf_probe,(boost_isf_probe$PairType2=='LLL'))

#total=rbind(aaaa, bbbb)
#boost_isf_probe=c()

#boost_isf_probe=total


# for (i in 1:length(boost_isf_probe$PairType2)){
# 	
# 	if (boost_isf_probe$order[i]==1){
# 		
# 		if (boost_isf_probe$PairType2[i]=="HHH"){
# 	
# 			if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(7, 10, 12, 13)){
# 			#if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(7, 10, 12, 13,15,18,20,21)){
# 				boost_isf_probe$Outcome2[i]=1
# 				}
# 			#else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(7, 10, 12, 13,15,18,20,21)){
# 			else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(7, 10, 12, 13)){
# 				boost_isf_probe$Outcome2[i]=1
# 				}
# 			else if (boost_isf_probe$Response[i]=="x"){
# 				boost_isf_probe$Outcome2[i]=NA
# 				}	
# 		
# 			else{
# 				boost_isf_probe$Outcome2[i]=0
# 				}
# 			}
# 
# 		else if (boost_isf_probe$PairType2[i]=="LLL"){
# 	
# 			if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(47, 50, 52, 53)){
# 			#if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(39,42,44,45,47, 50, 52, 53)){
# 				boost_isf_probe$Outcome2[i]=1
# 				}
# 			else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(47, 50, 52, 53)){
# 			#else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(39,42,44,45,47, 50, 52, 53)){
# 				boost_isf_probe$Outcome2[i]=1
# 				}
# 			else if (boost_isf_probe$Response[i]=="x"){
# 				boost_isf_probe$Outcome2[i]=NA
# 				}	
# 		
# 			else{
# 				boost_isf_probe$Outcome2[i]=0		
# 				}
# 			}
# 
# 		else if (boost_isf_probe$PairType2[i]=="HLNG"){
# 	
# 			if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(6, 23)){
# 				boost_isf_probe$Outcome2[i]=1
# 				}
# 			else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(6, 23)){
# 				boost_isf_probe$Outcome2[i]=1
# 				}
# 			else if (boost_isf_probe$Response[i]=="x"){
# 				boost_isf_probe$Outcome2[i]=NA
# 				}	
# 		
# 			else{
# 				boost_isf_probe$Outcome2[i]=0		
# 				}
# 			}
# 			
# 		else if (boost_isf_probe$PairType2[i]=="HLG"){
# 	
# 			if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(5, 24)){
# 				boost_isf_probe$Outcome2[i]=1
# 				}
# 			else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(5, 24)){
# 				boost_isf_probe$Outcome2[i]=1
# 				}
# 			else if (boost_isf_probe$Response[i]=="x"){
# 				boost_isf_probe$Outcome2[i]=NA
# 				}	
# 		
# 			else{
# 				boost_isf_probe$Outcome2[i]=0		
# 				}
# 			}					
# 				
# 	}
# 	else if (boost_isf_probe$order[i]==2){
# 		if (boost_isf_probe$PairType2[i]=="HHH"){
# 	
# 			 if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(8, 9, 11, 14)){
# 			#if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(8, 9, 11, 14,16,17,19,22)){
# 				boost_isf_probe$Outcome2[i]=1
# 				}
# 			#else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(8, 9, 11, 14,16,17,19,22)){
# 		 	else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(8, 9, 11, 14)){
# 				boost_isf_probe$Outcome2[i]=1
# 				}
# 			else if (boost_isf_probe$Response[i]=="x"){
# 				boost_isf_probe$Outcome2[i]=NA
# 				}	
# 			else{
# 				boost_isf_probe$Outcome2[i]=0
# 				}
# 			}
# 
# 		else if (boost_isf_probe$PairType2[i]=="LLL"){
# 	
# 			if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(48, 49, 51, 54)){
# 			#if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(40,41,43,46, 48, 49, 51, 54)){
# 				boost_isf_probe$Outcome2[i]=1
# 				}
# 			else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(48, 49, 51, 54)){
# 			#else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(40,41,43,46, 48, 49, 51, 54)){
# 				boost_isf_probe$Outcome2[i]=1
# 				}
# 			else if (boost_isf_probe$Response[i]=="x"){
# 				boost_isf_probe$Outcome2[i]=NA
# 				}	
# 		
# 			else{
# 				boost_isf_probe$Outcome2[i]=0		
# 				}
# 			}
# 
# 		else if (boost_isf_probe$PairType2[i]=="HLNG"){
# 	
# 			if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(5, 24)){
# 				boost_isf_probe$Outcome2[i]=1
# 				}
# 			else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(5, 24)){
# 				boost_isf_probe$Outcome2[i]=1
# 				}
# 			else if (boost_isf_probe$Response[i]=="x"){
# 				boost_isf_probe$Outcome2[i]=NA
# 				}	
# 		
# 			else{
# 				boost_isf_probe$Outcome2[i]=0		
# 				}
# 			}
# 			
# 		else if (boost_isf_probe$PairType2[i]=="HLG"){
# 	
# 			if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(6, 23)){
# 				boost_isf_probe$Outcome2[i]=1
# 				}
# 			else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(6, 23)){
# 				boost_isf_probe$Outcome2[i]=1
# 				}
# 			else if (boost_isf_probe$Response[i]=="x"){
# 				boost_isf_probe$Outcome2[i]=NA
# 				}	
# 		
# 			else{
# 				boost_isf_probe$Outcome2[i]=0		
# 				}
# 			}	
# 		}
# }



load("~/Dropbox/Boost/paper/data/probe_allstudies.RData")
boost_probe=subset(probe,probe$sample==1&probe$study=="boost")
boost_probe$subjid=drop.levels(boost_probe$subjid)
boost_probe$Outcome2=boost_probe$Outcome
boost_isf_probe$sample=2
boost_isf_probe$study="boost"
names(boost_probe)[16:17]=c("bidLeft","bidRight")
boost_probe$timeFixLeft=NA
boost_probe$timeFixMid=NA
boost_probe$timeFixRight=NA
boost_probe$numLeftFix=NA
boost_probe$numMidFix=NA
boost_probe$numRightFix=NA
boost_probe$firstFix=NA
boost_probe$firstFixTime=NA
boost_orig_isf_probe=rbind(boost_probe,boost_isf_probe)

summary(glmer(Outcome2 ~ sample + (1|subjid),data=subset(boost_orig_isf_probe,boost_orig_isf_probe$PairType==1),na.action=na.omit,family=binomial))
# boost vs isf HH p=0.6130
summary(glmer(Outcome2 ~ sample + (1|subjid),data=subset(boost_orig_isf_probe,boost_orig_isf_probe$PairType==2),na.action=na.omit,family=binomial))
# boost vs isf HH p=0.879

