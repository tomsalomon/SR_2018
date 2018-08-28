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


%subjects= [58 59 60 65 66 67 68 69 70 71 72 75 77 78 80 81 83 84 85 87 88 89 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 116 117 118 120 ] ; % many zeros 61, many 1000 62 63. 79 - didn't stop. 82 is 40.
%********sent to corey subjects= [58 59 60 65 66 67 68 69 70 71 72 75 77 78 80 81 83 84 85 87 88 89 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 116 117 118 120 ] ; % many zeros 61, many 1000 62 63. 79 - didn't stop. 82 is 40.
%67,85,100 - many incorrect - also touched SSD 0.

%subjects= [58 59 60 65 66 67 68 69 70 71 72 75 77 78 80 81 83 84 85 87 88 89 91 92 93 94 95 96] ; % many zeros 61, many 1000 62 63. 79 - didn't stop. 82 is 40.

%exclude 74, 76 90 - negative SSRT

RT_Correct_all_HL1_Allsubs_16=9999*ones(length(subjects),132);
RT_Correct_all_HL2_Allsubs_16=9999*ones(length(subjects),132);

RT_inCorrect_all_HL1_Allsubs_16=9999*ones(length(subjects),132);
RT_inCorrect_all_HL2_Allsubs_16=9999*ones(length(subjects),132);


RT_Correct_all_HL1_Allsubs_712=9999*ones(length(subjects),132);
RT_Correct_all_HL2_Allsubs_712=9999*ones(length(subjects),132);

RT_inCorrect_all_HL1_Allsubs_712=9999*ones(length(subjects),132);
RT_inCorrect_all_HL2_Allsubs_712=9999*ones(length(subjects),132);


stops1=[];
stops2=[];



for subjInd=1:length(subjects)
    outpath='~/Dropbox/Documents/Trained_Inhibition/Boost/Output/';
    Ladder1alls=[];
    Ladder2alls=[];
    meanRT1_alls=[];
    meanRT2_alls=[];
    
    
    
    RT_Correct_all_HL1_16=[];
    RT_Correct_all_HL2_16=[];
    
    RT_inCorrect_all_HL1_16=[];
    RT_inCorrect_all_HL2_16=[];
    ommits_H_16=[];
    ommits_L_16=[];
    
    corrects_H_16=[];
    corrects_L_16=[];
    
    incorrects_H_16=[];
    incorrects_L_16=[];
    
    
    
    RT_Correct_all_HL1_712=[];
    RT_Correct_all_HL2_712=[];
    
    RT_inCorrect_all_HL1_712=[];
    RT_inCorrect_all_HL2_712=[];
    ommits_H_712=[];
    ommits_L_712=[];
    
    corrects_H_712=[];
    corrects_L_712=[];
    
    incorrects_H_712=[];
    incorrects_L_712=[];
    
    
    
    
    
    clear Ladder1 Ladder2 respInTime respTime incorrect keyPressed shuff_oneSeveral shuff_stop order Several_side
    
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
    
    
    for i=1:12
        
     
                
            case 2
                corrects_H_16=[corrects_H_16 ; length(find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==12))+ length(find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==12))];
                RT_Correct_all_HL1_16=[RT_Correct_all_HL1_16 ; respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==12) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==12)]))];
                
                corrects_L_16=[corrects_L_16 ; length(find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==24))+ length(find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==24))];
                RT_Correct_all_HL2_16=[RT_Correct_all_HL2_16 ; respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==24) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==24)]))];
                
                
                incorrects_H_16=[incorrects_H_16 ; length(find(keyPressed{i}==109 & shuff_oneSeveral{i}==1 & shuff_stop{i}==12))+ length(find(keyPressed{i}==110 & shuff_oneSeveral{i}==0 & shuff_stop{i}==12))];
                RT_inCorrect_all_HL1_16=[RT_inCorrect_all_HL1_16 ; respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==1 & shuff_stop{i}==12) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==0 & shuff_stop{i}==12)]))];
                
                incorrects_L_16=[incorrects_L_16 ; length(find(keyPressed{i}==109 & shuff_oneSeveral{i}==1 & shuff_stop{i}==24))+ length(find(keyPressed{i}==110 & shuff_oneSeveral{i}==0 & shuff_stop{i}==24))];
                RT_inCorrect_all_HL2_16=[RT_inCorrect_all_HL2_16 ; respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==1 & shuff_stop{i}==24) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==0 & shuff_stop{i}==24)]))];
                
                
                mean_RT_HL1_16(subjInd,i)=mean(respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==12) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==12)])));
                mean_RT_HL2_16(subjInd,i)=mean(respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==24) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==24)])));
                
                
                median_RT_HL1_16(subjInd,i)=median(respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==12) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==12)])));
                median_RT_HL2_16(subjInd,i)=median(respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==24) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==24)])));
                
                
                
        end
        
        
        ommits_H_16=[ommits_H_16 ; length(find(respInTime{i}==120))];
        ommits_L_16=[ommits_L_16 ; length(find(respInTime{i}==240))];
        
        
        
        
    end
    
    
    for i=10:12
        
        switch Several_side
            case 1
                %    length(find(keyPressed{runnum}==109 & shuff_oneSeveral{runnum}==1 & mod(shuff_stop{runnum},11)~=0))
                corrects_H_712=[corrects_H_712 ; length(find(keyPressed{i}==109 & shuff_oneSeveral{i}==1 & shuff_stop{i}==12))+ length(find(keyPressed{i}==110 & shuff_oneSeveral{i}==0 & shuff_stop{i}==12))];
                RT_Correct_all_HL1_712=[RT_Correct_all_HL1_712 ; respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==1 & shuff_stop{i}==12) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==0 & shuff_stop{i}==12)]))];
                
                corrects_L_712=[corrects_L_712 ; length(find(keyPressed{i}==109 & shuff_oneSeveral{i}==1 & shuff_stop{i}==24))+ length(find(keyPressed{i}==110 & shuff_oneSeveral{i}==0 & shuff_stop{i}==24))];
                RT_Correct_all_HL2_712=[RT_Correct_all_HL2_712 ; respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==1 & shuff_stop{i}==24) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==0 & shuff_stop{i}==24)]))];
                
                
                incorrects_H_712=[incorrects_H_712 ; length(find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==12))+ length(find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==12))];
                RT_inCorrect_all_HL1_712=[RT_inCorrect_all_HL1_712 ; respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==12) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==12)]))];
                
                incorrects_L_712=[incorrects_L_712 ; length(find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==24))+ length(find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==24))];
                RT_inCorrect_all_HL2_712=[RT_inCorrect_all_HL2_712 ; respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==24) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==24)]))];
                
                mean_RT_HL1_712(subjInd,i)=mean(respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==1 & shuff_stop{i}==12) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==0 & shuff_stop{i}==12)])));
                mean_RT_HL2_712(subjInd,i)=mean(respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==1 & shuff_stop{i}==24) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==0 & shuff_stop{i}==24)])));
                
                median_RT_HL1_712(subjInd,i)=median(respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==1 & shuff_stop{i}==12) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==0 & shuff_stop{i}==12)])));
                median_RT_HL2_712(subjInd,i)=median(respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==1 & shuff_stop{i}==24) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==0 & shuff_stop{i}==24)])));
                
                
                
                
            case 2
                corrects_H_712=[corrects_H_712 ; length(find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==12))+ length(find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==12))];
                RT_Correct_all_HL1_712=[RT_Correct_all_HL1_712 ; respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==12) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==12)]))];
                
                corrects_L_712=[corrects_L_712 ; length(find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==24))+ length(find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==24))];
                RT_Correct_all_HL2_712=[RT_Correct_all_HL2_712 ; respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==24) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==24)]))];
                
                
                incorrects_H_712=[incorrects_H_712 ; length(find(keyPressed{i}==109 & shuff_oneSeveral{i}==1 & shuff_stop{i}==12))+ length(find(keyPressed{i}==110 & shuff_oneSeveral{i}==0 & shuff_stop{i}==12))];
                RT_inCorrect_all_HL1_712=[RT_inCorrect_all_HL1_712 ; respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==1 & shuff_stop{i}==12) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==0 & shuff_stop{i}==12)]))];
                
                incorrects_L_712=[incorrects_L_712 ; length(find(keyPressed{i}==109 & shuff_oneSeveral{i}==1 & shuff_stop{i}==24))+ length(find(keyPressed{i}==110 & shuff_oneSeveral{i}==0 & shuff_stop{i}==24))];
                RT_inCorrect_all_HL2_712=[RT_inCorrect_all_HL2_712 ; respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==1 & shuff_stop{i}==24) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==0 & shuff_stop{i}==24)]))];
                
                
                mean_RT_HL1_712(subjInd,i)=mean(respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==12) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==12)])));
                mean_RT_HL2_712(subjInd,i)=mean(respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==24) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==24)])));
                
                
                median_RT_HL1_712(subjInd,i)=median(respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==12) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==12)])));
                median_RT_HL2_712(subjInd,i)=median(respTime{i}(sort([find(keyPressed{i}==109 & shuff_oneSeveral{i}==0 & shuff_stop{i}==24) ; find(keyPressed{i}==110 & shuff_oneSeveral{i}==1 & shuff_stop{i}==24)])));
                
                
                
        end
        
        
        ommits_H_712=[ommits_H_712 ; length(find(respInTime{i}==120))];
        ommits_L_712=[ommits_L_712 ; length(find(respInTime{i}==240))];
        
        
        
        
        
        
        
    end
    
    
    for i=1:12
        
        Ladder2alls=[Ladder2alls; Ladder2{i}(1:8)];
        Ladder1alls=[Ladder1alls; Ladder1{i}(1:8)];
        stops1(subjInd,i)=size(find(respInTime{i}==1),1);
        stops2(subjInd,i)=size(find(respInTime{i}==2),1);
        
        median_Ladders_HL1(subjInd,i)=median(Ladder1{i}(1:8));
        median_Ladders_HL2(subjInd,i)=median(Ladder2{i}(1:8));
       
        
    end
    
% median_RT_HL1=[median_RT_HL1_16 median_RT_HL1_712(:,7:12)];
% median_RT_HL2=[median_RT_HL2_16 median_RT_HL2_712(:,7:12)];

    
    
%     median_SSRT_1=median_RT_HL1*1000-median_Ladders_HL1;
%     median_SSRT_2=median_RT_HL2*1000-median_Ladders_HL2;
%     
%     
    order_several(subjInd,1)=Several_side;
    order_several(subjInd,2)=order;
    
    
    ommitAllSubs_H_16(subjInd,:)=ommits_H_16';
    ommitAllSubs_L_16(subjInd,:)=ommits_L_16';
    
    correctsAllSubs_H_16(subjInd,:)=corrects_H_16';
    correctsAllSubs_L_16(subjInd,:)=corrects_L_16';
    
    incorrectsAllSubs_H_16(subjInd,:)=incorrects_H_16';
    incorrectsAllSubs_L_16(subjInd,:)=incorrects_L_16';
    
    
    RT_Correct_all_HL1_Allsubs_16(subjInd,1:length(RT_Correct_all_HL1_16))=RT_Correct_all_HL1_16';
    RT_Correct_all_HL2_Allsubs_16(subjInd,1:length(RT_Correct_all_HL2_16))=RT_Correct_all_HL2_16';
    
    RT_inCorrect_all_HL1_Allsubs_16(subjInd,1:length(RT_inCorrect_all_HL1_16))=RT_inCorrect_all_HL1_16';
    RT_inCorrect_all_HL2_Allsubs_16(subjInd,1:length(RT_inCorrect_all_HL2_16))=RT_inCorrect_all_HL2_16';
    
    
    ommitAllSubs_H_712(subjInd,:)=ommits_H_712';
    ommitAllSubs_L_712(subjInd,:)=ommits_L_712';
    
    correctsAllSubs_H_712(subjInd,:)=corrects_H_712';
    correctsAllSubs_L_712(subjInd,:)=corrects_L_712';
    
    incorrectsAllSubs_H_712(subjInd,:)=incorrects_H_712';
    incorrectsAllSubs_L_712(subjInd,:)=incorrects_L_712';
    
    
    RT_Correct_all_HL1_Allsubs_712(subjInd,1:length(RT_Correct_all_HL1_712))=RT_Correct_all_HL1_712';
    RT_Correct_all_HL2_Allsubs_712(subjInd,1:length(RT_Correct_all_HL2_712))=RT_Correct_all_HL2_712';
    
    RT_inCorrect_all_HL1_Allsubs_712(subjInd,1:length(RT_inCorrect_all_HL1_712))=RT_inCorrect_all_HL1_712';
    RT_inCorrect_all_HL2_Allsubs_712(subjInd,1:length(RT_inCorrect_all_HL2_712))=RT_inCorrect_all_HL2_712';
    
    
    Ladders1AllSubs(subjInd,:)=Ladder1alls';
    Ladders2AllSubs(subjInd,:)=Ladder2alls';
    
    
    %figure (subjects(subjInd))
    
    plot(Ladder1alls,'-')
    hold on
    plot(Ladder2alls,'r-')
%    GRTquant=quantile(corr_rt,mean(100-PctInhib)/100); % get the Quantile of the correct RT based on the PctInhib  
%     quantiles_correct_H_16(subjInd,1)=quantile(RT_Correct_all_HL1_Allsubs_16(subjInd,1:length(find(RT_Correct_all_HL1_Allsubs_16(subjInd,:)<9999))),(100-PctInhib_1)/100);
%     quantiles_correct_H_16(subjInd,2)=quantile(RT_Correct_all_HL1_Allsubs_16(subjInd,1:length(find(RT_Correct_all_HL1_Allsubs_16(subjInd,:)<9999))),0.3);
%     quantiles_correct_H_16(subjInd,3)=quantile(RT_Correct_all_HL1_Allsubs_16(subjInd,1:length(find(RT_Correct_all_HL1_Allsubs_16(subjInd,:)<9999))),0.5);
%     quantiles_correct_H_16(subjInd,4)=quantile(RT_Correct_all_HL1_Allsubs_16(subjInd,1:length(find(RT_Correct_all_HL1_Allsubs_16(subjInd,:)<9999))),0.7);
%     quantiles_correct_H_16(subjInd,5)=quantile(RT_Correct_all_HL1_Allsubs_16(subjInd,1:length(find(RT_Correct_all_HL1_Allsubs_16(subjInd,:)<9999))),0.9);
%     
%     
%     quantiles_correct_L_16(subjInd,1)=quantile(RT_Correct_all_HL2_Allsubs_16(subjInd,1:length(find(RT_Correct_all_HL2_Allsubs_16(subjInd,:)<9999))),0.1);
%     quantiles_correct_L_16(subjInd,2)=quantile(RT_Correct_all_HL2_Allsubs_16(subjInd,1:length(find(RT_Correct_all_HL2_Allsubs_16(subjInd,:)<9999))),0.3);
%     quantiles_correct_L_16(subjInd,3)=quantile(RT_Correct_all_HL2_Allsubs_16(subjInd,1:length(find(RT_Correct_all_HL2_Allsubs_16(subjInd,:)<9999))),0.5);
%     quantiles_correct_L_16(subjInd,4)=quantile(RT_Correct_all_HL2_Allsubs_16(subjInd,1:length(find(RT_Correct_all_HL2_Allsubs_16(subjInd,:)<9999))),0.7);
%     quantiles_correct_L_16(subjInd,5)=quantile(RT_Correct_all_HL2_Allsubs_16(subjInd,1:length(find(RT_Correct_all_HL2_Allsubs_16(subjInd,:)<9999))),0.9);
%     
%     
%     quantiles_incorrect_H_16(subjInd,1)=quantile(RT_inCorrect_all_HL1_Allsubs_16(subjInd,1:length(find(RT_inCorrect_all_HL1_Allsubs_16(subjInd,:)<9999))),0.1);
%     quantiles_incorrect_H_16(subjInd,2)=quantile(RT_inCorrect_all_HL1_Allsubs_16(subjInd,1:length(find(RT_inCorrect_all_HL1_Allsubs_16(subjInd,:)<9999))),0.3);
%     quantiles_incorrect_H_16(subjInd,3)=quantile(RT_inCorrect_all_HL1_Allsubs_16(subjInd,1:length(find(RT_inCorrect_all_HL1_Allsubs_16(subjInd,:)<9999))),0.5);
%     quantiles_incorrect_H_16(subjInd,4)=quantile(RT_inCorrect_all_HL1_Allsubs_16(subjInd,1:length(find(RT_inCorrect_all_HL1_Allsubs_16(subjInd,:)<9999))),0.7);
%     quantiles_incorrect_H_16(subjInd,5)=quantile(RT_inCorrect_all_HL1_Allsubs_16(subjInd,1:length(find(RT_inCorrect_all_HL1_Allsubs_16(subjInd,:)<9999))),0.9);
%     
%     
%     quantiles_incorrect_L_16(subjInd,1)=quantile(RT_inCorrect_all_HL2_Allsubs_16(subjInd,1:length(find(RT_inCorrect_all_HL2_Allsubs_16(subjInd,:)<9999))),0.1);
%     quantiles_incorrect_L_16(subjInd,2)=quantile(RT_inCorrect_all_HL2_Allsubs_16(subjInd,1:length(find(RT_inCorrect_all_HL2_Allsubs_16(subjInd,:)<9999))),0.3);
%     quantiles_incorrect_L_16(subjInd,3)=quantile(RT_inCorrect_all_HL2_Allsubs_16(subjInd,1:length(find(RT_inCorrect_all_HL2_Allsubs_16(subjInd,:)<9999))),0.5);
%     quantiles_incorrect_L_16(subjInd,4)=quantile(RT_inCorrect_all_HL2_Allsubs_16(subjInd,1:length(find(RT_inCorrect_all_HL2_Allsubs_16(subjInd,:)<9999))),0.7);
%     quantiles_incorrect_L_16(subjInd,5)=quantile(RT_inCorrect_all_HL2_Allsubs_16(subjInd,1:length(find(RT_inCorrect_all_HL2_Allsubs_16(subjInd,:)<9999))),0.9);
%     
%     
% %     
%     quantiles_correct_H_712(subjInd,1)=quantile(RT_Correct_all_HL1_Allsubs_712(subjInd,1:length(find(RT_Correct_all_HL1_Allsubs_712(subjInd,:)<9999))),0.1);
%     quantiles_correct_H_712(subjInd,2)=quantile(RT_Correct_all_HL1_Allsubs_712(subjInd,1:length(find(RT_Correct_all_HL1_Allsubs_712(subjInd,:)<9999))),0.3);
%     quantiles_correct_H_712(subjInd,3)=quantile(RT_Correct_all_HL1_Allsubs_712(subjInd,1:length(find(RT_Correct_all_HL1_Allsubs_712(subjInd,:)<9999))),0.5);
%     quantiles_correct_H_712(subjInd,4)=quantile(RT_Correct_all_HL1_Allsubs_712(subjInd,1:length(find(RT_Correct_all_HL1_Allsubs_712(subjInd,:)<9999))),0.7);
%     quantiles_correct_H_712(subjInd,5)=quantile(RT_Correct_all_HL1_Allsubs_712(subjInd,1:length(find(RT_Correct_all_HL1_Allsubs_712(subjInd,:)<9999))),0.9);
%     
%     
%     quantiles_correct_L_712(subjInd,1)=quantile(RT_Correct_all_HL2_Allsubs_712(subjInd,1:length(find(RT_Correct_all_HL2_Allsubs_712(subjInd,:)<9999))),0.1);
%     quantiles_correct_L_712(subjInd,2)=quantile(RT_Correct_all_HL2_Allsubs_712(subjInd,1:length(find(RT_Correct_all_HL2_Allsubs_712(subjInd,:)<9999))),0.3);
%     quantiles_correct_L_712(subjInd,3)=quantile(RT_Correct_all_HL2_Allsubs_712(subjInd,1:length(find(RT_Correct_all_HL2_Allsubs_712(subjInd,:)<9999))),0.5);
%     quantiles_correct_L_712(subjInd,4)=quantile(RT_Correct_all_HL2_Allsubs_712(subjInd,1:length(find(RT_Correct_all_HL2_Allsubs_712(subjInd,:)<9999))),0.7);
%     quantiles_correct_L_712(subjInd,5)=quantile(RT_Correct_all_HL2_Allsubs_712(subjInd,1:length(find(RT_Correct_all_HL2_Allsubs_712(subjInd,:)<9999))),0.9);
%     
% %     
% %     quantiles_incorrect_H_712(subjInd,1)=quantile(RT_inCorrect_all_HL1_Allsubs_712(subjInd,1:length(find(RT_inCorrect_all_HL1_Allsubs_712(subjInd,:)<9999))),0.1);
%     quantiles_incorrect_H_712(subjInd,2)=quantile(RT_inCorrect_all_HL1_Allsubs_712(subjInd,1:length(find(RT_inCorrect_all_HL1_Allsubs_712(subjInd,:)<9999))),0.3);
%     quantiles_incorrect_H_712(subjInd,3)=quantile(RT_inCorrect_all_HL1_Allsubs_712(subjInd,1:length(find(RT_inCorrect_all_HL1_Allsubs_712(subjInd,:)<9999))),0.5);
%     quantiles_incorrect_H_712(subjInd,4)=quantile(RT_inCorrect_all_HL1_Allsubs_712(subjInd,1:length(find(RT_inCorrect_all_HL1_Allsubs_712(subjInd,:)<9999))),0.7);
%     quantiles_incorrect_H_712(subjInd,5)=quantile(RT_inCorrect_all_HL1_Allsubs_712(subjInd,1:length(find(RT_inCorrect_all_HL1_Allsubs_712(subjInd,:)<9999))),0.9);
%     
%     
%     quantiles_incorrect_L_712(subjInd,1)=quantile(RT_inCorrect_all_HL2_Allsubs_712(subjInd,1:length(find(RT_inCorrect_all_HL2_Allsubs_712(subjInd,:)<9999))),0.1);
%     quantiles_incorrect_L_712(subjInd,2)=quantile(RT_inCorrect_all_HL2_Allsubs_712(subjInd,1:length(find(RT_inCorrect_all_HL2_Allsubs_712(subjInd,:)<9999))),0.3);
%     quantiles_incorrect_L_712(subjInd,3)=quantile(RT_inCorrect_all_HL2_Allsubs_712(subjInd,1:length(find(RT_inCorrect_all_HL2_Allsubs_712(subjInd,:)<9999))),0.5);
%     quantiles_incorrect_L_712(subjInd,4)=quantile(RT_inCorrect_all_HL2_Allsubs_712(subjInd,1:length(find(RT_inCorrect_all_HL2_Allsubs_712(subjInd,:)<9999))),0.7);
%     quantiles_incorrect_L_712(subjInd,5)=quantile(RT_inCorrect_all_HL2_Allsubs_712(subjInd,1:length(find(RT_inCorrect_all_HL2_Allsubs_712(subjInd,:)<9999))),0.9);
%     
    
end




% ommit_ratio_H_16=sum(ommitAllSubs_H_16,2)/132;
% correct_ratio_H_16=sum(correctsAllSubs_H_16,2)/132;
% incorrect_ratio_H_16=sum(incorrectsAllSubs_H_16,2)/132;
% 
% ommit_ratio_H_712=sum(ommitAllSubs_H_712,2)/132;
% correct_ratio_H_712=sum(correctsAllSubs_H_712,2)/132;
% incorrect_ratio_H_712=sum(incorrectsAllSubs_H_712,2)/132;
% 
% 
% 
% ommit_ratio_L_16=sum(ommitAllSubs_L_16,2)/132;
% correct_ratio_L_16=sum(correctsAllSubs_L_16,2)/132;
% incorrect_ratio_L_16=sum(incorrectsAllSubs_L_16,2)/132;
% 
% ommit_ratio_L_712=sum(ommitAllSubs_L_712,2)/132;
% correct_ratio_L_712=sum(correctsAllSubs_L_712,2)/132;
% incorrect_ratio_L_712=sum(incorrectsAllSubs_L_712,2)/132;
% 
% 
% CW_DDM_50subs_H_16(:,1)=correct_ratio_H_16;
% CW_DDM_50subs_H_16(:,2)=sum(correctsAllSubs_H_16,2);
% CW_DDM_50subs_H_16(:,3:7)=quantiles_correct_H_16(:,1:5);
% CW_DDM_50subs_H_16(:,8)=incorrect_ratio_H_16;
% CW_DDM_50subs_H_16(:,9)=sum(incorrectsAllSubs_H_16,2);
% CW_DDM_50subs_H_16(:,10:14)=quantiles_incorrect_H_16(:,1:5);
% CW_DDM_50subs_H_16(:,15)=ommit_ratio_H_16;
% 
% CW_DDM_50subs_H_712(:,1)=correct_ratio_H_712;
% CW_DDM_50subs_H_712(:,2)=sum(correctsAllSubs_H_712,2);
% CW_DDM_50subs_H_712(:,3:7)=quantiles_correct_H_712(:,1:5);
% CW_DDM_50subs_H_712(:,8)=incorrect_ratio_H_712;
% CW_DDM_50subs_H_712(:,9)=sum(incorrectsAllSubs_H_712,2);
% CW_DDM_50subs_H_712(:,10:14)=quantiles_incorrect_H_712(:,1:5);
% CW_DDM_50subs_H_712(:,15)=ommit_ratio_H_712;
% 
% 
% CW_DDM_50subs_L_16(:,1)=correct_ratio_L_16;
% CW_DDM_50subs_L_16(:,2)=sum(correctsAllSubs_L_16,2);
% CW_DDM_50subs_L_16(:,3:7)=quantiles_correct_L_16(:,1:5);
% CW_DDM_50subs_L_16(:,8)=incorrect_ratio_L_16;
% CW_DDM_50subs_L_16(:,9)=sum(incorrectsAllSubs_L_16,2);
% CW_DDM_50subs_L_16(:,10:14)=quantiles_incorrect_L_16(:,1:5);
% CW_DDM_50subs_L_16(:,15)=ommit_ratio_L_16;
% 
% CW_DDM_50subs_L_712(:,1)=correct_ratio_L_712;
% CW_DDM_50subs_L_712(:,2)=sum(correctsAllSubs_L_712,2);
% CW_DDM_50subs_L_712(:,3:7)=quantiles_correct_L_712(:,1:5);
% CW_DDM_50subs_L_712(:,8)=incorrect_ratio_L_712;
% CW_DDM_50subs_L_712(:,9)=sum(incorrectsAllSubs_L_712,2);
% CW_DDM_50subs_L_712(:,10:14)=quantiles_incorrect_L_712(:,1:5);
% CW_DDM_50subs_L_712(:,15)=ommit_ratio_L_712;


% fid=fopen(('CW_DDM_50subs_H_16.txt'), 'w');    
% 
% for i=1:length(CW_DDM_50subs_H_16)
%              %write out the full list with the bids and also which item will be a stop item
%     fprintf(fid, '%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t\n', CW_DDM_50subs_H_16(i,1:15)); % write item names, the stop/go high/low oneSeveral and item indeex
% end
% fprintf(fid, '\n');
% fclose(fid);
% 
% 
% 
% fid=fopen(('CW_DDM_50subs_H_712.txt'), 'w');    
% 
% for i=1:length(CW_DDM_50subs_H_712)
%              %write out the full list with the bids and also which item will be a stop item
%     fprintf(fid, '%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t\n', CW_DDM_50subs_H_712(i,1:15)); % write item names, the stop/go high/low oneSeveral and item indeex
% end
% fprintf(fid, '\n');
% fclose(fid);
% 
% 
% 
% fid=fopen(('CW_DDM_50subs_L_16.txt'), 'w');    
% 
% for i=1:length(CW_DDM_50subs_L_16)
%              %write out the full list with the bids and also which item will be a stop item
%     fprintf(fid, '%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t\n', CW_DDM_50subs_L_16(i,1:15)); % write item names, the stop/go high/low oneSeveral and item indeex
% end
% fprintf(fid, '\n');
% fclose(fid);
% 
% 
% 
% fid=fopen(('CW_DDM_50subs_L_712.txt'), 'w');    
% 
% for i=1:length(CW_DDM_50subs_L_712)
%              %write out the full list with the bids and also which item will be a stop item
%     fprintf(fid, '%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t\n', CW_DDM_50subs_L_712(i,1:15)); % write item names, the stop/go high/low oneSeveral and item indeex
% end
% fprintf(fid, '\n');
% fclose(fid);




median_Ladders1all=median(Ladders1AllSubs,2)
median_Ladders2all=median(Ladders2AllSubs,2)
RT_Correct_all_HL1=[RT_Correct_all_HL1_Allsubs_16 RT_Correct_all_HL1_Allsubs_712];
RT_Correct_all_HL2=[RT_Correct_all_HL2_Allsubs_16 RT_Correct_all_HL2_Allsubs_712];
for i=1:subjInd
median_RT_correcct_all_HL1(i,1)=median(RT_Correct_all_HL1(i,find(RT_Correct_all_HL1(i,:)<9999)))
end

for i=1:subjInd
median_RT_correcct_all_HL2(i,1)=median(RT_Correct_all_HL2(i,find(RT_Correct_all_HL2(i,:)<9999)))
end


SSRT_1_all_new=median_RT_correcct_all_HL1*1000-median_Ladders1all
SSRT_2_all_new=median_RT_correcct_all_HL2*1000-median_Ladders2all


median_Ladders1all_16=median(Ladders1AllSubs(:,1:48),2);
median_Ladders2all_16=median(Ladders2AllSubs(:,1:48),2);

median_Ladders1all_712=median(Ladders1AllSubs(:,49:96),2);
median_Ladders2all_712=median(Ladders2AllSubs(:,49:96),2);


for i=1:subjInd
median_RT_correcct_all_HL1_16(i,1)=median(RT_Correct_all_HL1_Allsubs_16(i,find(RT_Correct_all_HL1_Allsubs_16(i,:)<9999)))
end

for i=1:subjInd
median_RT_correcct_all_HL2_16(i,1)=median(RT_Correct_all_HL2_Allsubs_16(i,find(RT_Correct_all_HL2_Allsubs_16(i,:)<9999)))
end


for i=1:subjInd
median_RT_correcct_all_HL1_712(i,1)=median(RT_Correct_all_HL1_Allsubs_712(i,find(RT_Correct_all_HL1_Allsubs_712(i,:)<9999)))
end

for i=1:subjInd
median_RT_correcct_all_HL2_712(i,1)=median(RT_Correct_all_HL2_Allsubs_712(i,find(RT_Correct_all_HL2_Allsubs_712(i,:)<9999)))
end


SSRT_1_all_new_16=median_RT_correcct_all_HL1_16*1000-median_Ladders1all_16
SSRT_2_all_new_16=median_RT_correcct_all_HL2_16*1000-median_Ladders2all_16


SSRT_1_all_new_712=median_RT_correcct_all_HL1_712*1000-median_Ladders1all_712
SSRT_2_all_new_712=median_RT_correcct_all_HL2_712*1000-median_Ladders2all_712



%

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
AB_plots_media_RT_HL_Ladders_HL=[subjects' median_RT_correcct_all_HL1*1000 median_RT_correcct_all_HL2*1000 median_Ladders1all median_Ladders2all order_several(:,1) order_several(:,2)]

AB_plots_media_RT_HL_Ladders_HL=[subjects' median_RT_correcct_all_HL1_16*1000 median_RT_correcct_all_HL1_712*1000 median_RT_correcct_all_HL2_16*1000 median_RT_correcct_all_HL2_712*1000 median_Ladders1all_16 median_Ladders1all_712 median_Ladders2all_16 median_Ladders2all_712 order_several(:,1) order_several(:,2)]

