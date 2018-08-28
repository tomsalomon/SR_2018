function run_boost_Israel_new()
% function run_boost_Israel_new()
% Created based on the previous boost codes, by Rotem Botvinik November 2014
% Runs the cue-approach task from the training session to the probe,
% including sorting the stimuli according to the BDM results.

%   FUNCTIONS REQUIRED TO RUN PROPERLY
% - - - - - - - - - - - - - - -  
%   sort_BDM_Israel
%   binary_ranking - (for non-snacks experiments)
%   binary_ranking_demo - (for non-snacks experiments)
%   trainingDemo_Israel
%   training_Israel (if NO EYETRACKING)
%   probeDemo_Israel
%   probe_Israel
%   probeResolve_Israel


% =========================================================================
% Get input args and check if input is ok
% =========================================================================

% %---dummy info for testing purposes --------
% subjectID =  'BM_9001';
% order = 1;
% test_comp = 3; % 3 Rotem_PC 2 Toms_iMac, 1 MRI, 0 if testooom
% SessionNum = 1;
total_num_runs=2;
runsOrder = ones(1,total_num_runs);
runs_noEyetrack = 1:2;
runsOrder(runs_noEyetrack)=0;

% input checkers
okSessionNum = [1 2 3];
okComputer = [0 1 2 3];
okOrder = [1 2];
okDemo = [0 1];
okStimuli = [1 2 3];

subjectID = input('Subject code: ','s');
while isempty(subjectID)
    disp('ERROR: no value entered. Please try again.');
    subjectID = input('Subject code:','s');
end
% order number (same across all tasks/runs for a single subject. Should be
% counterbalanced between 1,2 across subjects)

stimuli = input('\n Enter stimuli type (1 - snacks, 2 - faces, 3 - fractals: ');
while isempty(stimuli) || sum(okStimuli==stimuli)~=1
    disp('ERROR: input must be 1,2 or 3 . Please try again.');
    stimuli = input('\n Enter stimuli type (1 - snacks, 2 - faces, 3 - fractals: ');
end

order = input('\n Enter order number (1,2 ; this should be counterbalanced across subjects): ');
while isempty(order) || sum(okOrder==order)~=1
    disp('ERROR: input must be 1 or 2 . Please try again.');
    order = input('\n Enter order number (1,2 ; this should be counterbalanced across subjects): ');
end

SessionNum = input('\n Enter session number (1 if first for this subject): ');
while isempty(SessionNum) || sum(okSessionNum==SessionNum)~=1
    disp('ERROR: input must be 1 or 2 or 3 . Please try again.');
    SessionNum = input('\n Enter session number (1 if first for this subject): ');
end


% =========================================================================
% set the computer and path
% =========================================================================

test_comp = input('\n Which computer are you using? 3 Rotem_PC 2 Toms_iMac, 1 MRI, 0 if testooom: ');
while isempty(test_comp) || sum(okComputer==test_comp)~=1
    disp('ERROR: input must be 0,1,2 or 3. Please try again.');
    test_comp = input('\n Which computer are you using? 3 Rotem_PC, 2 Toms_iMac, 1 MRI, 0 if testooom: ');
end

% Set main path
switch test_comp
    case 0
        mainPath = 'D:\Tom\Dropbox\Experiment_Israel\Codes\Boost_Israel_New_Tom'; % Change when we have the new computer for the behavioral task
    case 1
        mainPath = pwd; % Change when we have the new computer for the fMRI task
    case 2
        mainPath = 'dropbox\trainedInhibition\Boost_Israel';
    case 3
        mainPath = 'D:\Rotem\Matlab\Boost_Israel_New_Rotem';
end % end switch

outputPath = [mainPath '\Output'];


% =========================================================================
% Sort stimuli according to the BDM ranking (BDM = PART 1)
% =========================================================================
if stimuli==1
sort_BDM_Israel(subjectID,order,outputPath);
else  % For non-snacks experiments, run the binary ranking code instead of BDM
    binary_ranking_demo(subjectID,test_comp,stimuli,mainPath);
    binary_ranking(subjectID,test_comp,stimuli,mainPath);
    sort_binary_ranking(subjectID,order,outputPath);
end
% =========================================================================
% Create and arrange xls file for training results
% =========================================================================

% Set number and type (eyetrack/noEyetrack) of runs
% total_num_runs=12;
% runsOrder = ones(1,total_num_runs);
% runs_noEyetrack = 1:12;
% runsOrder(runs_noEyetrack)=0;

% set timestamp
c = clock;
hr = sprintf('%02d', c(4));
minutes = sprintf('%02d', c(5));
timestamp=[date,'_',hr,'h',minutes,'m'];

% set global information for the xls file
details{1,1} = 'subjectID:';
details{1,2} = subjectID;
details{2,1} = 'order:';
details{2,2} = order;
details{3,1} = 'timestamp:';

% set titles for the data
details{6,1} = 'trialNum';
details{6,2} = 'itemName';
details{6,3} = 'onsetTime';
details{6,4} = 'shuff_trialType';
details{6,5} = 'RT';
details{6,6} = 'respInTime';
details{6,7} = 'AudioTime';
details{6,8} = 'response';
details{6,9} = 'fixationTime';
details{6,10} = 'ladder1';
details{6,11} = 'ladder2';


xlsfilename = [outputPath '\' subjectID '_training_all_' num2str(total_num_runs) '_runs_' timestamp];
detailsRange = 'A1';
xlssheet = 'Demo';
xlswrite(xlsfilename,details,xlssheet,detailsRange);

details{6,12} = 'bidIndex';
details{6,13} = 'itemNameIndex';
details{6,14} = 'bidValue';

for ind = 1:2:total_num_runs
    if runsOrder(ind)==0
        runType = 'noEyetrack';
    else runType = 'Eyetrack';
    end % end if runsOrder(ind)==0
    xlssheet = ['Run' num2str(ind) '_' runType];
    xlswrite(xlsfilename,details,xlssheet,detailsRange);
    xlssheet = ['Run' num2str(ind+1) '_' runType];
    xlswrite(xlsfilename,details,xlssheet,detailsRange);
end % end for ind = 1:total_num)runs


% =========================================================================
% Training (including demo) - (Training = PART 2)
% =========================================================================

trainingDemo_Israel(subjectID,order,mainPath,test_comp,xlsfilename);

demo_again=input('Do you want more practice? Press 1 if yes, press 0 if no ');
while isempty(demo_again) || sum(demo_again==okDemo)~=1
    disp('ERROR: input must be 0 or 1 . Please try again.');
    demo_again=input('Do you want more practice? Press 1 if yes, press 0 if no ');
end


if demo_again==1
    trainingDemo_Israel(subjectID,order,mainPath);
end



for runInd = 1:2:total_num_runs
    switch runsOrder(runInd)
        case 0
        training_Israel(subjectID,order,mainPath,test_comp,runInd,total_num_runs,xlsfilename);    
        case 1
        trainingEyetrack_Israel(subjectID,order,mainPath,test_comp,runInd,total_num_runs,xlsfilename);      
    end % end switch total_num_runs(runInd)
end % end for runInd = 1:total_num_runs


%==========================================================
%%   'BIS'
%==========================================================

% PART 3
% - - - - - - - 
% BIS(subjectID, test_comp);
 

%==========================================================
%%   'probe_demo & probe'
%==========================================================
                
% PART 4
% - - - - - - - 
probeType = 'noEyetrack';

% set timestamp
c = clock;
hr = sprintf('%02d', c(4));
minutes = sprintf('%02d', c(5));
timestamp=[date,'_',hr,'h',minutes,'m'];

% set global information for the xls file
details{1,1} = 'subjectID:';
details{1,2} = subjectID;
details{2,1} = 'order:';
details{2,2} = order;
details{3,1} = 'timestamp:';
details{4,1} = 'Computer:';
details{4,2} = test_comp;

% set titles for the data
details{6,1} = 'trialNum';
details{6,2} = 'onsetTime';
details{6,3} = 'ImageLeft';
details{6,4} = 'ImageRight';
details{6,5} = 'bidIndexLeft';
details{6,6} = 'bidIndexRight';
details{6,7} = 'IsleftGo';
details{6,8} = 'Response';
details{6,9} = 'PairType';
details{6,10} = 'Outcome';
details{6,11} = 'RT';

xlsfilename = [outputPath '\' subjectID '_probe_results_' probeType '_' timestamp];
detailsRange = 'A1';
xlssheet = 'Demo';
xlswrite(xlsfilename,details,xlssheet,detailsRange);

details{6,12} = 'bidLeft';
details{6,13} = 'bidRight';
 
for ind = 1:2
block = (SessionNum-1)*2 + ind;
xlssheet = ['Block' num2str(block)];
xlswrite(xlsfilename,details,xlssheet,detailsRange);
end % end for ind = 1:2


probeDemo_Israel(subjectID, order, mainPath, test_comp, SessionNum, xlsfilename,stimuli);

demo_again=input('Do you want more practice? Press 1 if yes, press 0 if no ');
while isempty(demo_again) || sum(demo_again==okDemo)~=1
    disp('ERROR: input must be 0 or 1 . Please try again.');
    demo_again=input('Do you want more practice? Press 1 if yes, press 0 if no ');
end

if demo_again==1
  probeDemo_Israel(subjectID, order, mainPath, test_comp, SessionNum, xlsfilename,stimuli);
end

[total_num_trials] = probe_Israel(subjectID, order, mainPath, test_comp, SessionNum, 1, xlsfilename, stimuli); % block 1
[total_num_trials] = probe_Israel(subjectID, order, mainPath, test_comp, SessionNum, 2, xlsfilename, stimuli); % block 2


%==========================================================
%%   'post-task'
%==========================================================

% PART 5
% - - - - - - - 
% cued_recognition(subjectID,test_comp,order, SessionNum);


probeResolve_Israel(subjectID, SessionNum, outputPath, total_num_trials);
 
% quit %quits matlab
          

end % end function





