clear all
close all

analysis_path=pwd; % Analysis folder location
outpath=[analysis_path(1:end-8),'Output/']; % Output folder location

subjects=[120,122:124,126:127,129:133,135:138,140,142,144:145,147:150,153:158]; % Define here your subjects' codes.
%exclude:
% 121, 128, 134, 139, 143, 146, 151:152 - failed
% 125, 141 - had poor training
% 144, 145 - not so good training. consider removal

RT_Correct_all_HL1_Allsubs=9999*ones(50,264);
RT_Correct_all_HL2_Allsubs=9999*ones(50,264);


stops1=[];
stops2=[];



for subjInd=1:length(subjects)
    Ladder1alls=[];
    Ladder2alls=[];
    meanRT1_alls=[];
    meanRT2_alls=[];
    
    RT_Correct_all_HL1=[];
    RT_Correct_all_HL2=[];
 
    clear Ladder1 Ladder2 respInTime respTime incorrect
    
    filename=strcat(outpath,sprintf('p_%d',subjects(subjInd)));
    logs=dir(strcat(filename, '_training_run','*.txt'))
    mats=dir(strcat(filename, '_training_run','*.mat'))
    mats_train=dir(strcat(filename, '_training_run','*.mat'))
    
    %    fid=fopen(strcat(outpath,logs(1).name));
    load(strcat(outpath,mats_train(1).name));
    
    
    for i=1:runNum
        Ladder2alls=[Ladder2alls; Ladder2{i}(1:length(Ladder1{1}))];
        Ladder1alls=[Ladder1alls; Ladder1{i}(1:length(Ladder1{1}))];
        gos1(subjInd,i)=size(find(respInTime{i}==110|respInTime{i}==11),1);
        gos2(subjInd,i)=size(find(respInTime{i}==220|respInTime{i}==22),1);
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
    
    
    figure (subjects(subjInd))
    
    plot(Ladder1alls,'-')
    hold on
    plot(Ladder2alls,'r-')
    ylim([0 1000]);

end

figure

sterhigh1=std(Ladders1AllSubs)/sqrt(size(Ladders1AllSubs,1));
sterlow2=std(Ladders2AllSubs)/sqrt(size(Ladders2AllSubs,1));

boundedline(1:length(Ladder1alls),mean(Ladders1AllSubs),sterhigh1,'b','alpha')
hold on
boundedline(1:length(Ladder2alls),mean(Ladders2AllSubs),sterlow2,'r','alpha')

ylabel ('Go Signal Delay', 'fontsize',24)
xlabel ('trials','fontsize',24)
title('Boost, SSD=start at 750 msec','fontsize',10)



figure
stergos1=std(gos1)/sqrt(size(gos1,1))
stergos2=std(gos2)/sqrt(size(gos2,1))

boundedline(1:size(gos1,2),mean(gos1),stergos1,'b','alpha')
hold on
boundedline(1:size(gos2,2),mean(gos2),stergos2,'r','alpha')
xlabel ('runs','fontsize',24)
ylabel ('Number of correct Go ', 'fontsize',24)
title('Average of Gos', 'fontsize',10)



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
