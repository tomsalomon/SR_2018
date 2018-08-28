function probeResolve_Israel(subjectID, sessionNum, outputPath)

% function probeResolve_Israel(subjectID, sessionNum, outputPath)

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% =============== Created based on the previous boost codes ===============
% ==================== by Rotem Botvinik December 2014 ====================
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

% This function chooses a random trial from the probe and compute the item
% the participant chose on that trial. This is the item the experimenter
% should give to the participant.

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % % --------- Exterior files needed for task to run correctly: ----------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%   ''probe_block_' block '_*.txt'' --> created in the probe session


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % % ------------------- Creates the following files: --------------------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%   ''probe_resolve_session_' num2str(sessionNum) '.txt''


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % ------------------- dummy info for testing purposes -------------------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% subjectID = 'BM_9001';
% sessionNum = 1;
% outputPath = 'D:\Rotem\Matlab\Boost_Israel_New_Rotem\Output'; % Rotem's PC


tic


% Define block number
whichBlock = Shuffle(1:2);
if sessionNum == 1
    block = whichBlock(1);
elseif sessionNum == 2
    block = 2 + whichBlock(1);
elseif sessionNum == 3
    block = 4 + whichBlock(1);
end

% Open data from probe
tmp = dir([outputPath '/' subjectID '_probe_block_' sprintf('%02d',block) '_*.txt']);
fid = fopen([outputPath '/' tmp(length(tmp)).name]); %tmp(length(tmp)).name
probe = textscan(fid, '%s %d %d %s %d %d %d %s %s %d %d %d %s %d %d %.2f %d %d %.2f %.2f', 'Headerlines',1);
fclose(fid);

total_num_trials = length(probe{1});

% Choose a random trial
trial_choice = ceil(rand*total_num_trials);

% Check which items were presented and which one of them was selected
leftpic = probe{7}(trial_choice);
rightpic = probe{8}(trial_choice);
if strcmp(probe{12}(trial_choice),'u')
   choice = leftpic;
else
   choice = rightpic;
end


% save results of probeResolve_Israel
fid2 = fopen([outputPath '/' subjectID '_probe_resolve_session_' num2str(sessionNum) '.txt'],'a');
fprintf(fid2,'%s %s %s %s %s %s %s \n', 'In the choice between', char(leftpic), 'and', char(rightpic), 'you chose', char(choice), '. You receive this item.');
fclose(fid2);
    
end % end function    