function [trialsPerRun] = organizeProbe_Israel_old_ver(subjectID, order, mainPath, block, numRunsPerBlock)

% function [trialsPerRun] = organizeProbe_Israel(subjectID, order, mainPath, block, numRunsPerBlock)
%
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% =============== Created based on the previous boost codes ===============
% ==================== by Rotem Botvinik December 2014 ====================
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

% This function organizes the matrices for each block of the probe session of the boost
% (cue-approach) task, divided to number of runs as requested (1 or 2 would
% work)


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % % --------- Exterior files needed for task to run correctly: ----------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%   ''stopGoList_allstim_order*.txt'' --> created by sortBDM_Israel


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % % ------------------- Creates the following files: --------------------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%   'stimuliForProbe_order%d_block_%d_run%d.txt'


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % ------------------- dummy info for testing purposes -------------------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% subjectID =  'BM_9001';
% order = 1;
% test_comp = 3;
% mainPath = 'D:\Rotem\Matlab\Boost_Israel_New_Rotem';
% numRunsPerBlock = 2;
% block = 1;


tic

%==============================================
%% 'GLOBAL VARIABLES'
%==============================================

outputPath = [mainPath '\Output'];

% essential for randomization
rng('shuffle');

%==============================================
%% 'Read in data'
%==============================================

%   'read in sorted file'
% - - - - - - - - - - - - - - - - -

file = dir([mainPath '\Output\' subjectID '_stopGoList_allstim_order*']);
fid = fopen([mainPath '\Output\' sprintf(file(length(file)).name)]);
data = textscan(fid, '%s %d %d %f %d') ;% these contain everything from the sortbdm
stimName = data{1};
% bidIndex = data{3};
% bidValue = data{4};
fclose(fid);

%==============================================
%%   'DATA ORGANIZATION'
%==============================================

% determine stimuli to use based on order number
%-----------------------------------------------------------------
switch order
    case 1
        %   comparisons of interest
        % - - - - - - - - - - - - - - -
        HV_beep = [7 10 12 13 15 18 20 21]; %HV_beep
        HV_nobeep = [8 9 11 14 16 17 19 22]; %HV_nobeep
        
        LV_beep = [39 42 44 45 47 50 52 53]; %LV_beep
        LV_nobeep = [40 41 43 46 48 49 51 54]; %LV_nobeep
        
        
        %   sanity check comparisons
        % - - - - - - - - - - - - - - -
        sanityHV_beep = [24 25]; %HV_beep
        sanityLV_beep = [36 37]; %LV_beep
        
        
        sanityHV_nobeep = [23 26]; %HV_nobeep
        sanityLV_nobeep = [35 38]; %LV_nobeep
        
    case 2
        
        %   comparisons of interest
        % - - - - - - - - - - - - - - -
        HV_beep = [8 9 11 14 16 17 19 22]; %HV_beep
        HV_nobeep = [7 10 12 13 15 18 20 21]; %HV_nobeep
        
        
        LV_beep = [40 41 43 46 48 49 51 54]; %LV_beep
        LV_nobeep = [39 42 44 45 47 50 52 53]; %LV_nobeep
        
        
        
        %   sanity check comparisons
        % - - - - - - - - - - - - - - -
        sanityHV_beep = [23 26]; %HV_beep
        sanityLV_beep = [35 38]; %LV_beep
        
        
        sanityHV_nobeep = [24 25]; %HV_nobeep
        sanityLV_nobeep = [36 37]; %LV_nobeep
        
end % end switch order


%   add multiple iterations of each item presentation
%-----------------------------------------------------


%   TRIAL TYPE 1: HighValue Go vs. HighValue NoGo(Stop)
% - - - - - - - - - - - - - - - - - - - - - - - - - - -
HV_beep_new = length(HV_beep)^2;
HV_nobeep_new = length(HV_beep)^2;
for i = 1:8
    for j = 1:8
        HV_beep_new(j+(i-1)*8) = HV_beep(i);
        HV_nobeep_new(j+(i-1)*8) = HV_nobeep(j);
    end
end
[shuffle_HV_beep_new,shuff_HV_beep_new_ind] = Shuffle(HV_beep_new);
shuffle_HV_nobeep_new = HV_nobeep_new(shuff_HV_beep_new_ind);



%   TRIAL TYPE 2: LowValue Go vs. LowValue NoGo(Stop)
% - - - - - - - - - - - - - - - - - - - - - - - - - - -
LV_beep_new = length(LV_beep)^2;
LV_nobeep_new = length(LV_nobeep)^2;
for i = 1:8
    for j = 1:8
        LV_beep_new(j+(i-1)*8) = LV_beep(i);
        LV_nobeep_new(j+(i-1)*8) = LV_nobeep(j);
    end
end
[shuffle_LV_beep_new,shuff_LV_beep_new_ind] = Shuffle(LV_beep_new);
shuffle_LV_nobeep_new = LV_nobeep_new(shuff_LV_beep_new_ind);


%   TRIAL TYPE 3: HighValue Go vs. LowValue Go
% - - - - - - - - - - - - - - - - - - - - - - - - - - -
sanityHV_beep_new = length(sanityHV_beep)^2;
sanityLV_beep_new = length(sanityLV_beep)^2;
for i=1:2
    for j=1:2
        sanityHV_beep_new(j+(i-1)*2) = sanityHV_beep(i);
        sanityLV_beep_new(j+(i-1)*2) = sanityLV_beep(j);
    end
end
[shuffle_sanityHV_beep_new,shuff_sanityHV_beep_new_ind] = Shuffle(sanityHV_beep_new);
shuffle_sanityLV_beep_new = sanityLV_beep_new(shuff_sanityHV_beep_new_ind);



%   TRIAL TYPE 4: HighValue NoGo(Stop) vs. LowValue NoGo(Stop)
% - - - - - - - - - - - - - - - - - - - - - - - - - - -
sanityHV_nobeep_new = length(sanityHV_nobeep)^2;
sanityLV_nobeep_new = length(sanityLV_nobeep)^2;
for i = 1:2
    for j = 1:2
        sanityHV_nobeep_new(j+(i-1)*2) = sanityHV_nobeep(i);
        sanityLV_nobeep_new(j+(i-1)*2) = sanityLV_nobeep(j);
    end
end
[shuffle_sanityHV_nobeep_new,shuff_sanityHV_nobeep_new_ind] = Shuffle(sanityHV_nobeep_new);
shuffle_sanityLV_nobeep_new = sanityLV_nobeep_new(shuff_sanityHV_nobeep_new_ind);


%   randomize all possible comparisons for all trial types
%-----------------------------------------------------------------
numComparisons = length(HV_beep)^2;
numSanity = length(sanityHV_beep)^2;
total_num_trials = numComparisons*2+numSanity*2;
trialsPerRun = total_num_trials/numRunsPerBlock;

stimnum1 = zeros(numRunsPerBlock,trialsPerRun);
stimnum2 = zeros(numRunsPerBlock,trialsPerRun);
leftname = cell(numRunsPerBlock,trialsPerRun);
rightname = cell(numRunsPerBlock,trialsPerRun);
pairType = zeros(numRunsPerBlock,trialsPerRun);


numComparisonsPerRun = numComparisons/numRunsPerBlock;
numSanityPerRun = numSanity/numRunsPerBlock;
pairType(1:numRunsPerBlock,1:numComparisonsPerRun) = 1;
pairType(1:numRunsPerBlock,numComparisonsPerRun+1:numComparisonsPerRun*2) = 2;
pairType(1:numRunsPerBlock,numComparisonsPerRun*2+1:numComparisonsPerRun*2+numSanityPerRun) = 3;
pairType(1:numRunsPerBlock,numComparisonsPerRun*2+numSanityPerRun+1:numComparisonsPerRun*2+numSanityPerRun*2) = 4;


leftGo = ones(2,total_num_trials/2);
for loc = 1:numComparisons:numComparisons*2
    leftGo(loc:loc-1+numComparisons/2) = 0;
end % end for loc = 1:numComparisons:numComparisons*2

for loc = 1+2*numComparisons:numSanity:numComparisons*2+numSanity*2
    leftGo(loc:loc-1+numSanity/2) = 0;
end % end for loc = 1+2*numComparisons:numSanity:numComparisons*2+numSanity*2

for numRun = 1:numRunsPerBlock
    pairType(numRun,:) = Shuffle(pairType(numRun,:));
    leftGo(numRun,:) = Shuffle(leftGo(numRun,:));
end % end for numRun = 1:numRunsPerBlock

HV_beep = shuffle_HV_beep_new;
HV_nobeep = shuffle_HV_nobeep_new;
LV_beep = shuffle_LV_beep_new;
LV_nobeep = shuffle_LV_nobeep_new;

sanityHV_nobeep = shuffle_sanityHV_nobeep_new;
sanityLV_nobeep = shuffle_sanityLV_nobeep_new;
sanityLV_beep = shuffle_sanityLV_beep_new;
sanityHV_beep = shuffle_sanityHV_beep_new;

% Divide the matrices of each comparison to the number of trials
HV_beep_allRuns = zeros(numRunsPerBlock,numComparisonsPerRun);
HV_nobeep_allRuns = zeros(numRunsPerBlock,numComparisonsPerRun);
LV_beep_allRuns = zeros(numRunsPerBlock,numComparisonsPerRun);
LV_nobeep_allRuns = zeros(numRunsPerBlock,numComparisonsPerRun);
sanityHV_nobeep_allRuns = zeros(numRunsPerBlock,numSanityPerRun);
sanityLV_nobeep_allRuns = zeros(numRunsPerBlock,numSanityPerRun);
sanityHV_beep_allRuns = zeros(numRunsPerBlock,numSanityPerRun);
sanityLV_beep_allRuns = zeros(numRunsPerBlock,numSanityPerRun);

for runNum = 1:numRunsPerBlock
    HV_beep_allRuns(runNum,:) = HV_beep(1+((runNum-1)*numComparisonsPerRun):runNum*numComparisonsPerRun);
    HV_nobeep_allRuns(runNum,:) = HV_nobeep(1+((runNum-1)*numComparisonsPerRun):runNum*numComparisonsPerRun);
    LV_beep_allRuns(runNum,:) = LV_beep(1+((runNum-1)*numComparisonsPerRun):runNum*numComparisonsPerRun);
    LV_nobeep_allRuns(runNum,:) = LV_nobeep(1+((runNum-1)*numComparisonsPerRun):runNum*numComparisonsPerRun);
    sanityHV_nobeep_allRuns(runNum,:) = sanityHV_nobeep(1+((runNum-1)*numSanityPerRun):runNum*numSanityPerRun);
    sanityLV_nobeep_allRuns(runNum,:) = sanityLV_nobeep(1+((runNum-1)*numSanityPerRun):runNum*numSanityPerRun);
    sanityHV_beep_allRuns(runNum,:) = sanityHV_beep(1+((runNum-1)*numSanityPerRun):runNum*numSanityPerRun);
    sanityLV_beep_allRuns(runNum,:) = sanityLV_beep(1+((runNum-1)*numSanityPerRun):runNum*numSanityPerRun);
end % end for runNum = 1:numRunsPerBlock

HH = 1;
LL = 1;
HL_S = 1;
HL_G = 1;

for numRun = 1:numRunsPerBlock

    % Create stimuliForProbe.txt for this run
    fid1 = fopen([outputPath '\' sprintf('%s_stimuliForProbe_order%d_block_%d_run%d.txt',subjectID,order,block,numRun)], 'w');
    
    for trial = 1:trialsPerRun % trial num within block      
        switch pairType(numRun,trial)
            case 1

                % HighValue Go vs. HighValue NoGo(Stop)
                % - - - - - - - - - - - - - - - - - - -
                
                stimnum1(numRun,trial) = HV_beep(HH);
                stimnum2(numRun,trial) = HV_nobeep(HH);
                HH = HH+1;
                if leftGo(numRun,trial) == 1
                    leftname(numRun,trial) = stimName(stimnum1(numRun,trial));
                    rightname(numRun,trial) = stimName(stimnum2(numRun,trial));
                else
                    leftname(numRun,trial) = stimName(stimnum2(numRun,trial));
                    rightname(numRun,trial) = stimName(stimnum1(numRun,trial));
                end
                
            case 2
                
                % LowValue Go vs. LowValue NoGo(Stop)
                % - - - - - - - - - - - - - - - - - - -
                
                stimnum1(numRun,trial) = LV_beep(LL);
                stimnum2(numRun,trial) = LV_nobeep(LL);
                LL = LL+1;
                if leftGo(numRun,trial) == 1
                    leftname(numRun,trial) = stimName(stimnum1(numRun,trial));
                    rightname(numRun,trial) = stimName(stimnum2(numRun,trial));
                else
                    leftname(numRun,trial) = stimName(stimnum2(numRun,trial));
                    rightname(numRun,trial) = stimName(stimnum1(numRun,trial));
                end
                
            case 3
                
                % HighValue Go(Stop) vs. LowValue Go(Stop)
                % - - - - - - - - - - - - - - - - - - -
                
                stimnum1(numRun,trial) = sanityHV_beep(HL_S);
                stimnum2(numRun,trial) = sanityLV_beep(HL_S);
                HL_S = HL_S+1;
                if leftGo(numRun,trial) == 1
                    leftname(numRun,trial) = stimName(stimnum1(numRun,trial));
                    rightname(numRun,trial) = stimName(stimnum2(numRun,trial));
                else
                    leftname(numRun,trial) = stimName(stimnum2(numRun,trial));
                    rightname(numRun,trial) = stimName(stimnum1(numRun,trial));
                end
                
            case 4
                
                % HighValue NoGo vs. LowValue NoGo
                % - - - - - - - - - - - - - - - - - - -
                
                stimnum1(numRun,trial) = sanityHV_nobeep(HL_G);
                stimnum2(numRun,trial) = sanityLV_nobeep(HL_G);
                HL_G = HL_G+1;
                if leftGo(numRun,trial) == 1
                    leftname(numRun,trial) = stimName(stimnum1(numRun,trial));
                    rightname(numRun,trial) = stimName(stimnum2(numRun,trial));
                else
                    leftname(numRun,trial) = stimName(stimnum2(numRun,trial));
                    rightname(numRun,trial) = stimName(stimnum1(numRun,trial));
                end
                
        end % end switch pairtype

        fprintf(fid1, '%d\t %d\t %d\t %d\t %s\t %s\t \n', stimnum1(numRun,trial),stimnum2(numRun,trial),leftGo(numRun,trial),pairType(numRun,trial),leftname{numRun,trial},rightname{numRun,trial});
    end % end for trial = 1:total_num_trials
    
    fprintf(fid1, '\n');
    fclose(fid1);
end % end for numRun = 1:numRunsPerBlocks


%---------------------------------------------------------------------
% create a data structure with info about the run and all the matrices
%---------------------------------------------------------------------
outfile = strcat(outputPath,'\', sprintf('%s_stimuliForProbe_order%d_block_%d_%d_trials_%d_runs_%s.mat',subjectID,order,block,total_num_trials,numRunsPerBlock,date));

% create a data structure with info about the run
run_info.subject = subjectID;
run_info.date = date;
run_info.outfile = outfile;
run_info.script_name = mfilename;

save(outfile);


end % end function

