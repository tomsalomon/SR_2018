function run_boost_Israel_after_crash()

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% =============== Created based on the previous boost codes ===============
% ================ by Rotem Botvinik November-December 2014 ===============
% =================== Modified by Tom Salomon, April 2015 =================
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% Runs the cue-approach task

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % % ---------------- FUNCTIONS REQUIRED TO RUN PROPERLY: ----------------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % %   --- Cue-approach codes: ---
% % %   'binary_ranking'
% % %   'binary_ranking_demo'
% % %   'sort_binary_ranking'
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
% % %   'Onset_files': a folder with the onset files for the training and
% % %    for the probe.
% % %   'Output': the folder for the output files- results.
% % %   'stim': with the image files of all the stimuli for the cue-approach
% % %    task (old stimuli).
% % %   'stim/recognitionNew': with the image files of the new stimuli
% % %   (stimuli that are not included in the cue-approach tasks, only in the
% % %   recognitionNewOld task, as new stimuli).

tic

% =========================================================================
%% Get input args and check if input is ok
% =========================================================================

% %---dummy info for debugging purposes --------
% subjectID =  'BM_001';

fprintf('\nSorry to hear the code had crashed :(')
fprintf('\nPlease remember to keep a record of this incident.\n')
% timestamp
c = clock;
hr = sprintf('%02d', c(4));
min = sprintf('%02d', c(5));
timestamp=[date,'_',hr,'h',min,'m'];

% essential for randomization
rng('shuffle');

% input checkers
subjectID = input('\nSubject code: ','s');
[subjectID_num,okID]=str2num(subjectID(end-2:end));
while okID==0
    disp('ERROR: Subject code must contain 3 characters numeric ending, e.g "BMI_bf_001". Please try again.');
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
fid_crash = fopen([outputPath '/' subjectID '_crashingLogs' num2str(sessionNum) '_' timestamp '.txt'], 'a');

% sessionNum = input('Enter session number (1 if first for this subject): ');
% while isempty(sessionNum) || sum(oksessionNum==sessionNum)~=1
%     disp('ERROR: input must be 1 or 2 or 3 . Please try again.');
%     sessionNum = input('Enter session number (1 if first for this subject): ');
% end

% Define from where to start
OK_Start=1:5;
Start_from=input(['\nFrom which part would you like to start:' ...
    '\n1 - Binary ranking'...
    '\n2 - Training'...
    '\n3 - Probe'...
    '\n4 - Recognition Old-New'...
    '\n5 - Recognition Go-NoGo\n\n'...
    'Selection: ']);

while isempty(Start_from) || sum(OK_Start==Start_from)~=1
    disp('ERROR: input must be a number from 1 to 5 . Please try again.');
    Start_from=input(['\nFrom which part would you like to start:' ...
        '\n1 - Binary ranking'...
        '\n2 - Training'...
        '\n3 - Probe'...
        '\n4 - Recognition Old-New'...
        '\n5 - Recognition Go-NoGo\n\n'...
        'Selection: ']);
end

% =========================================================================
%% Personal Details
% =========================================================================
% personal_details(subjectID, order, outputPath, sessionNum)

% =========================================================================
%% Part 1 - Binary Ranking (including demo)
% =========================================================================
if Start_from<=1
    Crashesd_binary_ranking_demo = 0;
    keepTrying = 1;
    while keepTrying < 10
        try
            binary_ranking_demo(subjectID,test_comp,mainPath);
            
            % Ask if subject wanted another demo
            % ----------------------------------
            demo_again = questdlg('Do you want to run the demo again?','Repeat Demo','Yes','No','No');
            if strcmp(demo_again,'Yes')
                binary_ranking_demo(subjectID,test_comp,mainPath);
            end
            keepTrying = 10;
        catch
            sca;
            Crashesd_binary_ranking_demo = Crashesd_binary_ranking_demo + 1;
            keepTrying = keepTrying + 1;
            disp('CODE HAD CRASHED - BINARY RANKING DEMO!');
        end
    end
    fprintf(fid_crash,'Binary ranking demo crashed:\t %d\n', Crashesd_binary_ranking_demo);
    
    Crashesd_binary_ranking = 0;
    keepTrying = 1;
    while keepTrying < 10
        try
            binary_ranking(subjectID,test_comp,mainPath);
            keepTrying = 10;
        catch
            sca;
            Crashesd_binary_ranking = Crashesd_binary_ranking + 1;
            keepTrying = keepTrying + 1;
            disp('CODE HAD CRASHED - BINARY RANKING!');
        end
    end
    fprintf(fid_crash,'Binary ranking crashed:\t %d\n', Crashesd_binary_ranking);
    
    % Sort stimuli according to the binary ranking
    % -------------------------------------------------
    sort_binary_ranking(subjectID,order,outputPath);
end

% =========================================================================
%% Part 2 - Training (including demo)
% =========================================================================
% Set number of runs
% -------------------------------------------------
if Start_from<=2
    total_num_runs_training = 20;
    % total_num_runs_training = 4; % for debugging
    runInd = 1; % The first run to run with the training function
    
    crashedDemoTraining = 0;
    keepTrying = 1;
    while keepTrying < 10
        try
            trainingDemo_Israel(subjectID,order,mainPath,test_comp);
            
            % Ask if subject wanted another demo
            % ----------------------------------
            demo_again = questdlg('Do you want to run the demo again?','Repeat Demo','Yes','No','No');
            if strcmp(demo_again,'Yes')
                trainingDemo_Israel(subjectID,order,mainPath,test_comp);
            end
            keepTrying = 10;
        catch
            sca;
            crashedDemoTraining = crashedDemoTraining + 1;
            keepTrying = keepTrying + 1;
            disp('CODE HAD CRASHED - TRAINING DEMO!');
        end
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
    fprintf(fid_crash,'training crashed:\t %d\n', crashedTraining);
    
    %==========================================================
    %% Part 3 - Break
    %==========================================================
    
    % Take a brake and relax :)
    end_break=0;
    % questdlg('Now we will take a short break. Please take the time to fill a few questionnaires in the link that will now be opened'... '
    %     ,'part 3','Continue','Continue');
    % WaitSecs(1);
    % internet qesioneer
    % web('https://qtrial2015az1.az1.qualtrics.com/SE/?SID=SV_6A63ur6LHIIoYDP','-browser');
    exp_break = input('Type in "123" when you are ready to continue with the experiment:  ');
    
    if exp_break==123
        end_break=1;
    end
    
    while end_break==0
        fprintf('\n<strong>ERROR: Invalid input.</strong>\n');
        exp_break = input('Type in "123" when you are ready to continue: ');
        if exp_break==123
            end_break=1;
        end
    end
end
%==========================================================
%% Part 4 - probe_demo & probe
%==========================================================

if Start_from<=3
    numBlocks = 2; % Define how many blocks for the probe session. Each block includes all comparisons, one time each.
    numRunsPerBlock = 2; % Define the required number of runs per block
    
    
    crashedDemoProbe = 0;
    keepTrying = 1;
    while keepTrying < 10
        try
            probeDemo_Israel(subjectID, order, mainPath, test_comp);
            
            % Ask if subject wanted another demo
            % ----------------------------------
            demo_again = questdlg('Do you want to run the demo again?','Repeat Demo','Yes','No','No');
            if strcmp(demo_again,'Yes')
                probeDemo_Israel(subjectID, order, mainPath, test_comp);
            end
            keepTrying = 10;
        catch
            sca;
            crashedDemoProbe = crashedDemoProbe + 1;
            keepTrying = keepTrying + 1;
            disp('CODE HAD CRASHED - PROBE DEMO!');
        end
    end
    fprintf(fid_crash,'probe demo crashed:\t %d\n', crashedDemoProbe);
    
    
    % Run blocks. Before each block, stimuli need to be organized in a list and
    % divided to the required number of runs
    for ind = 1:numBlocks
        block = (sessionNum-1)*2 + ind;
        % Organize the stimuli for the probe
        % ===================================
        [trialsPerRun] = organizeProbe_Israel(subjectID, order, mainPath, block, numRunsPerBlock);
        crashedProbe=0;
        for numRun = 1:numRunsPerBlock
            keepTrying = 1;
            while keepTrying < 10
                try
                    probe_Israel(subjectID, order, mainPath, test_comp, sessionNum, block, numRun, numRunsPerBlock, trialsPerRun);
                    keepTrying=10;
                catch
                    sca;
                    keepTrying = keepTrying+1;
                    crashedProbe = crashedProbe + 1;
                    disp('CODE HAD CRASHED - PROBE!');
                end
            end
        end % end for numRun = 1:numRunsPerBlock
    end % end for block = 1:numBlocks
    fprintf(fid_crash,'probe crashed:\t %d\n', crashedProbe);
end
%==========================================================
%% Part 5 - Recognition Old/New
%==========================================================

if Start_from<=4
    crashedRecognitionNewOld = 0;
    keepTrying = 1;
    while keepTrying < 10
        try
            recognitionNewOld_Israel(subjectID, test_comp, mainPath, order, sessionNum);
            keepTrying = 10;
        catch
            sca;
            crashedRecognitionNewOld = crashedRecognitionNewOld + 1;
            keepTrying = keepTrying + 1;
            disp('CODE HAD CRASHED - RECOGNITION NEW OLD!');
        end
    end
    fprintf(fid_crash,'RecognitionNewOld crashed:\t %d\n', crashedRecognitionNewOld);
end
%==========================================================
%% Part 6 - Recognition Go/NoGo
%==========================================================
if Start_from<=5
    crashedRecognitionGoNogo = 0;
    keepTrying = 1;
    while keepTrying < 10
        try
            recognitionGoNoGo_AllStimuli_Israel(subjectID, test_comp, mainPath, order, sessionNum);
            keepTrying = 10;
        catch
            sca;
            crashedRecognitionGoNogo = crashedRecognitionGoNogo + 1;
            keepTrying = keepTrying +1;
            disp('CODE HAD CRASHED - RECOGNITION GO NOGO!');
        end
    end
    fprintf(fid_crash,'RecognitionNewOld crashed:\t %d\n', crashedRecognitionGoNogo);
end
%==========================================================
%%   'post-task'
%==========================================================

fclose(fid_crash);
sca;
WaitSecs(5);
% quit %quits matlab

end % end function
