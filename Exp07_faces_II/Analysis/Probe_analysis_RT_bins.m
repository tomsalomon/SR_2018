
% ~~~ Script for analyzing probe results, modified for face experiment ~~~
% ~~~~~~~~~~~~~~~ Tom Salomon, February 2015  ~~~~~~~~~~~~~~
%
% In order to run the script, you must locate and run the script from within
% "Analysis" folder. The script uses external function, called
% "Probe_recode" which join all probe output file into one matrix. Please
% make sure that function is also present in the analysis folder.
%
% Note: this script and "Probe_recode" function were written specifically
% for face stimuli in a specific numeric name format. For other stimuli, you need
% to modify the Probe_recode function first.
%
% Enjoy!

clear;
close all;

% set the names of the samples to include, as appearing in their dir name
exp_name={'Boost_IAPS_Negative_I';'Boost_IAPS_Negative_II';'Boost_IAPS_Positive_I';'Boost_IAPS_Positive_II';'Boost_aversive_cue';'Boost_faces_new';'Boost_familiar_faces';'Boost_fractals_I';'Boost_fractals_II';'Boost_visual_cue'};
num_of_exp=length(exp_name);
current_dir=pwd;

% Plot response as function of binned RT
figure ('Name','response as function of binned RT','Units','normalized','outerposition',[0 0 1 1]);
requested_PairType=[1,2]; % 1-for HV only, 2 - LV only, [1,2] - HV and LV

for exp_num=1:length(exp_name)
    cd(['./../../',exp_name{exp_num},'/Analysis'])%exclude:
    load('subjects');
    
    all_subjs_data=cell(1,length(subjects));
    probe_results=zeros(length(subjects),10);
    probe_results(:,1)=subjects;
    num_of_RT_bins=5; % Decide to how many bins RT data should be divided
    RT_bin_size=100/num_of_RT_bins;
    
    HV_chose_go_prop=zeros(1,length(subjects));
    LV_chose_go_prop=zeros(1,length(subjects));
    
    proportion_chose_left_when_left_is_go=zeros(length(subjects),num_of_RT_bins);
    proportion_chose_left_when_left_is_nogo=zeros(length(subjects),num_of_RT_bins);
    bin_midpoint=zeros(length(subjects),num_of_RT_bins);
    proportion_chose_go=zeros(length(subjects),num_of_RT_bins);
    
    fast_dm_data=0;
    for subjInd=1:length(subjects)
        
        data=Probe_recode(subjects(subjInd));
        % The Probe_recode function will join all present output file for each subject into a single matrix, these are the matrix columns:
        % 1-subjectID       2-scanner	 3-order        4-block         5-run       6-trial	 7-onsettime    8-ImageLeft	 9-ImageRight	10-bidIndexLeft
        % 11-bidIndexRight	12-IsleftGo	 13-Response    14-PairType     15-Outcome  16-RT	 17-bidLeft     18-bidRight
        if fast_dm_data==0
            fast_dm_data=zeros(length(subjects)*length(data),6);
        end
        fast_dm_data_lines=(subjInd-1)*length(data)+1:(subjInd)*length(data);
        
        all_subjs_data{subjInd}=data; %All subjects' data
        order=data(1,3);
        if order==1 %define which stimuli were Go items: [High    Low]
            GoStim=[7 10 12 13 15 18   44 45 47 50 52 53];
        elseif order==2
            GoStim=[8  9 11 14 16 17   43 46 48 49 51 54];
        end
        
        
        Rank_left=data(:,10);
        Rank_right=data(:,11);
        Is_left_go=data(:,12);
        Response=data(:,13); % 1 - left, 0 - right
        PairType=data(:,14);
        Outcome=data(:,15);
        RT=data(:,16);
        
        fast_dm_data(fast_dm_data_lines,1)=data(:,1); %subID
        fast_dm_data(fast_dm_data_lines,2)=1:length(data); %trial num (all runs combined)
        fast_dm_data(fast_dm_data_lines,3)=PairType; %pair type
        fast_dm_data(fast_dm_data_lines,4)=Is_left_go; % is left go
%         fast_dm_data(fast_dm_data_lines,5)=Response; % subject chose left
        fast_dm_data(fast_dm_data_lines,5)=Outcome; % subject chose Go
        fast_dm_data(fast_dm_data_lines,6)=RT/1000; % RT in secs
        
        
        
        HV_chose_go_prop(subjInd)=sum(PairType==1&Outcome==1)/sum(PairType==1&Outcome~=999);
        LV_chose_go_prop(subjInd)=sum(PairType==2&Outcome==1)/sum(PairType==2&Outcome~=999);
        
        
        Valid_choices=ismember(PairType,requested_PairType)&Outcome~=999&RT>200;
        RT_bin_cuttoff=[0,prctile(RT(Valid_choices),RT_bin_size:RT_bin_size:100-RT_bin_size),1500];
        
        
        for bin_num=1:length(RT_bin_cuttoff)-1
            choices_in_bin=Valid_choices&RT>=RT_bin_cuttoff(bin_num)&RT<RT_bin_cuttoff(bin_num+1);
            proportion_chose_left_when_left_is_go(subjInd,bin_num)=sum(Is_left_go==1&choices_in_bin&Response==1)/sum(Is_left_go==1&choices_in_bin);
            proportion_chose_left_when_left_is_nogo(subjInd,bin_num)=sum(Is_left_go==0&choices_in_bin&Response==1)/sum(Is_left_go==0&choices_in_bin);
            bin_midpoint(subjInd,bin_num)=mean([RT_bin_cuttoff(bin_num),RT_bin_cuttoff(bin_num+1)]);
            proportion_chose_go(subjInd,bin_num)=sum(Outcome==1&choices_in_bin)/sum(choices_in_bin);
        end
        
        % Organize data in a summary table
        probe_results(subjInd,2)=order;
        
        probe_results(subjInd,3)=sum(PairType==1&Outcome~=999); % High value GO vs NoGo - number of valid trials
        probe_results(subjInd,4)=sum(PairType==2&Outcome~=999); % Low value GO vs NoGo - number of valid trials
        probe_results(subjInd,5)=sum(PairType==4&Outcome~=999); % NoGo Sanity check - number of valid trials
        probe_results(subjInd,6)=sum(Outcome==999); % number of invalid trials
        
        probe_results(subjInd,7)=sum(PairType==1&Outcome==1)/sum(PairType==1&Outcome~=999); % High value GO vs NoGo - Percent chosen Go
        probe_results(subjInd,8)=sum(PairType==2&Outcome==1)/sum(PairType==2&Outcome~=999); % Low value GO vs NoGo - Percent chosen Go
        probe_results(subjInd,9)=sum(PairType==3&Outcome==1)/sum(PairType==3&Outcome~=999); % Go Sanity check - Percent chosen Sanely
        probe_results(subjInd,10)=sum(PairType==4&Outcome==1)/sum(PairType==4&Outcome~=999); % NoGo Sanity check - Percent chosen Sanely
        
    end
    disp(sum(fast_dm_data(:,6)<0.2));
    
    fast_dm_data(fast_dm_data(:,5)==999|fast_dm_data(:,3)>2|fast_dm_data(:,6)<0.2,:)=[]; % remove missed trials, sanity, and RT below 200 ms
    disp(sum(zscore(fast_dm_data(:,6))<-3));
    disp('-');
    
    % save fast_dm data for analysis
    if isempty(dir('./fast_dm'))
        mkdir('./fast_dm')
    end
    delete('./fast_dm/fast_dm_data.dat');
    fid=fopen('./fast_dm/fast_dm_data.dat','w');
    sub=fast_dm_data(1,1);
    fid_sub=fopen(['./fast_dm/',num2str(sub),'.dat'],'w');
    %fprintf(fid,'subjectID trial PairType IsleftGo RESPONSE  TIME\n');
    
    % Go over all fast_dm_data lines and save for each subject in a new
    % file
    for i=1:length(fast_dm_data)
        if sub~=fast_dm_data(i,1)
            sub=fast_dm_data(i,1);
            fclose(fid_sub);
            fid_sub=fopen(['./fast_dm/',num2str(sub),'.dat'],'w');
            
        end
        fprintf(fid,'%i %i %i %i %i %f\n',fast_dm_data(i,1),fast_dm_data(i,2),fast_dm_data(i,3),fast_dm_data(i,4),fast_dm_data(i,5),fast_dm_data(i,6));
        fprintf(fid_sub,'%i %i %i %i %i %f\n',fast_dm_data(i,1),fast_dm_data(i,2),fast_dm_data(i,3),fast_dm_data(i,4),fast_dm_data(i,5),fast_dm_data(i,6));
        
    end
    fid_sub=fclose(fid_sub);
    fid=fclose(fid);
    %
    
    %     % Plot response as function of binned RT
    %     figure ('Name','response as function of binned RT','Units','normalized','position',[0.2,0.2,0.6,0.6]);
    %     subplot(1,2,1)
    %     hold on
    %     plot(mean(bin_midpoint),nanmean(proportion_chose_go)','-ok')
    %     hold on;
    %     plot([0,1500],[0.5,0.5],'--k'),
    %     ylabel('Proportion subject chose Go')
    %     xlabel(sprintf('Mean RT (binned to %i percentiles)',num_of_RT_bins))
    %     axis([0,1500,0,1]);
    
    subplot(2,ceil(num_of_exp/2),exp_num)
    title(exp_name{exp_num},'Interpreter','none','FontSize',16);
    hold on
    
    %plot(mean(bin_midpoint),nanmean(proportion_chose_left_when_left_is_go)','-ob');
    %plot(mean(bin_midpoint),nanmean(proportion_chose_left_when_left_is_nogo)','-or')
    
    errorbar(mean(bin_midpoint),nanmean(proportion_chose_left_when_left_is_go)',nanstd(proportion_chose_left_when_left_is_go)'/sqrt(length(subjects)),'-ob');
    errorbar(mean(bin_midpoint),nanmean(proportion_chose_left_when_left_is_nogo)',nanstd(proportion_chose_left_when_left_is_nogo)'/sqrt(length(subjects)),'-or');
    
    plot([0,1500],[0.5,0.5],'--k'),
    axis([0,1500,0,1]);
    ylabel('Proportion subject chose left')
    xlabel(sprintf('Mean RT (binned to %i percentiles)',num_of_RT_bins))
    legend('Trial left was go','Trial left was nogo')
    
    [~,p_HV]=ttest(HV_chose_go_prop,0.5);
    [~,p_LV]=ttest(LV_chose_go_prop,0.5);
    
    
    str = sprintf('HV:%.2f%%, p=%.3f\nLV:%.2f%%, p=%.3f',100*mean(HV_chose_go_prop),p_HV,100*mean(LV_chose_go_prop),p_LV);
    text(100,0.1,str)
    pause(0.01);
end
cd(current_dir);