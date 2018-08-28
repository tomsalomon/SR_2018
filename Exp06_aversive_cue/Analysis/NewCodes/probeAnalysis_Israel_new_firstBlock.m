function [probe_results,allSubjectsData] = probeAnalysis_Israel_new_firstBlock(mainPath, experimentName, Subjects)
% function [] = probeAnalysis_Israel_new(mainPath, experimentName, Subjects)

% This function analyzes the probe, including sanity checks (2X2 for snacks) and GO-NOGO comparisons.
% "Within comparisons", between the 8 higher-HV items and the 8 lower-HV
% items, and between the 8 lower LV items and the 8 higher LV items are
% also included.

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % % --------- Exterior files needed for task to run correctly: ----------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% Probe results of all the subjects, in the 'Output' folder.

% function "joinProbe", which joins the results of the probe, which are
% divided to a few output files (one for each run), into one matrix.

if nargin < 3
    Subjects = [101 103:107 109:113 117:128]; % write here only the subjects that should be analyzed (were not excluded)
    % 102- excluded due to extremely low rankings in the BDM
end

if nargin < 2
    experimentName = 'BMI_bs';
end

if nargin < 1
    mainPath = 'D:\Rotem\Dropbox\Experiment_Israel\Codes\Boost_Israel_New_Rotem_mac';
end

outputPath = [mainPath '/Output'];

allSubjectsData = cell(length(Subjects),1);
probe_results = zeros(length(Subjects),20);
probe_results(:,1) = Subjects;

for subjectInd = 1:length(Subjects)
    
    subjectData = joinProbe_firstBlock(outputPath,experimentName,Subjects(subjectInd));
    % The joinProbe function will join all present output files for each subject into a single cell array, these are the array columns:
    % 1-subjectID       2-scanner	 3-order        4-block         5-run       6-trial	 7-onsettime    8-ImageLeft	 9-ImageRight	10-bidIndexLeft
    % 11-bidIndexRight	12-IsleftGo	 13-Response    14-PairType     15-Outcome  16-RT	 17-bidLeft     18-bidRight
    
    allSubjectsData{subjectInd} = subjectData; % Join the data of all subjects into one array
    order = subjectData(1,3);
    if order == 1 %define which stimuli were Go items: [High   HighSanity   LowSanity   Low]
        GoStim=[7 10 12 13 15 18   44 45 47 50 52 53];
    elseif order == 2
        GoStim=[8  9 11 14 16 17   43 46 48 49 51 54];
    end
    
    PairType = subjectData(:,14);
    Outcome = subjectData(:,15);
    Rank_left = subjectData(:,10);
    Rank_right = subjectData(:,11);
    
    highest = ismember(Rank_left,7:12) & ismember(Rank_right,7:12);
    high_middle = ismember(Rank_left,13:18) & ismember(Rank_right,13:18);
    low_middle = ismember(Rank_left,43:48) & ismember(Rank_right,43:48);
    lowest = ismember(Rank_left,49:54) & ismember(Rank_right,49:54);
    
    HHGo_vs_HMNoGo = ((ismember(Rank_left,7:12) & ismember(Rank_left,GoStim) & ismember(Rank_right,13:18))) | ((ismember(Rank_right,7:12) & ismember(Rank_right,GoStim)&ismember(Rank_left,13:18)));
    HHNoGo_vs_HMGo = ((ismember(Rank_left,7:12) & ismember(Rank_right,GoStim) & ismember(Rank_right,13:18))) | ((ismember(Rank_right,7:12) & ismember(Rank_left,GoStim)&ismember(Rank_left,13:18)));
    LLGo_vs_LMNoGo = ((ismember(Rank_left,49:54) & ismember(Rank_left,GoStim) & ismember(Rank_right,43:48))) | ((ismember(Rank_right,49:54) & ismember(Rank_right,GoStim)&ismember(Rank_left,43:48)));
    LLNoGo_vs_LMGo = ((ismember(Rank_left,49:54) & ismember(Rank_right,GoStim) & ismember(Rank_right,43:48))) | ((ismember(Rank_right,49:54) & ismember(Rank_left,GoStim)&ismember(Rank_left,43:48)));
    
    % Organize data in a summary table
    probe_results(subjectInd,2) = order;
    probe_results(subjectInd,3) = sum(PairType==1 & Outcome~=999); % High value GO vs NoGo - number of valid trials
    probe_results(subjectInd,4) = sum(PairType==2 & Outcome~=999); % Low value GO vs NoGo - number of valid trials
    probe_results(subjectInd,5) = sum(PairType==3 & Outcome~=999); % Go Sanity check - number of valid trials
    probe_results(subjectInd,6) = sum(PairType==4 & Outcome~=999); % NoGo Sanity check - number of valid trials
    
    probe_results(subjectInd,7) = sum(PairType==1 & Outcome==1) / sum(PairType==1 & Outcome~=999); % High value GO vs NoGo - Percent chosen Go
    probe_results(subjectInd,8) = sum(PairType==2 & Outcome==1) / sum(PairType==2 & Outcome~=999); % Low value GO vs NoGo - Percent chosen Go
    probe_results(subjectInd,9) = sum(PairType==3 & Outcome==1) / sum(PairType==3 & Outcome~=999); % Go Sanity check - Percent chosen the higher item
    probe_results(subjectInd,10) = sum(PairType==4 & Outcome==1) / sum(PairType==4 & Outcome~=999); % NoGo Sanity check - Percent chosen the higher item
    
    probe_results(subjectInd,11) = sum(highest==1 & Outcome==1) / sum(highest==1 & Outcome~=999); % 4 Highest values GO vs NoGo - Percent chosen Go
    probe_results(subjectInd,12) = sum(high_middle==1 & Outcome==1) / sum(high_middle==1 & Outcome~=999); % 4 High-middle values GO vs NoGo - Percent chosen Go
    probe_results(subjectInd,13) = sum(low_middle==1 & Outcome==1) / sum(low_middle==1 & Outcome~=999); % 4 Low-middle values GO vs NoGo - Percent chosen Go
    probe_results(subjectInd,14) = sum(lowest==1 & Outcome==1) / sum(lowest==1 & Outcome~=999); % 4 Lowest values GO vs NoGo - Percent chosen Go
    
    probe_results(subjectInd,15) = sum(HHGo_vs_HMNoGo==1 & Outcome==1) / sum(HHGo_vs_HMNoGo==1 & Outcome~=999); % High-High GO vs High-Middle NoGo
    probe_results(subjectInd,16) = sum(HHNoGo_vs_HMGo==1 & Outcome==1) / sum(HHNoGo_vs_HMGo==1 & Outcome~=999); % High-High NoGO vs High-Middle Go
    probe_results(subjectInd,17) = sum(LLGo_vs_LMNoGo==1 & Outcome==1) / sum(LLGo_vs_LMNoGo==1 & Outcome~=999); % Low-Low GO vs Low-Middle NoGo
    probe_results(subjectInd,18) = sum(LLNoGo_vs_LMGo==1 & Outcome==1) / sum(LLNoGo_vs_LMGo==1 & Outcome~=999); % Low-Low NoGO vs Low-Middle Go
    
end % end for subjectInd

% analyze the data for all subject
Text{1} = '\nHigh value GO vs NoGo';
Text{2} = 'Low value GO vs NoGo';

Text{3} = '\nGO Sanity check';
Text{4} = 'NoGO Sanity check';

Text{5} = '\nHighest values GO vs NoGo';
Text{6} = 'Mid-High values GO vs NoGo';
Text{7} = 'Mid-Low values GO vs NoGo';
Text{8} = 'Lowest values GO vs NoGo';

Text{9} = '\nHigh-High GO vs High-Middle NoGo';
Text{10} = 'High-High NoGO vs High-Middle Go';
Text{11} = 'Low-Low GO vs Low-Middle NoGo';
Text{12} = 'Low-Low NoGO vs Low-Middle Go';

fprintf('\nProbe Results\n')
fprintf('=============\n')

Means = mean(probe_results(:,7:end));
Stdevs = std(probe_results(:,7:end));
SEs = Stdevs.*(1/sqrt(length(Subjects))); % calculates standard errors
[~,p_values] = ttest(probe_results(:,7:end),0.5);

for ind = 1:length(Text)
    fprintf([Text{ind},': mean=%.2f, stddev=%.2f, stderr=%0.2f, p=%.3f\n'],Means(ind),Stdevs(ind),SEs(ind),p_values(ind));
end

% Recognition_results = recognition_analysis;
% probe_for_recognition = probe_results(ismember(probe_results(:,1),Recognition_results(:,1)),:);
% r_values = zeros(1,length(probe_for_recognition(:,1)));
%
% fprintf('\nCorrelation with correct IsGo? response\n')
% fprintf('=======================================\n')
% for i=1:length(Text)
% [r_values(i)]=corr(probe_for_recognition(:,i+6),Recognition_results(:,3));
%  fprintf([Text{i},': r=%.2f\n'],r_values(i));
% end

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
% % if order == 1
% % 
% %     bid_sortedM([           7 10 12 13 15 18                ], 4) = 11; % HV_beep
% %     bid_sortedM([ 3:6       8  9 11 14 16 17       19:22    ], 4) = 12; % HV_nobeep
% %     bid_sortedM([           44 45 47 50 52 53               ], 4) = 22; % LV_beep 
% %     bid_sortedM([ 39:42     43 46 48 49 51 54      55:58    ], 4) = 24; % LV_nobeep
% %     bid_sortedM([ 1:2            23:38             59:60    ], 4) = 0; % notTrained
% %     
% % 
% %     else
% % 
% %     bid_sortedM([           8  9 11 14 16 17                ], 4) = 11; % HV_beep
% %     bid_sortedM([ 3:6       7 10 12 13 15 18       19:22    ], 4) = 12; % HV_nobeep
% %     bid_sortedM([           43 46 48 49 51 54               ], 4) = 22; % LV_beep 
% %     bid_sortedM([ 39:42     44 45 47 50 52 53      55:58    ], 4) = 24; % LV_nobeep
% %     bid_sortedM([ 1:2            23:38             59:60    ], 4) = 0; % notTrained
% % 
% % end % end if order == 1

end % end function

