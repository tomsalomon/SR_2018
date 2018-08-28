
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


subjects=[120,122:124,126:127,129:133,135:138,140,142,144,147:150,153:158]; % Define here your subjects' codes.
%exclude:
% 121, 128, 134, 139, 143, 151, 152- failed
% 125, 141 - had poor training
% 144, 145 - not so good training. consider removal



analysis_path=pwd; % Analysis folder location
outpath='./../Output/'; % Output folder location
all_subjs_data{length(subjects)}={};
probe_results=zeros(length(subjects),10);
probe_results(:,1)=subjects;
num_of_RT_bins=10; % Decide to how many bins RT data should be divided
RT_bin_size=100/num_of_RT_bins;

for subjInd=1:length(subjects)
    
    data=Probe_recode(subjects(subjInd));
    % The Probe_recode function will join all present output file for each subject into a single matrix, these are the matrix columns:
    % 1-subjectID       2-scanner	 3-order        4-block         5-run       6-trial	 7-onsettime    8-ImageLeft	 9-ImageRight	10-bidIndexLeft
    % 11-bidIndexRight	12-IsleftGo	 13-Response    14-PairType     15-Outcome  16-RT	 17-bidLeft     18-bidRight
    
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
    
    Valid_choices=PairType<=2&Outcome~=999;
    RT_bin_cuttoff=[0,prctile(RT(Valid_choices),[RT_bin_size:RT_bin_size:100-RT_bin_size]),1500];
    
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

% Plot response as function of binned RT 
figure ('Name','response as function of binned RT','Units','normalized','position',[0.2,0.2,0.6,0.6]);
subplot(1,2,1)
hold on
plot(mean(bin_midpoint),nanmean(proportion_chose_go)','-ok')
hold on;
plot([0,1500],[0.5,0.5],'--k'),
ylabel('Proportion subject chose Go')
xlabel(sprintf('Mean RT (binned to %i percentiles)',num_of_RT_bins))
axis([0,1500,0,1]);

subplot(1,2,2)
hold on
plot(mean(bin_midpoint),nanmean(proportion_chose_left_when_left_is_go)','-ob');
hold on;
plot(mean(bin_midpoint),nanmean(proportion_chose_left_when_left_is_nogo)','-or')
hold on;
plot([0,1500],[0.5,0.5],'--k'),
axis([0,1500,0,1]);
ylabel('Proportion subject chose left')
xlabel(sprintf('Mean RT (binned to %i percentiles)',num_of_RT_bins))
legend('Trial left was go','Trial left was nogo')

Probe_results_table = cell(1+size(probe_results,1),size(probe_results,2));
Titles = {'Subject', 'Order', '#HighValue', '#LowValue', '#SanityNoGo', '#InvalidTrials', '%HighChoseGo', '%LowChoseGo', '%SanityGoChoseHigh', '%SanityNoGoChoseHigh'};
Probe_results_table(1,:) = Titles;
Probe_results_table(2:end,:) = num2cell(probe_results);


% analyze the data for all subject
means=zeros(1,length(probe_results(1,:))-6);
stddevs=zeros(1,length(probe_results(1,:))-6);
p_values=zeros(1,length(probe_results(1,:))-6);

Text{1}='\nHigh value GO vs NoGo';
Text{2}='Low value GO vs NoGo';

Text{3}='\nGO Sanity check';
Text{4}='NoGO Sanity check';


fprintf('\nProbe Results\n')
fprintf('=============\n')
for i=1:length(Text)
    means(i)=mean(probe_results(:,i+6));
    stddevs(i)=std(probe_results(:,i+6));
    [~,p_values(i)]=ttest(probe_results(:,i+6),0.5);
    fprintf([Text{i},': mean=%.2f, p=%.3f\n'],means(i),p_values(i));
end
stderr=stddevs.*(1/sqrt(length(subjects)));


