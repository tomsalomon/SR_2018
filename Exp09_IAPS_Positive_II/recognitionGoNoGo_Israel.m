function recognitionGoNoGo_Israel(subjectID, test_comp, mainPath, order, sessionNum)

% function recognitionGoNoGo_Israel(subjectID, test_comp, order, mainPath, sessionNum, xlsfilename);

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% =============== Created based on the previous boost codes ===============
% ==================== by Rotem Botvinik December 2014 ====================
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

% This function runs the second part of the memory (recognition) session of the
% boost (cue-approach) task.
% Subjects are presented with the stimuli they claimed to be old (included
% in the previous sessions of the cue-approach task) in the first part of
% the memory (recognition) session in a random order, and should answer whether they
% think this item was a GO (beep) or NOGO (no beep) item in the training
% session.


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % % --------- Exterior files needed for task to run correctly: ----------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%   ''recognitionNewOld_results' num2str(sessionNum) '_' timestamp
%   '.txt'' --> Created by the recognitionNewOld function



% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % % ------------------- Creates the following files: --------------------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%   ''recognitionGoNoGo_results' num2str(sessionNum) '_' date '.txt''
%   Which includes the variables: trialNum (in the GoNoGo recognition task), index
%   of the item (ABC order, old and than new), name of item, whether the item
%   is old (1) or not (0), the subject's answer (0- not included; 1-
%   included), whether the item is go (1) or nogo (0) item, the subject's
%   answer (o- noBeep, 1- Beep), the index of the bid (high to low)

%   ''recognitionGoNoGo' num2str(sessionNum) '_' timestamp '.txt''

%   Results are also saved to the xls file created in the main
%   'run_boost_Israel_new' function:
% ''recognition_results' num2str(sessionNum) '_' timestamp'


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % ------------------- dummy info for testing purposes -------------------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% subjectID = 'BM_9001';
% order = 1;
% test_comp = 3;
% sessionNum = 1;
% mainPath = 'D:/Rotem/Matlab/Boost_Israel_New_Rotem';


tic


%==========================================================
%% 'INITIALIZE Screen variables to be used in each task'
%==========================================================

Screen('Preference', 'VisualDebuglevel', 3); %No PTB intro screen
screennum = max(Screen('Screens'));

pixelSize = 32;
% [w] = Screen('OpenWindow',screennum,[],[0 0 640 480],pixelSize);% %debugging screensize
[w] = Screen('OpenWindow',screennum,[],[],pixelSize);


% % Set the colors
black = BlackIndex(w); % Should equal 0.
white = WhiteIndex(w); % Should equal 255.
green = [0 255 0];

Screen('FillRect', w, black);  % NB: only need to do this once!
Screen('Flip', w);

% Set up screen positions for stimuli
[wWidth, wHeight] = Screen('WindowSize', w);
xcenter = wWidth/2;
ycenter = wHeight/2;


% Text settings
theFont ='Arial';
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

% essential for randomization
rng('shuffle');

%---------------------------------------------------------------
%% 'ASSIGN response keys'
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
%% 'READ data from recognitionNewOLD'
%---------------------------------------------------------------

file = dir([outputPath '/' subjectID '_recognitionNewOld_results' num2str(sessionNum) '*.txt']);
fid = fopen([outputPath '/' sprintf(file(length(file)).name)]);
data = textscan(fid, '%d %d %s %d %d %d %d') ;% these contain everything from the recognitionNewOld
fclose(fid);

shuffledlistInd = data{2}; % the ABC index of the stimuli (old and than new)
stimName = data{3}; % the name of the stimuli (including the .bmp)
isOld = data{4}; % is the item old (1) or new (0)
Included = data{5}; % the subject's answer: old (1) or new (0)
bidInd = data{6};
isBeep = data{7};

%---------------------------------------------------------------
%% 'SHUFFLE the stimuli that the subject thought were old, for the goNoGo recognition task'
%---------------------------------------------------------------

oldStimLoc = find(Included);
stimIndABC = shuffledlistInd(oldStimLoc);
oldStimName = stimName(oldStimLoc);
oldIsOld = isOld(oldStimLoc);
oldIsBeep = isBeep(oldStimLoc);
oldBidInd = bidInd(oldStimLoc);
numStimuli = length(oldStimLoc);

stimOrder = Shuffle(1:length(oldStimLoc));


%---------------------------------------------------------------
%% 'LOAD image arrays'
%---------------------------------------------------------------
imgArrays = cell(1, numStimuli);
for i = 1:numStimuli
    if oldIsOld(i) == 1
        imgArrays{i} = imread([mainPath '/stim/' oldStimName{i}]);
    else
        imgArrays{i} = imread([mainPath '/stim/recognitionNew/' oldStimName{i}]);
    end
end

% Load Hebrew instructions image files
Instructions=dir([mainPath '/Instructions/*recognitionGoNogo.JPG' ]);
Instructions_name=struct2cell(rmfield(Instructions,{'date','bytes','isdir','datenum'}));
Instructions_image=imread([mainPath '/Instructions/' sprintf(Instructions_name{1})]);

%---------------------------------------------------------------
%% 'Write output file header'
%---------------------------------------------------------------

fid1 = fopen([outputPath '/' subjectID '_recognitionGoNoGo' num2str(sessionNum) '_' timestamp '.txt'], 'a');
fprintf(fid1,'subjectID\torder\tstimName\titemIndABC\tbidInd\truntrial\tisOld?\tsubjectAnswerIsOld\tisBeep?\tsubjectAnswerIsBeep\tonsettime\tresp_choice\tRT\n'); %write the header line
% Open txt file to write the subject's answers (Beep \ no beep)
fid2 = fopen([outputPath '/' subjectID '_recognitionGoNoGo_results' num2str(sessionNum) '_' date '.txt'], 'a');

%---------------------------------------------------------------
%% 'Display Main Instructions'
%---------------------------------------------------------------

% Screen('TextSize',w, 40);
% if sessionNum == 1
%     CenterText(w,'Part 6:',white, 0,-500);
% else
%     CenterText(w,'PART 4:', white,0,-500);
% end
%
% CenterText(w,'Please think back to the lengthy task you completed with the beeps.',white, 0, -400);
% CenterText(w,'You will NOT hear any beeps during this part of the experiment.',white, 0, -300);
%
% if order == 1
%     CenterText(w,'Press `u` if you heard a beep when this item was presented.', white,0,-50);
%     CenterText(w,'Press `i` if there was no beep when this item was presented.', white, 0,50);
%
% else
%     CenterText(w,'Press `u` if there was no beep when this item was presented.', white,0,-50);
%     CenterText(w,'Press `i` if you heard a beep when this item was presented.', white, 0,50);
% end
%
% CenterText(w,'Please press any key to continue.', green,0,300);
% Screen('Flip', w);

Screen('PutImage',w,Instructions_image);
Screen(w,'Flip');

HideCursor; % Make comment for debugging

if test_comp==1
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
        [keyIsDown] = KbCheck;%deviceNumber=keyboard
        if keyIsDown && noresp,
            noresp=0;
        end;
    end
end;

WaitSecs(0.001);
% anchor = GetSecs;

Screen('TextSize',w, 60);
CenterText(w,'+', white,0,0);
Screen(w,'Flip');
WaitSecs(0.5);

KbQueueCreate;

%---------------------------------------------------------------
%% 'Run Trials'
%---------------------------------------------------------------
subjectAnswerIsBeep = zeros(1, numStimuli);
% xlsheet = 'Recognition';

runStart = GetSecs;

for trial = 1:numStimuli
    ind = stimOrder(trial);
    
    colorright = white;
    colorleft = white;
    
    %-----------------------------------------------------------------
    % display image
    % self-paced; next image will only show after response
    
    Screen('PutImage',w,imgArrays{ind});
    Screen('TextSize',w, 40);
    
    %     if order==1
    %         Screen('DrawText', w, 'Cue', xcenter-400,ycenter+300, white);
    %         Screen('DrawText', w, 'No Cue', xcenter+400, ycenter+300, white);
    %     else
    %         Screen('DrawText', w, 'No Cue', xcenter-400, ycenter+300, white);
    %         Screen('DrawText', w, 'Cue', xcenter+400, ycenter+300, white);
    %     end
    
    if order==1
        CenterText(w,'u - Cue',colorleft,-250,300);
        CenterText(w,'i - No Cue',colorright,250,300);
    else
        CenterText(w,'u - No Cue',colorleft,-250,300);
        CenterText(w,'i - Cue',colorright,250,300);
    end
    
    Screen(w,'Flip');
    StimOnset = GetSecs;
    
    KbQueueStart;
    %-----------------------------------------------------------------
    % get response
    
    
    noresp=1;
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
            if response=='u'||response=='i'
                noresp = 0;
            end
            
        end % end if keyIsDown && noresp
        
    end % end while noresp
    
    
    
    %-----------------------------------------------------------------
    
    % determine what bid to highlight and write the subject's response to
    % the subjectAnswerIsBeep array
    if order ==1
        switch response
            case leftresp
                colorleft = green;
                subjectAnswerIsBeep(trial) = 1;
            case rightresp
                colorright = green;
        end
    else % order == 2
        switch response
            case leftresp
                colorleft = green;
            case rightresp
                colorright = green;
                subjectAnswerIsBeep(trial) = 1;
        end
    end % end if order == 1
    
    
    %-----------------------------------------------------------------
    % redraw text output with the appropriate colorchanges
    Screen('PutImage',w,imgArrays{ind});
    Screen('TextSize',w, 40);
    %     if order==1
    %         Screen('DrawText', w, 'Cue', xcenter-400,ycenter+300, colorleft);
    %         Screen('DrawText', w, 'No Cue', xcenter+400, ycenter+300, colorright);
    %     else
    %         Screen('DrawText', w, 'No Cue', xcenter-400, ycenter+300, colorleft);
    %         Screen('DrawText', w, 'Cue', xcenter+400, ycenter+300, colorright);
    %     end
    
    if order==1
        CenterText(w,'u - Cue',colorleft,-250,300);
        CenterText(w,'i - No Cue',colorright,250,300);
    else
        CenterText(w,'u - No Cue',colorleft,-250,300);
        CenterText(w,'i - Cue',colorright,250,300);
    end
    
    Screen(w,'Flip');
    WaitSecs(0.5);
    
    %-----------------------------------------------------------------
    % show fixation ITI
    Screen('TextSize',w, 60);
    CenterText(w,'+', white,0,0);
    Screen(w,'Flip');
    WaitSecs(0.5);
    
    %---------------------------------------------------------------
    %% 'Write to output file'
    %---------------------------------------------------------------
    fprintf(fid1,'%s\t%d\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%s\t%d\n', subjectID, order, oldStimName{ind}, stimIndABC(ind), oldBidInd(ind), trial, oldIsOld(ind), 1, oldIsBeep(ind), subjectAnswerIsBeep(trial), StimOnset-runStart, response, respTime);
    fprintf(fid2,'%d\t%d\t%s\t%d\t%d\t%d\t%d\t%d\n', trial, stimIndABC(ind), oldStimName{ind}, oldIsOld(ind), 1, oldIsBeep(ind), subjectAnswerIsBeep(trial), oldBidInd(ind));
    
    
    %     % save xls file
    %     % -------------
    %     dataToSave = {trial, oldIsBeep(ind), subjectAnswerIsBeep(trial)};
    %     dataRange = ['G' num2str(6+oldStimLoc(ind))];
    %     xlswrite(xlsfilename,dataToSave,xlsheet,dataRange);
    %
    KbQueueFlush;
    
end % end for trial = 1:numStimuli

fclose(fid1);
fclose(fid2);


% Save variables to mat file
outfile = strcat(outputPath,'/', sprintf('%s_recognitionGoNoGo_%s.mat',subjectID, timestamp));

% create a data structure with info about the run
run_info.subject = subjectID;
run_info.date = date;
run_info.outfile = outfile;

run_info.script_name = mfilename;
clear imgArrays;
clear Instructions_image;
save(outfile);

%
% % save timestamp to xls file
% % -------------
% timestamp_cell = {timestamp};
% xlswrite(xlsfilename,timestamp_cell,xlsheet,'B3');


% End of session screen
Screen('TextSize',w, 40);
CenterText(w,'Thank you!', green,0,0);
CenterText(w,'The experiment is over.', white,0,-100);
CenterText(w,'Please call the experimenter.', white,0,-200);
Screen(w,'Flip');

WaitSecs(4);

toc
ShowCursor;
Screen('CloseAll');

end