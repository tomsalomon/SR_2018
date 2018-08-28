function run_boost_Israel()

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% =============== Created based on the previous boost codes ===============
% ================ by Rotem Botvinik November-December 2014 ===============
% =================== Modified by Tom Salomon, April 2015 =================
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% Runs the cue-approach task
% Recall for fractal experimnet's subjects - July 2015

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

% timestamp
c = clock;
hr = sprintf('%02d', c(4));
min = sprintf('%02d', c(5));
timestamp=[date,'_',hr,'h',min,'m'];

% essential for randomization
rng('shuffle');

% input checkers
subjectID = input('Subject code: ','s');
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

sessionNum=2;

% set the computer and path
% --------------------------
test_comp=0; % 1 MRI, 0 if testooom
mainPath = pwd; % Change if you don't run from the experimnet folder - not recomended.
outputPath = [mainPath '/Output'];

% open a txt file for crashing logs
fid_crash = fopen([outputPath '/' subjectID '_crashingLogs' num2str(sessionNum) '_part1_' timestamp '.txt'], 'a');

% =========================================================================
%% Personal Details
% =========================================================================
personal_details(subjectID, order, outputPath, sessionNum)

%==========================================================
%% Part 4 - probe_demo & probe
%==========================================================

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
    crashedProbe = 0;
    for numRun = 1:numRunsPerBlock
        keepTrying = 1;
        while keepTrying < 10
            try
                probe_Israel(subjectID, order, mainPath, test_comp, sessionNum, block, numRun, numRunsPerBlock, trialsPerRun);
                sca;
                keepTrying =10;
            catch
                sca;
                keepTrying = keepTrying+1;
                crashedProbe = crashedProbe + 1;
                disp('CODE HAD CRASHED - PROBE!');
            end
        end
        fprintf(fid_crash,'Probe crashed:\t %d\n', crashedProbe);
    end % end for numRun = 1:numRunsPerBlock
    
%     for numRun = 1:numRunsPerBlock
%                 probe_Israel(subjectID, order, mainPath, test_comp, sessionNum, block, numRun, numRunsPerBlock, trialsPerRun);
%     end % end for numRun = 1:numRunsPerBlock
end % end for block = 1:numBlocks


%==========================================================
%% Part 5 - Recognition Old/New
%==========================================================

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

%==========================================================
%% Part 6 - Recognition Go/NoGo
%==========================================================
crashedRecognitionGoNogo = 0;
keepTrying = 1;
while keepTrying < 10
    try
        recognitionGoNoGo_Israel(subjectID, test_comp, mainPath, order, sessionNum);
        keepTrying = 10;
    catch
        sca;
        crashedRecognitionGoNogo = crashedRecognitionGoNogo + 1;
        keepTrying = keepTrying +1;
        disp('CODE HAD CRASHED - RECOGNITION GO NOGO!');
    end
end
fprintf(fid_crash,'RecognitionNewOld crashed:\t %d\n', crashedRecognitionGoNogo);

%==========================================================
%%   'post-task'
%==========================================================

fclose(fid_crash);
WaitSecs(5);
quit %quits matlab

end % end function
