
rm(list=ls())
path="../Dropbox/Experiment_Israel/Codes/Boost_faces_new/Output/"


#BMI_bf_110_probe_block_ 1_run_ 1_18-Feb-2015_12h19m

list=c(101:103)

filelist=c()
for (s in list){
	filelist=c(filelist,Sys.glob(paste(path, "BMI_bf_",s,"_probe_*m.txt",sep="")))
}

boost_isf_probe=c()

for (f in filelist){
	boost_isf_probe=rbind(boost_isf_probe,read.table(f,header=T,na.strings=c(999,999000)))
}


boost_isf_probe$PairType2[boost_isf_probe$bidIndexLeft %in% c(7, 10, 12, 13, 8, 9, 11, 14,15, 18, 20, 21, 16, 17, 19, 22)]="HHHA"
boost_isf_probe$PairType2[boost_isf_probe$bidIndexLeft %in% c(39, 42, 44, 45, 40, 41, 43, 46,47, 50, 52, 53, 48, 49, 51, 54)]="LLLA"

boost_isf_probe$PairType2[boost_isf_probe$bidIndexLeft %in% c(7, 10, 12, 13, 8, 9, 11, 14) & boost_isf_probe$bidIndexRight %in% c(7, 10, 12, 13, 8, 9, 11, 14)]="HHH"
boost_isf_probe$PairType2[boost_isf_probe$bidIndexLeft %in% c(15, 18, 20, 21, 16, 17, 19, 22) & boost_isf_probe$bidIndexRight %in% c(15, 18, 20, 21, 16, 17, 19, 22)]="HHL"
boost_isf_probe$PairType2[boost_isf_probe$bidIndexLeft %in% c(39, 42, 44, 45, 40, 41, 43, 46) & boost_isf_probe$bidIndexRight %in% c(39, 42, 44, 45, 40, 41, 43, 46)]="LLH"
boost_isf_probe$PairType2[boost_isf_probe$bidIndexLeft %in% c(47, 50, 52, 53, 48, 49, 51, 54) & boost_isf_probe$bidIndexRight %in% c(47, 50, 52, 53, 48, 49, 51, 54)]="LLL"
boost_isf_probe$PairType2[boost_isf_probe$order==1 & boost_isf_probe$bidIndexLeft %in% c(23, 26, 35, 38)]="HLNG"
boost_isf_probe$PairType2[boost_isf_probe$order==1 & boost_isf_probe$bidIndexLeft %in% c(24, 25, 36, 37)]="HLG"
boost_isf_probe$PairType2[boost_isf_probe$order==2 & boost_isf_probe$bidIndexLeft %in% c(23, 26, 35, 38)]="HLG"
boost_isf_probe$PairType2[boost_isf_probe$order==2 & boost_isf_probe$bidIndexLeft %in% c(24, 25, 36, 37)]="HLNG"

#aaaa=subset(boost_isf_probe,(boost_isf_probe$PairType2=='HHH')) 
#bbbb=subset(boost_isf_probe,(boost_isf_probe$PairType2=='LLL'))

#total=rbind(aaaa, bbbb)
#boost_isf_probe=c()

#boost_isf_probe=total


for (i in 1:length(boost_isf_probe$PairType2)){
	
	if (boost_isf_probe$order[i]==1){
		
		if (boost_isf_probe$PairType2[i]=="HHH"){
	
			if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(7, 10, 12, 13)){
			#if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(7, 10, 12, 13,15,18,20,21)){
				boost_isf_probe$Outcome2[i]=1
				}
			#else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(7, 10, 12, 13,15,18,20,21)){
			else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(7, 10, 12, 13)){
				boost_isf_probe$Outcome2[i]=1
				}
			else if (boost_isf_probe$Response[i]=="x"){
				boost_isf_probe$Outcome2[i]=NA
				}	
		
			else{
				boost_isf_probe$Outcome2[i]=0
				}
			}

		else if (boost_isf_probe$PairType2[i]=="LLL"){
	
			if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(47, 50, 52, 53)){
			#if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(39,42,44,45,47, 50, 52, 53)){
				boost_isf_probe$Outcome2[i]=1
				}
			else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(47, 50, 52, 53)){
			#else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(39,42,44,45,47, 50, 52, 53)){
				boost_isf_probe$Outcome2[i]=1
				}
			else if (boost_isf_probe$Response[i]=="x"){
				boost_isf_probe$Outcome2[i]=NA
				}	
		
			else{
				boost_isf_probe$Outcome2[i]=0		
				}
			}

		else if (boost_isf_probe$PairType2[i]=="HLNG"){
	
			if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(23, 26)){
				boost_isf_probe$Outcome2[i]=1
				}
			else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(23, 26)){
				boost_isf_probe$Outcome2[i]=1
				}
			else if (boost_isf_probe$Response[i]=="x"){
				boost_isf_probe$Outcome2[i]=NA
				}	
		
			else{
				boost_isf_probe$Outcome2[i]=0		
				}
			}
			
		else if (boost_isf_probe$PairType2[i]=="HLG"){
	
			if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(24, 25)){
				boost_isf_probe$Outcome2[i]=1
				}
			else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(24, 25)){
				boost_isf_probe$Outcome2[i]=1
				}
			else if (boost_isf_probe$Response[i]=="x"){
				boost_isf_probe$Outcome2[i]=NA
				}	
		
			else{
				boost_isf_probe$Outcome2[i]=0		
				}
			}					
				
	}
	else if (boost_isf_probe$order[i]==2){
		if (boost_isf_probe$PairType2[i]=="HHH"){
	
			 if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(8, 9, 11, 14)){
			#if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(8, 9, 11, 14,16,17,19,22)){
				boost_isf_probe$Outcome2[i]=1
				}
			#else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(8, 9, 11, 14,16,17,19,22)){
		 	else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(8, 9, 11, 14)){
				boost_isf_probe$Outcome2[i]=1
				}
			else if (boost_isf_probe$Response[i]=="x"){
				boost_isf_probe$Outcome2[i]=NA
				}	
			else{
				boost_isf_probe$Outcome2[i]=0
				}
			}

		else if (boost_isf_probe$PairType2[i]=="LLL"){
	
			if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(48, 49, 51, 54)){
			#if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(40,41,43,46, 48, 49, 51, 54)){
				boost_isf_probe$Outcome2[i]=1
				}
			else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(48, 49, 51, 54)){
			#else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(40,41,43,46, 48, 49, 51, 54)){
				boost_isf_probe$Outcome2[i]=1
				}
			else if (boost_isf_probe$Response[i]=="x"){
				boost_isf_probe$Outcome2[i]=NA
				}	
		
			else{
				boost_isf_probe$Outcome2[i]=0		
				}
			}

		else if (boost_isf_probe$PairType2[i]=="HLNG"){
	
			if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(24, 25)){
				boost_isf_probe$Outcome2[i]=1
				}
			else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(24, 25)){
				boost_isf_probe$Outcome2[i]=1
				}
			else if (boost_isf_probe$Response[i]=="x"){
				boost_isf_probe$Outcome2[i]=NA
				}	
		
			else{
				boost_isf_probe$Outcome2[i]=0		
				}
			}
			
		else if (boost_isf_probe$PairType2[i]=="HLG"){
	
			if (boost_isf_probe$Response[i]=="u" & boost_isf_probe$bidIndexLeft[i] %in% c(23, 26)){
				boost_isf_probe$Outcome2[i]=1
				}
			else if (boost_isf_probe$Response[i]=="i" & boost_isf_probe$bidIndexRight[i] %in% c(23, 26)){
				boost_isf_probe$Outcome2[i]=1
				}
			else if (boost_isf_probe$Response[i]=="x"){
				boost_isf_probe$Outcome2[i]=NA
				}	
		
			else{
				boost_isf_probe$Outcome2[i]=0		
				}
			}	
		}
}



tapply(boost_isf_probe$Outcome2,boost_isf_probe$PairType2,mean,na.rm=T)


summary(glmer(Outcome ~ 1 + (1|subjectID),data=subset(boost_isf_probe,(boost_isf_probe$PairType2=='HHH')),na.action=na.omit,family=binomial)) 
summary(glmer(Outcome2 ~ 1 + (1|subjectID),data=subset(boost_isf_probe,(boost_isf_probe$PairType2=='LLL')),na.action=na.omit,family=binomial))

# save(boost_isf_probe,file="~/Dropbox/Experiment_Israel/Codes/Boost_faces/Analysis/faces_n28_July21.Rdata")
outfile_name=
save(boost_isf_probe,file=paste(path,outfile_name))


summary(glmer(Outcome2 ~ PairType + (1|subjectID),data=subset(boost_isf_probe,boost_isf_probe$PairType %in% c(1,2)),na.action=na.omit,family=binomial)) #effect of Go choice for HH vs LL

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

