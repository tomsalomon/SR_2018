rm(list=ls())

load("~/Dropbox/Experiment_Israel/Codes/Boost_faces/Analysis/faces_n28_July21.Rdata")
#load("~/Dropbox/Boost_Israel/R/boost_isf_train.RData")
#load("~/Dropbox/Boost_Israel/R/boost_isf_probe.RData")

labcex=1.5
axiscex=1.2
namecex=1.2
titlecex=1.8
pluscex=1.2
starcex=1.5
legendcex=1.8
linewd=2
ptcex=1.5
samp="Faces"
present=12
num=length(levels(as.factor(boost_isf_probe$subjectID)))

#####PLOT WTP####

#BDM=subset(boost_isf_BDM,boost_isf_BDM$PairType=="HHH"|boost_isf_BDM$PairType=="HHNG"|boost_isf_BDM$PairType=="LLG"|boost_isf_BDM$PairType=="LLNG")

#BDM$go[BDM$PairType=="LLG"|BDM$PairType=="HHG"]="go"
#BDM$go[BDM$PairType=="LLNG"|BDM$PairType=="HHNG"]="nogo"
#BDM$high[BDM$PairType=="HHG"|BDM$PairType=="HHNG"]="high"
#BDM$high[BDM$PairType=="LLG"|BDM$PairType=="LLNG"]="low"

#tmp=data.frame(bid=c(BDM$Bid,BDM$Bid2),time=c(rep(1,length(BDM$Bid)),rep(2,length(BDM$Bid2))),go=rep(BDM$go,2),high=rep(BDM$high,2),subjid=rep(BDM$subjid,2))
#tmp_high=subset(tmp,tmp$high=="high")
#tmp_low=subset(tmp,tmp$high=="low")
#mhigh=tapply(tmp_high$bid,list(tmp_high$go,tmp_high$time),mean)
#mlow=tapply(tmp_low$bid,list(tmp_low$go,tmp_low$time),mean)

#sehigh=rbind(c(std.error(as.numeric(tapply(tmp_high$bid[tmp_high$go=="go"&tmp_high$time==1],tmp_high$subjid[tmp_high$go=="go"&tmp_high$time==1],mean))),std.error(as.numeric(tapply(tmp_high$bid[tmp_high$go=="go"&tmp_high$time==2],tmp_high$subjid[tmp_high$go=="go"&tmp_high$time==2],mean)))),c(std.error(as.numeric(tapply(tmp_high$bid[tmp_high$go=="nogo"&tmp_high$time==1],tmp_high$subjid[tmp_high$go=="nogo"&tmp_high$time==1],mean)),std.error(as.numeric(tapply(tmp_high$bid[tmp_high$go=="nogo"&tmp_high$time==2],tmp_high$subjid[tmp_high$go=="nogo"&tmp_high$time==2],mean))))))

#selow=rbind(c(std.error(as.numeric(tapply(tmp_low$bid[tmp_low$go=="go"&tmp_low$time==1],tmp_low$subjid[tmp_low$go=="go"&tmp_low$time==1],mean))),std.error(as.numeric(tapply(tmp_low$bid[tmp_low$go=="go"&tmp_low$time==2],tmp_low$subjid[tmp_low$go=="go"&tmp_low$time==2],mean)))),c(std.error(as.numeric(tapply(tmp_low$bid[tmp_low$go=="nogo"&tmp_low$time==1],tmp_low$subjid[tmp_low$go=="nogo"&tmp_low$time==1],mean)),std.error(as.numeric(tapply(tmp_low$bid[tmp_low$go=="nogo"&tmp_low$time==2],tmp_low$subjid[tmp_low$go=="nogo"&tmp_low$time==2],mean))))))

par(mar=c(5,5,5,1))
plot(mhigh[1,],ty="l",ylim=range(.4,2),xlim=range(0.5,2.5),lwd=linewd,axes=F,ylab="WTP in dollars",xlab="Time",cex.lab=labcex,main=paste("WTPs pre- and post- training \n for ", samp," (N=",num,")",sep=""),cex.main=titlecex)
axis(1,at=c(1,2),labels=c("Pretrain","Posttrain"),cex.axis=axiscex,tck=-0.01)
axis(2,at=c(.4,.8,1.2,1.6,2),labels=c(.4,.8,1.2,1.6,""),cex.axis=axiscex,tck=-0.01)
points(1,mhigh[1,1],pch=15,cex=ptcex)
points(2,mhigh[1,2],pch=15,cex=ptcex)
lines(c(1,1),c(mhigh[1,1],mhigh[1,1]+sehigh[1,1]),lwd=linewd)
lines(c(.99,1.01),rep(mhigh[1,1]+sehigh[1,1],2),lwd=linewd)
lines(c(2,2),c(mhigh[1,2],mhigh[1,2]+sehigh[1,2]),lwd=linewd)
lines(c(1.99,2.01),rep(mhigh[1,2]+sehigh[1,2],2),lwd=linewd)
lines(mhigh[2,],lwd=linewd,lty=2)
points(1,mhigh[2,1],pch=17,cex=ptcex)
points(2,mhigh[2,2],pch=17,cex=ptcex)
lines(c(1,1),c(mhigh[2,1],mhigh[2,1]-sehigh[2,1]),lwd=linewd)
lines(c(.99,1.01),rep(mhigh[2,1]-sehigh[2,1],2),lwd=linewd)
lines(c(2,2),c(mhigh[2,2],mhigh[2,2]-sehigh[2,2]),lwd=linewd)
lines(c(1.99,2.01),rep(mhigh[2,2]-sehigh[2,2],2),lwd=linewd)

lines(c(1,2),c(mlow[1,1],mlow[1,2]),lwd=linewd)
points(1,mlow[1,1],pch=15,cex=ptcex)
points(2,mlow[1,2],pch=15,cex=ptcex)
lines(c(1,1),c(mlow[1,1],mlow[1,1]+selow[1,1]),lwd=linewd)
lines(c(.99,1.01),rep(mlow[1,1]+selow[1,1],2),lwd=linewd)
lines(c(2,2),c(mlow[1,2],mlow[1,2]+selow[1,2]),lwd=linewd)
lines(c(1.99,2.01),rep(mlow[1,2]+selow[1,2],2),lwd=linewd)
lines(mlow[2,],lwd=linewd,lty=2)
points(1,mlow[2,1],pch=17,cex=ptcex)
points(2,mlow[2,2],pch=17,cex=ptcex)
lines(c(1,1),c(mlow[2,1],mlow[2,1]-selow[2,1]),lwd=linewd)
lines(c(.99,1.01),rep(mlow[2,1]-selow[2,1],2),lwd=linewd)
lines(c(2,2),c(mlow[2,2],mlow[2,2]-selow[2,2]),lwd=linewd)
lines(c(1.99,2.01),rep(mlow[2,2]-selow[2,2],2),lwd=linewd)

legend(c(0,1.3),lty=c(1,2),pch=c(15,17),lwd=linewd,c("GO items", "NOGO items"),border=NA,box.col=NA,cex=legendcex)
p1=mixed(bid ~ time * go +(1|subjid),data=tmp_high)
p2=mixed(bid ~ time * go +(1|subjid),data=tmp_low)
if (p1$anova.table$p.value[4]<0.0001){sig1="***"} else if (p1$anova.table$p.value[4]<0.001){sig1="**"} else if (p1$anova.table$p.value[4]<0.01){sig1="*"} else if (p1$anova.table$p.value[4]<0.05){sig1="+"} else {sig1=""}
if (p2$anova.table$p.value[4]<0.0001){sig2="***"} else if (p2$anova.table$p.value[4]<0.001){sig2="**"} else if (p2$anova.table$p.value[4]<0.01){sig2="*"} else if (p2$anova.table$p.value[4]<0.05){sig2="+"} else {sig2=""}
#lines(c(1,2),c(1.88,1.88),lwd=1)
#text(1.5,1.9,sig1,cex=2)
text(1.5,1.8,sig1,cex=starcex)
#lines(c(1,2),c(.8,.8),lwd=1)
#text(1.5,.82,sig2,cex=1.6)
text(1.5,.72,sig2,cex=pluscex)
text(2.2,1.95, "High value items" ,pos=4,cex=axiscex,srt=270)
text(2.2,.95, "Low value items" ,pos=4,cex=axiscex,srt=270)

#######Plot training######

m1=tapply(boost_isf_train$ladder1,list(boost_isf_train$runnum,boost_isf_train$subjid),mean)
m2=tapply(boost_isf_train$ladder2,list(boost_isf_train$runnum,boost_isf_train$subjid),mean)
se1=c()
se2=c()
for (s in 1:16){
	se1=c(se1,std.error(m1[s,]))
	se2=c(se2,std.error(m2[s,]))
}
ms1=tapply(boost_isf_train$ladder1,boost_isf_train$runnum,mean)
ms2=tapply(boost_isf_train$ladder2,boost_isf_train$runnum,mean)

plot(ms1,ty='l',ylab="ladders (ms)",main=paste("Cue Approach Choose w/ Eyes study training (N=",num,")",sep=""),ylim=c(650,850),col="red",xlab="Run")
polygon(c(1:16,16:1),c(ms1+se1,rev(ms1-se1)),col=rgb(1,0,0,alpha=.5),lty=NULL,border=NA)
lines(ms2,col="blue")
polygon(c(1:16,16:1),c(ms2+se2,rev(ms2-se2)),col=rgb(0,0,1,alpha=.5),lty=NULL,border=NA)
legend("bottomright",lty=1,col=c("red","blue"),c("Ladder1","Ladder2"))

#######Plot probe######

boost_probe=boost_isf_probe

m=tapply(boost_probe$Outcome2,list(boost_probe$subjectID,boost_probe$PairType2),mean,na.rm=T)

t1=glmer(Outcome2 ~ 1 + (1| subjectID),data=subset(boost_probe,(boost_probe$PairType2=='HHH')),na.action=na.omit,family=binomial)
vc1 <- vcov(t1, useScale = FALSE)
b1 <- fixef(t1)
z1 <- b1 / sqrt(diag(vc1))
p1 <- 2 * (1 - pnorm(abs(z1)))
t2=glmer(Outcome2 ~ 1 + (1| subjectID),data=subset(boost_probe,(boost_probe$PairType2=='LLL')),na.action=na.omit,family=binomial)
 
vc2<- vcov(t2, useScale = FALSE)
b2 <- fixef(t2)
z2 <- b2 / sqrt(diag(vc2))
p2 <- 2 * (1 - pnorm(abs(z2)))


p=c(p1,p2)



sd=c(tapply(boost_probe$Outcome2, boost_probe$PairType2,sd,na.rm=T)[1],tapply(boost_probe$Outcome2, boost_probe$PairType2,sd,na.rm=T)[7])
se1=sd(m[,1])/sqrt(length(levels(boost_probe$subjectID)))
se2=sd(m[,7])/sqrt(length(levels(boost_probe$subjectID)))
se=c(se1,se2)

ms=tapply(boost_probe$Outcome2, boost_probe$PairType2, mean,na.rm=T)
ms=c(ms[1],ms[7])

par(mar=c(4,3,4,0.5), mgp=c(1.5,0.4,0),oma=c(.5,.5,.5,.5))

xvals=barplot(ms,ylim=range(0,1),xlim=c(0,1),width=.2,space=c(1,1),ylab="Proportion of GO item choices at probe", main=paste("Proportion of GO item choices at probe \n for faces study (N=", length(levels(boost_probe$subjectID)),", 12 repetitions)", sep=""), cex.lab=labcex, cex.names=namecex,cex.axis=axiscex,cex.main=titlecex,axes=F, border=NA,col=c("dodgerblue1","firebrick2"),names.arg=c("",""))
errbar(xvals,ms,ms+se,ms-se,pch="",add=T,lwd=2,cap=.01)
lines(c(-.5,21.5),c(.5,.5),lty=2,lwd=2)
axis(2,at=c(0,.2,.4,.6,.8,1),labels=c("",.2,.4,.6,.8,""),cex.axis=axiscex,tck=-0.01)
mtext("High GO \n vs. \n High NOGO", at=xvals[1],side=1,line=3.3,cex=1.5)
mtext("Low GO \n vs. \n Low NOGO", at=xvals[2],side=1,line=3.3,cex=1.5)

for (s in 1:2){
 	if (p[s]<0.0001){sig="***"}else if (p[s]<0.001){sig="**"}else if (p[s]<0.01){sig="*"} else if (p[s]<0.05){sig="+"} else {sig=""}
 	if (sig=="+"){text(xvals[s],.8,sig,cex=pluscex)} else {text(xvals[s],.8,sig,cex=starcex)}
 
 }

## High v Low ##

t1=glmer(Outcome2 ~ 1 + (1|subjid),data=subset(boost_probe,boost_probe$PairType==3),na.action=na.omit,family=binomial)
vc1 <- vcov(t1, useScale = FALSE)
b1 <- fixef(t1)
z1 <- b1 / sqrt(diag(vc1))
p1 <- 2 * (1 - pnorm(abs(z1)))
t2=glmer(Outcome2 ~ 1 + (1|subjid),data=subset(boost_probe,boost_probe$PairType==4),na.action=na.omit,family=binomial)
 
vc2<- vcov(t2, useScale = FALSE)
b2 <- fixef(t2)
z2 <- b2 / sqrt(diag(vc2))
p2 <- 2 * (1 - pnorm(abs(z2)))
p=c(p1,p2)

sd=c(tapply(boost_probe$Outcome2, boost_probe$PairType,sd,na.rm=T)[3],tapply(boost_probe$Outcome2, boost_probe$PairType,sd,na.rm=T)[4])
se1=std.error(m[,3])
se2=std.error(m[,4])
se=c(se1,se2)

ms=tapply(boost_probe$Outcome2, boost_probe$PairType, mean,na.rm=T)
ms=c(ms[3],ms[4])

par(mar=c(4,3,4,0.5), mgp=c(1.5,0.4,0),oma=c(.5,.5,.5,.5))

xvals=barplot(ms,ylim=range(0,1),xlim=c(0,1),width=.2,space=c(1,1),ylab="Proportion of HIGH item choices at probe", main=paste("Proportion of HIGH item choices at probe \n for ISF study (N=", length(levels(boost_probe$subjid)),", 12 repetitions)", sep=""), cex.lab=labcex, cex.names=namecex,cex.axis=axiscex,cex.main=titlecex,axes=F, border=NA,col=c("dodgerblue1","firebrick2"),names.arg=c("",""))
errbar(xvals,ms,ms+se,ms-se,pch="",add=T,lwd=2,cap=.01)
lines(c(-.5,21.5),c(.5,.5),lty=2,lwd=2)
axis(2,at=c(0,.2,.4,.6,.8,1),labels=c("",.2,.4,.6,.8,""),cex.axis=axiscex,tck=-0.01)
mtext("High GO \n vs. \n Low GO", at=xvals[1],side=1,line=3.3,cex=1.5)
mtext("High NOGO \n vs. \n Low NOGO", at=xvals[2],side=1,line=3.3,cex=1.5)

for (s in 1:2){
 	if (p[s]<0.0001){sig="***"}else if (p[s]<0.001){sig="**"}else if (p[s]<0.01){sig="*"} else if (p[s]<0.05){sig="+"} else {sig=""}
 	if (sig=="+"){text(xvals[s],.9,sig,cex=pluscex)} else {text(xvals[s],.95,sig,cex=starcex)}
 
 }
 
 #Probe RT#
 ## GO v NOGO#
 
gm=mean(boost_probe$RT,na.rm=T)

for (s in levels(boost_probe$subjid)){
	
	boost_probe$RTc[boost_probe$subjid==s]=boost_probe$RT[boost_probe$subjid==s]-mean(boost_probe$RT[boost_probe$subjid==s],na.rm=T)+gm
	
}

m=tapply(boost_probe$RTc, list(boost_probe$subjid,boost_probe$Outcome2,boost_probe$PairType),mean,na.rm=T)

t1=mixed(RT ~ Outcome2 + (Outcome2|subjid), data=na.omit(subset(boost_probe,boost_probe$PairType==1)))

p1 <- t1$anova.table$p.value[2]

t2=mixed(RT ~ Outcome2 + (Outcome2|subjid), data=na.omit(subset(boost_probe,boost_probe$PairType==2)))

p2 <- t2$anova.table$p.value[2]

ms=rbind(c(tapply(boost_probe$RT, list(boost_probe$Outcome2,boost_probe$PairType),mean,na.rm=T)[1,1],tapply(boost_probe$RT, list(boost_probe$Outcome2,boost_probe$PairType),mean,na.rm=T)[1,2]),c(tapply(boost_probe$RT, list(boost_probe$Outcome2,boost_probe$PairType),mean,na.rm=T)[2,1],tapply(boost_probe$RT, list(boost_probe$Outcome2,boost_probe$PairType),mean,na.rm=T)[2,2]))

se=rbind(c(std.error(m[,1,1]),std.error(m[,1,2])),c(std.error(m[,2,1]),std.error(m[,2,2])))

xvals=barplot(ms,ylim=range(0,1.4), ylab="Reaction time (sec)",names.arg=c("High NOGO", "High GO","Low NOGO", "Low GO"), main=paste("Reaction time for GO and NOGO choice at probe \n for MVPA study (n = ",length(levels(boost_probe$subjid)),", training = 12)",sep=""), beside=T,cex.lab=1.5, cex.names=1.1,cex.axis=1.2,cex.main=1.6)
errbar(xvals,ms,ms+se,ms-se,pch="",add=T,lwd=2)

text(mean(xvals[,1]),max(ms)+max(se)+.1,paste("p =",round(p1,4)),cex=2)
text(mean(xvals[,2]),max(ms)+max(se)+.1,paste("p =",round(p2,4)),cex=2)

##WTPdelta (WTP change) on number of times chosen

boost_isf_BDM$delta=boost_isf_BDM$Bid2-boost_isf_BDM$Bid
boost_probe$choseleft=0
boost_probe$choseright=0
boost_probe$choseleft[boost_isf_probe$Response=="u"]=1
boost_probe$choseright[boost_isf_probe$Response=="i"]=1

s=levels(as.factor(boost_isf_BDM$subjid))[1]
tmp=subset(boost_probe, boost_probe$subjid==s)
choicel=data.frame(itemname=levels(tmp$ImageLeft),choicel=tapply(tmp$choseleft,tmp$ImageLeft,sum,na.rm=T))
choicer=data.frame(itemname=levels(tmp$ImageRight),choicer=tapply(tmp$choseright,tmp$ImageRight,sum,na.rm=T))
choice=merge(choicel,choicer,by="itemname")
choice$subjid=s
chose=choice
for (s in levels(as.factor(boost_isf_BDM$subjid))[2:length(levels(as.factor(boost_isf_BDM$subjid)))]){
	tmp=subset(boost_probe, boost_probe$subjid==s)
	choicel=data.frame(itemname=levels(tmp$ImageLeft),choicel=tapply(tmp$choseleft,tmp$ImageLeft,sum,na.rm=T))
	choicer=data.frame(itemname=levels(tmp$ImageRight),choicer=tapply(tmp$choseright,tmp$ImageRight,sum,na.rm=T))
	choice=merge(choicel,choicer,by="itemname")
	choice$subjid=s
	chose=rbind(chose, choice)
}
for (i in 1:length(chose$itemname)){chose$chose[i]=sum(chose$choicel[i],chose$choicer[i],na.rm=T)}
chose$chose[is.na(chose$choicel) & is.na(chose$choicer)]=NA
boost_isf_BDM$chose=NA
for (s in levels(as.factor(chose$subjid))){
for (i in levels(as.factor(chose$itemname))){
	boost_isf_BDM$chose[boost_isf_BDM$subjid==s & boost_isf_BDM$StimName==i]=chose$chose[chose$itemname==i & chose$subjid==s]
}}

