
% ~~~ Script for analyzing probe results, modified for face experiment ~~~
% ~~~~~~~~~~~~~~~ Tom Salomon, February 2015  ~~~~~~~~~~~~~~
%
% In order to run the script, you must locate and run the script from within
% "Analysis" folder. The scrip uses external function, called
% "Probe_recode" which join all probe output file into one matrix. Please
% make sure that function is also present in the analysis folder.
%
% Note: this script and "Probe_recode" function were written specifically
% for face stimuli in a specific name format. For other stimuli, you need
% to modify the Probe_recode function first.
%
% Enjoy!

clear all

subjects=[101:116,119:120,125:134]; % Define here your subjects' codes.
%exclude:
% 117 - did snack version of the experiment 3 month prior to the experimnet
% 118 & 121 - were over 40 years old
% 122:124 - did the training part with the Psychtoolbox's audio function

analysis_path=pwd; % Analysis folder location
outpath=[analysis_path(1:end-8),'Output\']; % Output folder location
all_subjs_data{length(subjects)}={};
probe_results=zeros(length(subjects),20);
probe_results(:,1)=subjects;

for subjInd=1:length(subjects)
    
    data=Probe_recode(subjects(subjInd));
    % The Probe_recode function will join all present output file for each subject into a single matrix, these are the matrix columns:
    % 1-subjectID       2-scanner	 3-order        4-block         5-run       6-trial	 7-onsettime    8-ImageLeft	 9-ImageRight	10-bidIndexLeft
    % 11-bidIndexRight	12-IsleftGo	 13-Response    14-PairType     15-Outcome  16-RT	 17-bidLeft     18-bidRight
    
    all_subjs_data{subjInd}=data; %All subjects' data
    order=data(1,3);
    if order==1 %define which stimuli were Go items: [High   HighSanity   LowSanity   Low]
        GoStim=[7 10 12 13 15 18 20 21    5 24    37 56   39 42 44 45 47 50 52 53];
    elseif order==2
        GoStim=[8  9 11 14 16 17 19 22     6 23    38 55   40 41 43 46 48 49 51 54];
    end
    
    PairType=data(:,14);
    Outcome=data(:,15);
    Rank_left=data(:,10);
    Rank_right=data(:,11);
    
    highest=ismember(Rank_left,7:14)&ismember(Rank_right,7:14);
    high_middle=ismember(Rank_left,15:22)&ismember(Rank_right,15:22);
    low_middle=ismember(Rank_left,39:46)&ismember(Rank_right,39:46);
    lowest=ismember(Rank_left,47:54)&ismember(Rank_right,47:54);
    
    HHGo_vs_HMNoGo=(ismember(Rank_left,7:14)&ismember(Rank_left,GoStim)&ismember(Rank_right,15:22))+(ismember(Rank_right,7:14)&ismember(Rank_right,GoStim)&ismember(Rank_left,15:22));
    HHNoGo_vs_HMGo=(ismember(Rank_left,7:14)&ismember(Rank_right,GoStim)&ismember(Rank_right,15:22))+(ismember(Rank_right,7:14)&ismember(Rank_left,GoStim)&ismember(Rank_left,15:22));
    LLGo_vs_LMNoGo=(ismember(Rank_left,47:54)&ismember(Rank_left,GoStim)&ismember(Rank_right,39:46))+(ismember(Rank_right,47:54)&ismember(Rank_right,GoStim)&ismember(Rank_left,39:46));
    LLNoGo_vs_LMGo=(ismember(Rank_left,47:54)&ismember(Rank_right,GoStim)&ismember(Rank_right,39:46))+(ismember(Rank_right,47:54)&ismember(Rank_left,GoStim)&ismember(Rank_left,39:46));

% Organize data in a summary table
    probe_results(subjInd,2)=order;
    
    probe_results(subjInd,3)=sum(PairType==1&Outcome~=999); % High value GO vs NoGo - number of valid trials
    probe_results(subjInd,4)=sum(PairType==2&Outcome~=999); % Low value GO vs NoGo - number of valid trials
    probe_results(subjInd,5)=sum(PairType==3&Outcome~=999); % Go Sanity check - number of valid trials
    probe_results(subjInd,6)=sum(PairType==4&Outcome~=999); % NoGo Sanity check - number of valid trials
    
    probe_results(subjInd,7)=sum(PairType==1&Outcome==1)/sum(PairType==1&Outcome~=999); % High value GO vs NoGo - Percent chosen Go
    probe_results(subjInd,8)=sum(PairType==2&Outcome==1)/sum(PairType==2&Outcome~=999); % Low value GO vs NoGo - Percent chosen Go
    probe_results(subjInd,9)=sum(PairType==3&Outcome==1)/sum(PairType==3&Outcome~=999); % Go Sanity check - Percent chosen Sanely
    probe_results(subjInd,10)=sum(PairType==4&Outcome==1)/sum(PairType==4&Outcome~=999); % NoGo Sanity check - Percent chosen Sanely
    
    probe_results(subjInd,11)=sum(highest==1&Outcome==1)/sum(highest==1&Outcome~=999); % 4 Highest values GO vs NoGo - Percent chosen Go
    probe_results(subjInd,12)=sum(high_middle==1&Outcome==1)/sum(high_middle==1&Outcome~=999); % 4 High-middle values GO vs NoGo - Percent chosen Go
    probe_results(subjInd,13)=sum(low_middle==1&Outcome==1)/sum(low_middle==1&Outcome~=999); % 4 Low-middle values GO vs NoGo - Percent chosen Go
    probe_results(subjInd,14)=sum(lowest==1&Outcome==1)/sum(lowest==1&Outcome~=999); % 4 Lowest values GO vs NoGo - Percent chosen Go

    probe_results(subjInd,15)=sum(HHGo_vs_HMNoGo==1&Outcome==1)/sum(HHGo_vs_HMNoGo==1&Outcome~=999); % High-High GO vs High-Middle NoGo
    probe_results(subjInd,16)=sum(HHNoGo_vs_HMGo==1&Outcome==1)/sum(HHNoGo_vs_HMGo==1&Outcome~=999); % High-High NoGO vs High-Middle Go
    probe_results(subjInd,17)=sum(LLGo_vs_LMNoGo==1&Outcome==1)/sum(LLGo_vs_LMNoGo==1&Outcome~=999); % Low-Low GO vs Low-Middle NoGo
    probe_results(subjInd,18)=sum(LLNoGo_vs_LMGo==1&Outcome==1)/sum(LLNoGo_vs_LMGo==1&Outcome~=999); % Low-Low NoGO vs Low-Middle Go
end

% analyze the data for all subject
means=zeros(1,length(probe_results(1,:))-6);
stddevs=zeros(1,length(probe_results(1,:))-6);
p_values=zeros(1,length(probe_results(1,:))-6);

Text{1}='\nHigh value GO vs NoGo';
Text{2}='Low value GO vs NoGo';

Text{3}='\nGO Sanity check';
Text{4}='NoGO Sanity check';

Text{5}='\nHighest values GO vs NoGo';
Text{6}='Mid-High values GO vs NoGo';
Text{7}='Mid-Low values GO vs NoGo';
Text{8}='Lowest values GO vs NoGo';

Text{9}='\nHigh-High GO vs High-Middle NoGo';
Text{10}='High-High NoGO vs High-Middle Go';
Text{11}='Low-Low GO vs Low-Middle NoGo';
Text{12}='Low-Low NoGO vs Low-Middle Go';

fprintf('\nProbe Results\n')
fprintf('=============\n')
for i=1:length(Text)
means(i)=mean(probe_results(:,i+6));
stddevs(i)=std(probe_results(:,i+6));
[~,p_values(i)]=ttest(probe_results(:,i+6),0.5);
 fprintf([Text{i},': mean=%.2f, p=%.3f\n'],means(i),p_values(i));
end
stderr=stddevs.*(1/sqrt(length(subjects)));

Recognition_results=recognition_analysis;
probe_for_recognition=probe_results(ismember(probe_results(:,1),Recognition_results(:,1)),:);
r_values=zeros(1,length(probe_for_recognition(:,1)));

fprintf('\nCorrelation with correct IsGo? response\n')
fprintf('=======================================\n')
for i=1:length(Text)
[r_values(i)]=corr(probe_for_recognition(:,i+6),Recognition_results(:,3));
 fprintf([Text{i},': r=%.2f\n'],r_values(i));
end

% GoWasNoted = Recognition_results(Recognition_results(:,3)>0.65,1);
% GoWasntNoted = Recognition_results(Recognition_results(:,3)<=0.65,1);
% probe_results(:,19)=ismember(probe_results(:,1),GoWasNoted)+ismember(probe_results(:,1),GoWasntNoted)*2;

% % Possible statistical analysis
% [~,p]=ttest(probe_results(:,7),0.5);  % High value GO vs NoGo
% [~,p]=ttest(probe_results(:,8),0.5);  % Low value GO vs NoGo
% 
% [~,p]=ttest(probe_results(:,9),0.5);  % GO Sanity check
% [~,p]=ttest(probe_results(:,10),0.5); % NoGO Sanity check
% 
% [~,p]=ttest(probe_results(:,11),0.5); % Highest values GO vs NoGo
% [~,p]=ttest(probe_results(:,12),0.5); % Mid-High values GO vs NoGo
% [~,p]=ttest(probe_results(:,13),0.5); % Mid-Low values GO vs NoGo
% [~,p]=ttest(probe_results(:,14),0.5); % Lowest values GO vs NoGo
% 
% [~,p]=ttest(probe_results(:,15),0.5); % High-High GO vs High-Middle NoGo
% [~,p]=ttest(probe_results(:,16),0.5); % High-High NoGO vs High-Middle Go
% [~,p]=ttest(probe_results(:,17),0.5); % Low-Low GO vs Low-Middle NoGo
% [~,p]=ttest(probe_results(:,18),0.5); % Low-Low NoGO vs Low-Middle Go
%  
% means=[mean(probe_results(:,15)),mean(probe_results(:,16)),mean(probe_results(:,17)),mean(probe_results(:,18))];
% stddevs=[std(probe_results(:,15)),std(probe_results(:,16)),std(probe_results(:,17)),std(probe_results(:,18))];
% stderr=stddevs.*(1/sqrt(length(subjects)));
% dynplot(means,stderr);

% % Just a reminder - this is the stimulus assignment:
% %
% %                     Not_used  |  Go/NoGo                     | Sanity  | Not_used
% if order == 1
%     HV_Beep =   [                  7 10 12 13 15 18 20 21    24 25              ]; %HV_beep
%     HV_NoBeep = [ 1:6          8  9 11 14 16 17 19 22     23 26      27:30]; %HV_nobeep
%     LV_Beep =   [                  39 42 44 45 47 50 52 53   36 37              ]; %LV_beep
%     LV_NoBeep = [ 31:34       40 41 43 46 48 49 51 54   35 38     55:60 ]; %LV_nobeep
% %                     Not_used  |  Go/NoGo                     | Sanity  | Not_used
% else
%     HV_Beep =   [              8  9 11 14 16 17 19 22   23 26         ]; %HV_beep
%     HV_NoBeep = [ 1:6          7 10 12 13 15 18 20 21   24 25   27:30 ]; %HV_nobeep
%     LV_Beep =   [             40 41 43 46 48 49 51 54   35 38         ]; %LV_beep
%     LV_NoBeep = [ 31:34       39 42 44 45 47 50 52 53   36 37   55:60 ]; %LV_nobeep
% end