function recognitionNewOld_Israel(subjectID,test_comp,mainPath,order, sessionNum, xlsfilename)

% function recognitionNewOld_Israel(subjectID,test_comp,mainPath,order, sessionNum, xlsfilename)

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% =============== Created based on the previous boost codes ===============
% ==================== by Rotem Botvinik December 2014 ====================
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

% This function runs the first part of the memory (recognition) session of the
% boost (cue-approach) task.
% Subjects are presented with all the stimuli from the previous sessions,
% as well as some items that were not included in the training session, in a random order, and
% should answer whether they recognize each stimuli from the previous
% sessions or not.
% In the next memory (recognition) session, run by the
% 'recognitionGoNoGo_Israel' function, they are presented with the items
% they said were present during the training session, and are asked whether
% each item was paired with a beep (GO item) or not (NOGO item).

% Old stimuli should be located in the folder [mainPath'/stim/']
% New stimuli should be located in the folder [mainPath'/stim/recognitionNew/']


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % % --------- Exterior files needed for task to run correctly: ----------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%   'stopGoList_allstim_order%d.txt', order --> Created by the 'sortBdm_Israel' function


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % % ------------------- Creates the following files: --------------------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%   ''recognitionNewOld_results' num2str(sessionNum) '_' timestamp '.txt''
%   --> Which includes the variables: trialNum (in the newOld recognition task), index
%   of the item (ABC order, old and than new), name of item, whether the item
%   is old (1) or not (0), the subject's answer (0- not included; 1-
%   included)

%   ''recognitionNewOld' num2str(sessionNum) '_' timestamp '.txt''

%   Results are also saved to the xls file created in the main
%   'run_boost_Israel_new' function:
%   ''recognition_results' num2str(sessionNum) '_' timestamp'


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % ------------------- dummy info for testing purposes -------------------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% subjectID = 'BM_9001';
% order = 1;
% test_comp = 3;
% sessionNum = 1;
% mainPath = 'D:\Rotem\Matlab\Boost_Israel_New_Rotem';


tic


%==========================================================
%% 'INITIALIZE Screen variables to be used in each task'
%==========================================================


Screen('Preference', 'VisualDebuglevel', 3); %No PTB intro screen
screennum = max(Screen('Screens'));

pixelSize = 32;
% [w] = Screen('OpenWindow',screennum,[],[0 0 640 480],pixelSize);% %debugging screensize
[w] = Screen('OpenWindow',screennum,[],[],pixelSize);

% % Here Be Colors
black = BlackIndex(w); % Should equal 0.
white = WhiteIndex(w); % Should equal 255.
green = [0 255 0];

Screen('FillRect', w, black);  % NB: only need to do this once!
Screen('Flip', w);

% set up screen positions for stimuli
[wWidth, wHeight] = Screen('WindowSize', w);
xcenter = wWidth/2;
ycenter = wHeight/2;


% text settings
theFont = 'Arial';
Screen('TextFont',w,theFont);
Screen('TextSize',w, 40);

%---------------------------------------------------------------
%% 'GLOBAL VARIABLES'
%---------------------------------------------------------------
c = clock;
hr = sprintf('%02d', c(4));
min = sprintf('%02d', c(5));
timestamp = [date,'_',hr,'h',min,'m'];

outputPath = [mainPath '/Output'];

%---------------------------------------------------------------
%% 'Assign response keys'
%---------------------------------------------------------------
KbName('UnifyKeyNames');

if test_comp == 1
    leftresp = 'b';
    rightresp = 'g';
    %     badresp = 'x';
else
    leftresp = 'u';
    rightresp = 'i';
    %     badresp = 'x';
end

%---------------------------------------------------------------
%% 'LOAD image arrays'
%---------------------------------------------------------------

food_images_old = dir([mainPath '/stim/*.bmp']); % Read old stimuli
food_images_new = dir([mainPath '/stim/recognitionNew/*.bmp']); % Read new stimuli
% food_images = dir([mainPath '/stim/recognition/*.bmp']); % This line is
% good if you put all stimuli, both old and new, in the same folder
% (stim/recognition)

% Read old images to a cell array
imgArraysOld = cell(1,length(food_images_old));
for i = 1:length(food_images_old)
    imgArraysOld{i} = imread([mainPath '/stim/' food_images_old(i).name],'bmp');
end
Old = ones(length(food_images_old),1);

% Read new images to a cell array
imgArraysNew = cell(1,length(food_images_new));
for i = 1:length(food_images_new)
    imgArraysNew{i} = imread([mainPath '/stim/recognitionNew/' food_images_new(i).name],'bmp');
end
New = zeros(length(food_images_new),1);

isOld = [Old; New]; % Create an array indicating whether an item is old (1) or not (0)

% Merge the old and new lists, and shuffle them
food_images = [food_images_old; food_images_new];
[shuffledlist, shuffledlistInd] = Shuffle(food_images);
imgArrays = [imgArraysOld imgArraysNew];
imgArrays = imgArrays(shuffledlistInd);
shuffledIsOld = isOld(shuffledlistInd);


% r=Shuffle(1:4);
% onsetlist=load(['Onset_files/sweet_salty_onset_' num2str(r(1)) '.mat']);
% onsetlist=onsetlist.onsetlist;

% ListenChar(2); % suppresses terminal ouput

%---------------------------------------------------------------
%% 'READ data about the stimuli- Go / NoGo
%---------------------------------------------------------------

%   'Reading in the sorted BDM list - defines which items will be GO/NOGO'
% - - - - - - - - - - - - - - -
file = dir([outputPath '/' subjectID sprintf('_stopGoList_allstim_order%d.txt', order)]);
fid = fopen([outputPath '/' sprintf(file(length(file)).name)]);
vars = textscan(fid, '%s %d %d %f %d') ;% these contain everything from the sortbdm
fclose(fid);

allStimName = vars{1};
goNoGo = vars{2};
isBeep = zeros(length(goNoGo),1);
isBeep(goNoGo == 11 | goNoGo == 22) = 1;
bidInd = vars{3};
% bidValue = vars{4};
[~, indSortedAllStimName] = sort(allStimName);

% Add zeros for the goNoGo, isBeep, bidInd and bidValue of the new items
% - - - - - - - - - - - - - - -

% sortedGoNoGo = goNoGo(indSortedAllStimName);
% sortedGoNoGo(length(food_images_old)+1:length(food_images_old)+length(food_images_new)) = 0;
% shuffledSortedGoNoGo = sortedGoNoGo(shuffledlistInd);

sortedIsBeep = isBeep(indSortedAllStimName);
sortedIsBeep(length(food_images_old)+1:length(food_images_old)+length(food_images_new)) = 0;
shuffledSortedIsBeep = sortedIsBeep(shuffledlistInd);

sortedBidInd = bidInd(indSortedAllStimName);
sortedBidInd(length(food_images_old)+1:length(food_images_old)+length(food_images_new)) = 0;
shuffledSortedBidInd = sortedBidInd(shuffledlistInd);

% sortedBidValue = bidValue(indSortedAllStimName);
% sortedBidValue(length(food_images_old)+1:length(food_images_old)+length(food_images_new)) = 0;
% shuffledSortedBidValue = sortedBidValue(shuffledlistInd);

% % Add the names of the new stimuli to allStimName
% for newStimInd = 1:length(food_images_new)
%     sortedAllStimName{length(food_images_old)+newStimInd} = food_images_new(newStimInd).name;
% end
% shuffledSortedAllStimName = sortedAllStimName(shuffledlistInd);

%---------------------------------------------------------------
%% 'Write output file header'
%---------------------------------------------------------------

fid1 = fopen([outputPath '/' subjectID '_recognitionNewOld' num2str(sessionNum) '_' timestamp '.txt'], 'a');
fprintf(fid1,'subjectID order itemIndABC runtrial isOld? subjectAnswer onsettime Name resp_choice RT bidInd isBeep? \n'); %write the header line
% Open txt file to write the subject's answers (included/not included)
fid2 = fopen([outputPath '/' subjectID '_recognitionNewOld_results' num2str(sessionNum) '_' timestamp '.txt'], 'a');

%---------------------------------------------------------------
%% 'Display Main Instructions'
%---------------------------------------------------------------

Screen('TextSize',w, 40);
if sessionNum == 1
    CenterText(w,'Part 5:',white, 0,-450);
else
    CenterText(w,'PART 3:', white,0,-450);
end

CenterText(w,'Please think back to the task you completed with the beeps.',white, 0, -300);
CenterText(w,'You will NOT hear any beeps during this part of the experiment.',white, 0, -200);

if order==1
    CenterText(w,'Press `u` if this item WAS included in that task.', white,0,-50);
    CenterText(w,'Press `i` if this item WAS NOT included in that task.', white, 0,50);
    
else
    CenterText(w,'Press `u` if this item WAS NOT included in that task.', white,0,-50);
    CenterText(w,'Press `i` if this item WAS included in that task.', white, 0,50);
end

CenterText(w,'Please press any key to continue.', green,0,300);
% HideCursor; % Make a comment in debugging mode
Screen('Flip', w);

if test_comp == 1
    CenterText(w,'GET READY!', white, 0, 0);
    Screen('Flip',w);
    escapeKey = KbName('space');
    while 1
        [keyIsDown,~,keyCode] = KbCheck(-1);
        if keyIsDown && keyCode(escapeKey)
            break;
        end
    end
else
    noresp = 1;
    while noresp,
        [keyIsDown] = KbCheck(-1); % deviceNumber=keyboard
        if keyIsDown && noresp,
            noresp = 0;
        end;
    end
end; % end if test_comp == 1

WaitSecs(0.001);
% anchor = GetSecs;

Screen('TextSize',w, 60);
Screen('DrawText', w, '+', xcenter, ycenter, white);
Screen(w,'Flip');
WaitSecs(1);

KbQueueCreate;

%---------------------------------------------------------------
%% 'Run Trials'
%---------------------------------------------------------------
Included = zeros(1, length(food_images)); % An array for the results. 1 represent items that the subject said were present
xlsheet = 'Recognition';

runStart = GetSecs;

% for trial = 1:6 % for debugging
for trial = 1:length(food_images)
    
    colorright = white;
    colorleft = white;
    
    %-----------------------------------------------------------------
    % display image
    % self-paced; next image will only show after response
    
    Screen('PutImage',w, imgArrays{trial});
    Screen('TextSize',w, 40);
    
    %     if order==1
    %         Screen('DrawText', w, 'Included', xcenter-350,ycenter+300, white);
    %         Screen('DrawText', w, 'Not included', xcenter+120, ycenter+300, white);
    %     else
    %         Screen('DrawText', w, 'Not included', xcenter-350, ycenter+300, white);
    %         Screen('DrawText', w, 'Included', xcenter+120, ycenter+300, white);
    %     end
    
    if order==1
        CenterText(w,'u - included',colorleft,-250,300);
        CenterText(w,'i - not included',colorright,250,300);
    else
        CenterText(w,'u - not included',colorleft,-250,300);
        CenterText(w,'i - included',colorright,250,300);
    end
    
    Screen(w,'Flip');
    StimOnset = GetSecs;
    
    KbQueueStart;
    %-----------------------------------------------------------------
    % get response
    
    
    noresp = 1;
    while noresp
        % check for response
        [keyIsDown, firstPress] = KbQueueCheck(-1);
        
        if keyIsDown && noresp
            findfirstPress = find(firstPress);
            respTime = firstPress(findfirstPress(1))-StimOnset;
            tmp = KbName(findfirstPress);
            if ischar(tmp)==0 % if 2 keys are hit at once, they become a cell, not a char. we need keyPressed to be a char, so this converts it and takes the first key pressed
                tmp = char(tmp);
            end
            response = tmp(1);
            noresp = 0;
            
        end % end if keyIsDown && noresp
        
    end % end while noresp
    
    
    
    %-----------------------------------------------------------------
    
    % determine what bid to highlight and write the subject's response to
    % the Included array
    if order ==1
        switch response
            case leftresp
                colorleft = green;
                Included(trial) = 1;
            case rightresp
                colorright = green;
        end
    else % order == 2
        switch response
            case leftresp
                colorleft = green;
            case rightresp
                colorright = green;
                Included(trial) = 1;
        end
    end % end if order == 1
    
    %-----------------------------------------------------------------
    % redraw text output with the appropriate colorchanges
    Screen('PutImage',w,imgArrays{trial});
    Screen('TextSize',w, 40);
    %     if order==1
    %         Screen('DrawText', w, 'Included', xcenter-350,ycenter+300, colorleft);
    %         Screen('DrawText', w, 'Not included', xcenter+120, ycenter+300, colorright);
    %     else
    %         Screen('DrawText', w, 'Not included', xcenter-350, ycenter+300, colorleft);
    %         Screen('DrawText', w, 'Included', xcenter+120, ycenter+300, colorright);
    %     end
    
    if order==1
        CenterText(w,'u - included',colorleft,-250,300);
        CenterText(w,'i - not included',colorright,250,300);
    else
        CenterText(w,'u - not included',colorleft,-250,300);
        CenterText(w,'i - included', colorright,250,300);
    end
    
    Screen(w,'Flip');
    WaitSecs(0.5);
    
    %-----------------------------------------------------------------
    % show fixation ITI
    Screen('TextSize',w, 60);
    Screen('DrawText', w, '+', xcenter, ycenter, white);
    Screen(w,'Flip');
    WaitSecs(1);
    
    %-----------------------------------------------------------------
    % Write to output files
    
    fprintf(fid1,'%s %d %d %d %d %d %d %s %s %d %d %d \n', subjectID, order, shuffledlistInd(trial), trial, shuffledIsOld(trial), Included(trial), StimOnset-runStart, shuffledlist(trial).name, response, respTime, shuffledSortedBidInd(trial), shuffledSortedIsBeep(trial));
    fprintf(fid2,'%d %d %s %d %d %d %d \n', trial, shuffledlistInd(trial), shuffledlist(trial).name, shuffledIsOld(trial), Included(trial), shuffledSortedBidInd(trial), shuffledSortedIsBeep(trial));
    
    % save xls file
    % -------------
    dataToSave = {trial, shuffledlistInd(trial), shuffledlist(trial).name, shuffledIsOld(trial), Included(trial), shuffledSortedBidInd(trial), 0, shuffledSortedIsBeep(trial)};
    dataRange = ['A' num2str(6+trial)];
    xlswrite(xlsfilename,dataToSave,xlsheet,dataRange);
    
    KbQueueFlush;
    
    
end % end loop for trial = 1:length(food_images);

% Close open files
fclose(fid1);
fclose(fid2);


% Save variables to mat file
outfile = strcat(outputPath,'/', sprintf('%s_recognitionOldNew_%s.mat',subjectID, timestamp));

% create a data structure with info about the run
run_info.subject = subjectID;
run_info.date = date;
run_info.outfile = outfile;

run_info.script_name = mfilename;
clear imgArrays imgArraysNew imgArraysOld ;
save(outfile);


% save timestamp to xls file
% -------------
timestamp_cell = {timestamp};
xlswrite(xlsfilename,timestamp_cell,xlsheet,'B3');


% End of session screen

if sessionNum == 1
    
    Screen('TextSize',w, 40);
    CenterText(w,'Thank you! Please read the instructions and proceed with PART 6.', white,0,0);
    Screen(w,'Flip');
else
    
    Screen('TextSize',w, 40);
    CenterText(w,'Thank you! Please read the instructions and proceed with PART 4.', white,0,0);
    Screen(w,'Flip');
end


% Closing

WaitSecs(4);
toc
ShowCursor;
Screen('CloseAll');


end % end function