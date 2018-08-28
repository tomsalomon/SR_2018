clear all
close all

okscan=[0 1 2];
test_comp=input('Are you scanning? 2 Toms_iMac, 1 MRI, 0 if testooom: ');
while isempty(test_comp) || sum(okscan==test_comp)~=1
    disp('ERROR: input must be 0,1 or 2. Please try again.');
    test_comp=input('Are you scanning? 2 Toms_iMac, 1 MRI, 0 if testooom: ');
end



if test_comp==0
    outpath='~/Documents/Boost/Output/';
elseif test_comp==2
    outpath='~/Dropbox/Documents/Trained_Inhibition/Boost/Output/';
end




subjects= [132 133 134 135] ; % % messed up probe until 136 

%subjects= [58 59 60 65 66 67 68 69 70 71 72 75 77 78 80 81 83 84 85 87 88 89 91 92 93 94 95 96] ; % many zeros 61, many 1000 62 63. 79 - didn't stop. 82 is 40. 

%exclude 74, 76 90 - negative SSRT

RT_Correct_all_HL1_Allsubs=9999*ones(50,264);
RT_Correct_all_HL2_Allsubs=9999*ones(50,264);


stops1=[];
stops2=[];



for subjInd=1:length(subjects)
outpath='~/Dropbox/Documents/Trained_Inhibition/Boost/Output/';
    Ladder1alls=[];
Ladder2alls=[];
meanRT1_alls=[];
meanRT2_alls=[];



RT_Correct_all_HL1=[];
RT_Correct_all_HL2=[];

    
    
   clear Ladder1 Ladder2 respInTime respTime incorrect 
  
   if subjects(subjInd)<100
    filename=strcat(outpath,sprintf('BM2_0%d',subjects(subjInd)));
   else
       filename=strcat(outpath,sprintf('BM2_%d',subjects(subjInd)));
   end    
    
    logs=dir(strcat(filename, '_boostprobe','*.txt'))
    mats=dir(strcat(filename, '_boostprobe','*.mat'))
    mats_train=dir(strcat(filename, '_boosting','*.mat'))
   
%    fid=fopen(strcat(outpath,logs(1).name));
    load(strcat(outpath,mats_train(1).name));
    
    
for i=1:runnum
Ladder2alls=[Ladder2alls; Ladder2{i}];
Ladder1alls=[Ladder1alls; Ladder1{i}];
stops1(subjInd,i)=size(find(respInTime{i}==1),1);
stops2(subjInd,i)=size(find(respInTime{i}==2),1);
corrects(subjInd,i)=correct{i};
RT_Correct_all_HL1=[RT_Correct_all_HL1 ; respTime{i}(find(respInTime{i}==12))]
RT_Correct_all_HL2=[RT_Correct_all_HL2 ; respTime{i}(find(respInTime{i}==24))]
mean_RT_HL1(subjInd,i)=mean(respTime{i}(find(respInTime{i}==12)));
mean_RT_HL2(subjInd,i)=mean(respTime{i}(find(respInTime{i}==24)));
median_RT_HL1(subjInd,i)=median(respTime{i}(find(respInTime{i}==12)));
median_RT_HL2(subjInd,i)=median(respTime{i}(find(respInTime{i}==24)));
median_Ladders_HL1(subjInd,i)=median(Ladder1{i});
median_Ladders_HL2(subjInd,i)=median(Ladder2{i});
length_Ladders_HL1(subjInd,i)=length(Ladder1{i});
length_Ladders_HL2(subjInd,i)=length(Ladder2{i});


end

median_SSRT_1=median_RT_HL1*1000-median_Ladders_HL1;
median_SSRT_2=median_RT_HL2*1000-median_Ladders_HL2;


Ladders1AllSubs(subjInd,:)=Ladder1alls';
Ladders2AllSubs(subjInd,:)=Ladder2alls';

RT_Correct_all_HL1_Allsubs(subjInd,1:length(RT_Correct_all_HL1))=RT_Correct_all_HL1';
RT_Correct_all_HL2_Allsubs(subjInd,1:length(RT_Correct_all_HL2))=RT_Correct_all_HL2';


%figure (subjects(subjInd))

plot(Ladder1alls,'-')
hold on
plot(Ladder2alls,'r-')
end


% for shuffInd=1:50
% 
% [shuffled_median_SSRT_1,indShuff1]=Shuffle(median_SSRT_1);
% shuffled_median_SSRT_2=median_SSRT_2(indShuff1);
% 
% 
% 'comparison of mean median SSRT blocks 1:6';
% [h,p1]=ttest(mean(shuffled_median_SSRT_1(1:5,1:6)),mean(shuffled_median_SSRT_2(1:5,1:6)));
% 
% permshuffres_1_6(shuffInd,1)=p1;
% 
% 'comparison of mean median SSRT blocks 7:12';
% [h,p2]=ttest(mean(shuffled_median_SSRT_1(1:5,7:12)),mean(shuffled_median_SSRT_2(1:5,7:12)));
% 
% permshuffres_7_12(shuffInd,1)=p2;
% end
% 
% [permshuffres_1_6 permshuffres_7_12]
% 
