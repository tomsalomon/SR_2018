 function run_boost_Israel_new_part1()

% function run_boost_Israel_new_part1()

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% =============== Created based on the previous boost codes ===============
% ================ by Rotem Botvinik May 2015 ===============
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

% This is the first part of the full run_boost_Israel_new function
% Runs the cue-approach task from the BDM sorting to the training and the personal details.
% part 2 starts with the break-filler between training and probe (questionares/ other stimuli ranking)

% The try-catch is because the mac caused an error with opening the screen
% from time to time, so we want to prevent it from failing.

% This version is for running only 40 items in training! 20 runs in the
% training session

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % % ---------------- FUNCTIONS REQUIRED TO RUN PROPERLY: ----------------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % %   --- Cue-approach codes: ---
% % %   'sort_BDM_Israel'
% % %   'trainingDemo_Israel'
% % %   'training_Israel' (if NO EYETRACKING)

% % %   --- Other codes: ---
% % %  'CenterText'


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % % ---------------- FOLDERS REQUIRED TO RUN PROPERLY: ------------------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % %   'Misc': a folder with the audio file.
% % %   'Onset_files': a folder with the onset files for the training and
% % %    for the probe.
% % %   'Output': the folder for the output files- results.
% % %   'Stim': with the bmp files of all the stimuli for the cue-approach
% % %    task (old stimuli).

tic

rng shuffle

% =========================================================================
% Get input args and check if input is ok
% =========================================================================

% %---dummy info for debugging purposes --------
% subjectID =  'test999';
% order = 1;
% test_comp = 4; % 4 newMac 3 Rotem_PC 2 Toms_iMac, 1 MRI, 0 if testooom
% sessionNum = 1;


% get time and date
c = clock;
hr = sprintf('%02d', c(4));
min = sprintf('%02d', c(5));
timestamp = [date,'_',hr,'h',min,'m'];

% input checkers
subjectID = input('Subject code: ','s');
[subjectID_num,okID]=str2num(subjectID(end-2:end));
while okID==0
    disp('ERROR: Subject code must contain 3 characters numeric ending, e.g "BSOV_001". Please try again.');
    subjectID = input('Subject code:','s');
    [subjectID_num,okID]=str2num(subjectID(end-2:end));
end

% Assign order
% --------------------------
% give order value of '1' or '2' for subjects with odd or even ID, respectively
if mod(subjectID_num,2) == 1 % subject code is odd
    order = 1;
else % subject code is even
    order = 2;
end

sessionNum=1;

% set the computer and path
% --------------------------
test_comp=0; % 1 MRI, 0 if testooom
mainPath = pwd; % Change if you don't run from the experimnet folder - not recomended.
outputPath = [mainPath '/Output'];


% open a txt file for crashing logs
fid_crash1 = fopen([outputPath '/' subjectID '_crashingLogs' num2str(sessionNum) '_part1_' timestamp '.txt'], 'a');
% fprintf(fid_crash,'subjectID\torder\ttraining demo\ttraining\tprobe demo\tprobe\trecognition new old\trecognition go no go\n'); % write the header line

% =========================================================================
%% Personal Details
% =========================================================================
personal_details(subjectID, order, outputPath, sessionNum)

% =========================================================================
% Sort stimuli according to the BDM ranking (BDM = PART 1)
% =========================================================================
sort_BDM_Israel(subjectID,order,outputPath);


% =========================================================================
% Training (including demo) - (Training = PART 2)
% =========================================================================

% Set number of runs
% -------------------------------------------------
total_num_runs_training = 20;

% for debugging:
% total_num_runs_training = 4;

runInd = 1; % The first run to run with the training function

crashedDemoTraining = 0;
keepTrying = 1;
while keepTrying < 10
    try
    trainingDemo_Israel(subjectID,order,mainPath,test_comp);
    keepTrying = 10;
    catch
        sca;
        crashedDemoTraining = crashedDemoTraining + 1;
        keepTrying = keepTrying + 1;
        disp('CODE HAD CRASHED - TRAINING DEMO!');
    end
end
fprintf(fid_crash1,'training demo crashed:\t %d\n', crashedDemoTraining);

% Ask if subject wanted another demo
        % ----------------------------------
        demo_again = questdlg('Do you want to run the demo again?','Repeat Demo','Yes','No','No');
        if strcmp(demo_again,'Yes')
            trainingDemo_Israel(subjectID,order,mainPath,test_comp);
        end

Ladder1IN = 750;
Ladder2IN = 750;

crashedTraining = 0;
keepTrying = 1;
while keepTrying < 10
    try
        training_Israel(subjectID,order,mainPath,test_comp,runInd,total_num_runs_training,Ladder1IN,Ladder2IN);
        keepTrying = 10;
    catch
        sca;
        crashedTraining = crashedTraining + 1;
        keepTrying = keepTrying + 1;
        disp('CODE HAD CRASHED - TRAINING!');
    end
end
fprintf(fid_crash1,'training crashed:\t %d\n', crashedTraining);

%==========================================================
%%   'Part 3 - Fractals - liking'
%==========================================================
% Part 4
% This part is used to give a break between the training and probe, to
% allow consolidation (atleast partly).
% This part is used to get data regarding subjects' liking of other stimuli
% for the other experiments, such as faces / fractals.

% the code of this part runs on pygame (python).



fclose(fid_crash1);

end % end function

