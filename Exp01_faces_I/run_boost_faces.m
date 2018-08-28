function run_boost_faces()

% function run_boost_Israel_new()

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% =============== Created based on the previous boost codes ===============
% ================ by Rotem Botvinik November-December 2014 ===============
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

% Runs the cue-approach task from the training session to the recognition task,
% including sorting the stimuli according to the BDM results and running
% the probe session.


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % % ---------------- FUNCTIONS REQUIRED TO RUN PROPERLY: ----------------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % %   --- Cue-approach codes: ---
% % %   'sort_BDM_Israel'
% % %   'trainingDemo_Israel'
% % %   'training_Israel' (if NO EYETRACKING)
% % %   'organizeProbe_Israel'
% % %   'probeDemo_Israel'
% % %   'probe_Israel'
% % %   'probeResolve_Israel'
% % %   'recognitionNewOld_Israel'
% % %   'recognitionGoNoGo_Israel'

% % %   --- Other codes: ---
% % %  'CenterText'


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % % ---------------- FOLDERS REQUIRED TO RUN PROPERLY: ------------------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % %   'Misc': a folder with the audio file.
% % %   'Onset_files': a folderwith the onset files for the training and
% % %    for the probe.
% % %   'Output': the folder for the output files- results.
% % %   'stim': with the bmp files of all the stimuli for the cue-approach
% % %    task (old stimuli).
% % %   'stim/recognitionNew': with the bmp files of the new stimuli
% % %   (stimuli that are not included in the cue-approach tasks, only in the
% % %   recognitionNewOld task, as new stimuli).

tic

% =========================================================================
% Get input args and check if input is ok
% =========================================================================

% %---dummy info for debugging purposes --------
% subjectID =  'BM_9001';
% order = 1;
% test_comp = 3; % 3 Rotem_PC 2 Toms_iMac, 1 MRI, 0 if testooom
% sessionNum = 1;

% input checkers
oksessionNum = [1 2 3];
okComputer = [0 1 2 3];
okOrder = [1 2];
okDemo = [0 1];

subjectID = input('Subject code: ','s');
while isempty(subjectID)
    disp('ERROR: no value entered. Please try again.');
    subjectID = input('Subject code:','s');
end
% order number (same across all tasks/runs for a single subject. Should be
% counterbalanced between 1,2 across subjects)

order = input('Enter order number (1,2 ; this should be counterbalanced across subjects): ');
while isempty(order) || sum(okOrder==order)~=1
    disp('ERROR: input must be 1 or 2 . Please try again.');
    order = input('Enter order number (1,2 ; this should be counterbalanced across subjects): ');
end

sessionNum = input('Enter session number (1 if first for this subject): ');
while isempty(sessionNum) || sum(oksessionNum==sessionNum)~=1
    disp('ERROR: input must be 1 or 2 or 3 . Please try again.');
    sessionNum = input('Enter session number (1 if first for this subject): ');
end


% =========================================================================
% set the computer and path
% =========================================================================

test_comp = input('Which computer are you using? 3 Rotem_PC 2 Toms_iMac, 1 MRI, 0 if testooom: ');
while isempty(test_comp) || sum(okComputer==test_comp)~=1
    disp('ERROR: input must be 0,1,2 or 3. Please try again.');
    test_comp = input('Which computer are you using? 3 Rotem_PC, 2 Toms_iMac, 1 MRI, 0 if testooom: ');
end

% Set main path
switch test_comp
    case 0
        mainPath = pwd; % Change when we have the new computer for the behavioral task
    case 1
        mainPath = pwd; % Change when we have the new computer for the fMRI task
    case 2
        mainPath = 'dropbox/trainedInhibition/Boost_Israel';
    case 3
        mainPath = 'D:/Rotem/Matlab/Boost_Israel_New_Rotem';
end % end switch

outputPath = [mainPath '/Output'];


% =========================================================================
% Binary Ranking (including demo) - (Ranking = PART 1)
% =========================================================================
stimuli=2; % define desired stimuli for binary ranking. Choose 1 for snacks, 2 for faces or 3 for fractals.
binary_ranking_demo(subjectID,test_comp,stimuli,mainPath);
binary_ranking(subjectID,test_comp,stimuli,mainPath);

% =========================================================================
% Sort stimuli according to the binary ranking
% =========================================================================
sort_binary_ranking(subjectID,order,outputPath);


% =========================================================================
% Training (including demo) - (Training = PART 2)
% =========================================================================

% Set number of runs
% -------------------------------------------------
total_num_runs_training = 12;
% total_num_runs_training = 4; % for debugging

runInd = 1; % The first run to run with the training function

trainingDemo_Israel(subjectID,order,mainPath,test_comp);

demo_again = input('Do you want more practice? Press 1 if yes, press 0 if no ');
while isempty(demo_again) || sum(demo_again == okDemo) ~= 1
    disp('ERROR: input must be 0 or 1 . Please try again.');
    demo_again = input('Do you want more practice? Press 1 if yes, press 0 if no ');
end

if demo_again == 1
    trainingDemo_Israel(subjectID,order,mainPath,test_comp);
end
Ladder1IN = 750;
Ladder2IN = 750;
training_Israel(subjectID,order,mainPath,test_comp,runInd,total_num_runs_training,Ladder1IN,Ladder2IN);

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

numBlocks = 2; % Define how many blocks for the probe session. Each block includes all comparisons, one time each.
numRunsPerBlock = 2; % Define the required number of runs per block

probeDemo_Israel(subjectID, order, mainPath, test_comp, sessionNum);

demo_again=input('Do you want more practice? Press 1 if yes, press 0 if no ');
while isempty(demo_again) || sum(demo_again==okDemo)~=1
    disp('ERROR: input must be 0 or 1 . Please try again.');
    demo_again=input('Do you want more practice? Press 1 if yes, press 0 if no ');
end

if demo_again==1
    probeDemo_Israel(subjectID, order, mainPath, test_comp, sessionNum);
end

% Run blocks. Before each block, stimuli need to be organized in a list and
% divided to the required number of runs
for ind = 1:numBlocks
    block = (sessionNum-1)*2 + ind;
    % Organize the stimuli for the probe
    % ===================================
    [trialsPerRun] = organizeProbe_Israel(subjectID, order, mainPath, block, numRunsPerBlock);
    for numRun = 1:numRunsPerBlock
        probe_Israel(subjectID, order, mainPath, test_comp, sessionNum, block, numRun, numRunsPerBlock, trialsPerRun);
    end % end for numRun = 1:numRunsPerBlock
end % end for block = 1:numBlocks


%==========================================================
%%   'memory (recognition) task'
%==========================================================

% PART 5
% - - - - - - -
recognitionNewOld_Israel(subjectID, test_comp, mainPath, order, sessionNum);

% PART 6
% - - - - - - -
recognitionGoNoGo_Israel(subjectID, test_comp, order, mainPath, sessionNum);

%==========================================================
%%   'post-task'
%==========================================================

probeResolve_Israel(subjectID, sessionNum, outputPath);

% quit %quits matlab


end % end function





