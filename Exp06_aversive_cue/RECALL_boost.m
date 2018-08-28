function RECALL_boost_visual_only()

% function RECALL_boost_visual_only()

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% =============== Created based on the previous boost codes ===============
% ================ by Rotem Botvinik May 2015 ===============
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

% This is the second part of the full run_boost_Israel_new function
% Runs the cue-approach task, after the break between the training and the
% probe (with questionares/ other stimuli ranking)
% from the probe session to the recognition tasks.

% The try-catch is because the mac caused an error with opening the screen
% from time to time, so we want to prevent it from failing.

% This version is for running only 40 items in training! 20 runs in the
% training session

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % % ---------------- FUNCTIONS REQUIRED TO RUN PROPERLY: ----------------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % %   --- Cue-approach codes: ---
% % %   'organizeProbe_Israel'
% % %   'probeDemo_Israel'
% % %   'probe_Israel'
% % %   'probeResolve_Israel'
% % %   'BDMresolve_Israel'
% % %   'recognitionNewOld_Israel'
% % %   'recognitionGoNoGo_Israel'

% % %   --- Other codes: ---
% % %  'CenterText'


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % % ---------------- FOLDERS REQUIRED TO RUN PROPERLY: ------------------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % %   'Onset_files': a folderwith the onset files for the training and
% % %    for the probe.
% % %   'Output': the folder for the output files- results.
% % %   'Stim': with the bmp files of all the stimuli for the cue-approach
% % %    task (old stimuli).
% % %   'Stim\recognitionNew': with the bmp files of the new stimuli
% % %   (stimuli that are not included in the cue-approach tasks, only in the
% % %   recognitionNewOld task, as new stimuli).

tic

rng shuffle

% =========================================================================
% Get input args and check if input is ok
% =========================================================================

% %---dummy info for debugging purposes --------
% subjectID = 'test999';
% order = 1;
% test_comp = 4; % 4 new Mac % 3 Rotem_PC 2 Toms_iMac, 1 MRI, 0 if testooom
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

sessionNum=2;

% set the computer and path
% --------------------------
test_comp=0; % 1 MRI, 0 if testooom
mainPath = pwd; % Change if you don't run from the experimnet folder - not recomended.
outputPath = [mainPath '/Output'];

% open a txt file for crashing logs
fid_crash2 = fopen([outputPath '/' subjectID '_crashingLogs' num2str(sessionNum) '_part2_' timestamp '.txt'], 'a');
% fprintf(fid_crash,'subjectID\torder\ttraining demo\ttraining\tprobe demo\tprobe\trecognition new old\trecognition go no go\n'); % write the header line


%==========================================================
%%   'Part 4 - probe_demo & probe'
%==========================================================

numBlocks = 2; % Define how many blocks for the probe session. Each block includes all comparisons, one time each.
numRunsPerBlock = 1; % Define the required number of runs per block
% This is the version with only 76 comparisons (36 HV GO-NOGO; 36 LV
% GO-NOGO; 4 sanity NOGO), so the block should not be divided into runs

crashedDemoProbe = 0;
keepTrying = 1;
while keepTrying < 10
    try
        probeDemo_Israel(subjectID, order, mainPath, test_comp, sessionNum);
        keepTrying = 10;
    catch
        sca;
        crashedDemoProbe = crashedDemoProbe + 1;
        keepTrying = keepTrying + 1;
        disp('CODE HAD CRASHED - PROBE DEMO!');
    end
end
fprintf(fid_crash2,'probe demo crashed:\t %d\n', crashedDemoProbe);

% Ask if subject wanted another demo
        % ----------------------------------
        demo_again = questdlg('Do you want to run the demo again?','Repeat Demo','Yes','No','No');
        if strcmp(demo_again,'Yes')
           probeDemo_Israel(subjectID, order, mainPath, test_comp, sessionNum);
        end

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
                keepTrying=10;
            catch
                sca;
                keepTrying = keepTrying+1;
                crashedProbe = crashedProbe + 1;
                disp('CODE HAD CRASHED - PROBE!');
            end
        end
        fprintf(fid_crash2,'probe crashed:\t %d\n', crashedProbe);
    end % end for numRun = 1:numRunsPerBlock
end % end for block = 1:numBlocks

%==========================================================
%%   'Part 5 - memory recognition + demo - confidence task - old/new & go/nogo'
%==========================================================

% Recognition Demo
% - - - - - - -
crashedRecognition_confidence_demo = 0;
keepTrying = 1;
while keepTrying < 10
    try
    recognition_confidence_demo(test_comp,mainPath);
    keepTrying = 10;
    catch
        sca;
        crashedRecognition_confidence_demo = crashedRecognition_confidence_demo + 1;
        keepTrying = keepTrying + 1;
        disp('CODE HAD CRASHED - RECOGNITION DEMO!');
    end
end
fprintf(fid_crash2,'Recognition_confidence_demo crashed:\t %d\n', crashedRecognition_confidence_demo);

% Recognition
% - - - - - - -
crashedRecognition_confidence = 0;
keepTrying = 1;
while keepTrying < 10
    try
    recognition_confidence(subjectID,test_comp,mainPath,order, sessionNum);
    keepTrying = 10;
    catch
        sca;
        crashedRecognition_confidence = crashedRecognition_confidence + 1;
        keepTrying = keepTrying +1;
        disp('CODE HAD CRASHED - RECOGNITION GO NOGO!');
    end
end
fprintf(fid_crash2,'Recognition_confidence crashed:\t %d\n', crashedRecognition_confidence);

%==========================================================
%%   'post-task'
%==========================================================

probeResolve_Israel(subjectID, sessionNum, outputPath, numBlocks);

fclose(fid_crash2);

% quit %quits matlab


end % end function





