function [total_num_trials] = probe_Israel(subjectID, order, mainPath, test_comp, sessionNum, which_block, xlsfilename,stimuli)
% function [total_num_trials] = probe_Israel(subjectID, order, mainPath, test_comp, sessionNum, block, xlsfilename)
%
% Created based on the previous boost codes, by Rotem Botvinik November
% 2014
% This function runs the probe session of the boost (cue-approach) task.


%=========================================================================
% Probe task code
%=========================================================================

% %---dummy info for testing purposes --------
% subjectID =  'BM_9001';
% order = 1;
% test_comp = 3;
% sessionNum = 1;
% mainPath = 'D:\Rotem\Matlab\Boost_Israel_New_Rotem';

%==============================================
%% 'GLOBAL VARIABLES'
%==============================================

% 'block' indicates how many times the subject has completed all
% trials of the probe experiment. Therefore, the first time the subject completes
% a probe block on his/her 2nd session, it is actually probe block 3 for
% that person:

if test_comp == 1 % If it's an fMRI experiment, let the experimenter insert the block number, for him to control when to start 
    okblock = [1 2];
    which_block = input('Enter Block 1 or 2 ');
    while isempty(which_block) || sum(okblock == which_block) ~=1
        disp('ERROR: input must be 1 or 2. Please try again.');
        which_block=input('Enter Block 1 or 2 ');
    end
end % end if test_comp == 1

block = (sessionNum-1)*2 + which_block;

outputPath = [mainPath '\Output'];

%   'timestamp'
% - - - - - - - - - - - - - - - - -
c = clock;
hr = sprintf('%02d', c(4));
minutes = sprintf('%02d', c(5));
timestamp = [date,'_',hr,'h',minutes,'m'];

%   'set phase times'
% - - - - - - - - - - - - - - - - -
maxtime = 1.5;      % 1.5 second limit on each selection
baseline_fixation_dur = 2; % Need to modify based on if first few volumes are saved or not
afterrunfixation = 6;

tic
%==============================================
%% 'INITIALIZE Screen variables'
%==============================================
Screen('Preference', 'VisualDebuglevel', 3); %No PTB intro screen
screennum = max(Screen('Screens'));

pixelSize=32;
% [w] = Screen('OpenWindow',screennum,[],[0 0 640 480],pixelSize/4);% %debugging screensize
[w] = Screen('OpenWindow',screennum,[],[],pixelSize);

HideCursor;


% Define Colors
% - - - - - - - - - - - - - - -
black = BlackIndex(w); % Should equal 0.
white = WhiteIndex(w); % Should equal 255.
green = [0 255 0];

Screen('FillRect', w, black);  % NB: only need to do this once!
Screen('Flip', w);


% setting the text
% - - - - - - - - - - - - - - -
theFont='Arial';
Screen('TextFont',w,theFont);
Screen('TextSize',w, 40);

% stack locations
% - - - - - - - - - - - - - - -
[wWidth, wHeight]=Screen('WindowSize', w);
xcenter=wWidth/2;
ycenter=wHeight/2;

if stimuli==1
    stackW=576;
    stackH=432;
elseif stimuli==2
    stackW=280;
    stackH=296;
elseif stimuli==3
    stackW=520;
    stackH=347;
end

leftRect=[xcenter-stackW-300 ycenter-stackH/2 xcenter-300 ycenter+stackH/2];
rightRect=[xcenter+300 ycenter-stackH/2 xcenter+stackW+300 ycenter+stackH/2];

penWidth=10;

HideCursor;

%==============================================
%% 'ASSIGN response keys'
%==============================================
KbName('UnifyKeyNames');
%MRI=0;
switch test_comp
    case {0,2,3}
        leftstack = 'u';
        rightstack = 'i';
        badresp = 'x';
    case 1
        leftstack = 'b';
        rightstack = 'y';
        badresp = 'x';
end



%==============================================
%% 'Read in data'
%==============================================

%   'read in sorted file'
% - - - - - - - - - - - - - - - - -

file = dir([mainPath '/Output/' subjectID '_stopGoList_allstim_order*']);
fid = fopen([mainPath '/Output/' sprintf(file(length(file)).name)]);
data = textscan(fid, '%s %d %d %f %d') ;% these contain everything from the sortbdm
stimName = data{1};
bidIndex = data{3};
bidValue = data{4};


%   'load image arrays'
% - - - - - - - - - - - - - - -
food_items = cell(1,length(stimName));
for i=1:length(stimName)
    food_items{i}=imread([mainPath sprintf('/stim/%s',stimName{i})]);
end

%   'load onsets'
% - - - - - - - - - - - - - - -
r = Shuffle(1:4);
onsetlist = load([mainPath '/Onset_files/probe_onset136_' num2str(r(1)) '.mat']);
onsetlist = onsetlist.onsetlist;


%==============================================
%%   'PRE-TRIAL DATA ORGANIZATION'
%==============================================


% determine stimuli to use based on order number
%-----------------------------------------------------------------
switch order
    case 1
        %   comparisons of interest
        % - - - - - - - - - - - - - - -
        HV_beep = [7 10 12 13 15 18 20 21]; %HV_beep
        HV_nobeep = [8 9 11 14 16 17 19 22]; %HV_nobeep
        
        LV_beep=[39 42 44 45 47 50 52 53]; %LV_beep
        LV_nobeep=[40 41 43 46 48 49 51 54]; %LV_nobeep
        
        
        %   sanity check comparisons
        % - - - - - - - - - - - - - - -
        sanityHV_beep=[24 25]; %HV_beep
        sanityLV_beep=[36 37]; %LV_beep
        
        
        sanityHV_nobeep=[23 26]; %HV_nobeep
        sanityLV_nobeep=[35 38]; %LV_nobeep
        
    case 2
        
        %   comparisons of interest
        % - - - - - - - - - - - - - - -
        HV_beep=[8 9 11 14 16 17 19 22]; %HV_beep
        HV_nobeep=[7 10 12 13 15 18 20 21]; %HV_nobeep
        
        
        LV_beep=[40 41 43 46 48 49 51 54]; %LV_beep
        LV_nobeep=[39 42 44 45 47 50 52 53]; %LV_nobeep
        
        
        
        %   sanity check comparisons
        % - - - - - - - - - - - - - - -
        sanityHV_beep=[23 26]; %HV_beep
        sanityLV_beep=[35 38]; %LV_beep
        
        
        sanityHV_nobeep=[24 25]; %HV_nobeep
        sanityLV_nobeep=[36 37]; %LV_nobeep
        
end % end switch order


%   add multiple iterations of each item presentation (8 total)
%-----------------------------------------------------------------


%   TRIAL TYPE 1: HighValue Go vs. HighValue NoGo(Stop)
% - - - - - - - - - - - - - - - - - - - - - - - - - - -
HV_beep_new = length(HV_beep)^2;
HV_nobeep_new = length(HV_beep)^2;
for i=1:8
    for j=1:8
        HV_beep_new(j+(i-1)*8)=HV_beep(i);
        HV_nobeep_new(j+(i-1)*8)=HV_nobeep(j);
    end
end
[shuffle_HV_beep_new,shuff_HV_beep_new_ind]=Shuffle(HV_beep_new);
shuffle_HV_nobeep_new=HV_nobeep_new(shuff_HV_beep_new_ind);



%   TRIAL TYPE 2: LowValue Go vs. LowValue NoGo(Stop)
% - - - - - - - - - - - - - - - - - - - - - - - - - - -
LV_beep_new = length(LV_beep)^2;
LV_nobeep_new = length(LV_nobeep)^2;
for i=1:8
    for j=1:8
        LV_beep_new(j+(i-1)*8)=LV_beep(i);
        LV_nobeep_new(j+(i-1)*8)=LV_nobeep(j);
    end
end
[shuffle_LV_beep_new,shuff_LV_beep_new_ind]=Shuffle(LV_beep_new);
shuffle_LV_nobeep_new=LV_nobeep_new(shuff_LV_beep_new_ind);


%   TRIAL TYPE 3: HighValue NoGo(Stop) vs. LowValue NoGo(Stop)
% - - - - - - - - - - - - - - - - - - - - - - - - - - -
sanityHV_beep_new = length(sanityHV_beep)^2;
sanityLV_beep_new = length(sanityLV_beep)^2;
for i=1:2
    for j=1:2
        sanityHV_beep_new(j+(i-1)*2) = sanityHV_beep(i);
        sanityLV_beep_new(j+(i-1)*2) = sanityLV_beep(j);
    end
end
[shuffle_sanityHV_beep_new,shuff_sanityHV_beep_new_ind]=Shuffle(sanityHV_beep_new);
shuffle_sanityLV_beep_new=sanityLV_beep_new(shuff_sanityHV_beep_new_ind);



%   TRIAL TYPE 4: HighValue Go vs. LowValue Go
% - - - - - - - - - - - - - - - - - - - - - - - - - - -
sanityHV_nobeep_new = length(sanityHV_nobeep)^2;
sanityLV_nobeep_new = length(sanityLV_nobeep)^2;
for i=1:2
    for j=1:2
        sanityHV_nobeep_new(j+(i-1)*2)=sanityHV_nobeep(i);
        sanityLV_nobeep_new(j+(i-1)*2)=sanityLV_nobeep(j);
    end
end
[shuffle_sanityHV_nobeep_new,shuff_sanityHV_nobeep_new_ind]=Shuffle(sanityHV_nobeep_new);
shuffle_sanityLV_nobeep_new=sanityLV_nobeep_new(shuff_sanityHV_nobeep_new_ind);



%   randomize all possible comparisons for all trial types
%-----------------------------------------------------------------
leftGo=cell(1,2);
stimnum1=cell(1,2);
stimnum2=cell(1,2);
leftname=cell(1,2);
rightname=cell(1,2);
pairtype=cell(1,2);

numComparisons = length(HV_beep)^2;
numSanity = length(sanityHV_beep)^2;

pairtype{block}(1:numComparisons) = 1;
pairtype{block}(numComparisons+1:numComparisons*2) = 2;
pairtype{block}(numComparisons*2+1:numComparisons*2+numSanity) = 3;
pairtype{block}(numComparisons*2+numSanity+1:numComparisons*2+numSanity*2) = 4;

% for type = 1:2 % numComparisons comparisons of GO-NOGO items for the HV and the LV items
%     pairtype{block}(1+numComparisons*(type-1):numComparisons*type) = type;
% end % end for type = 1:2

leftGo{block} = ones(1,numComparisons*2+numSanity*2);
for loc = 1:numComparisons:numComparisons*2
    leftGo{block}(loc:loc-1+numComparisons/2) = 0;
end % end for loc = 1:numComparisons:numComparisons*2

for loc = 1+2*numComparisons:numSanity:numComparisons*2+numSanity*2
    leftGo{block}(loc:loc-1+numSanity/2) = 0;
end % end for loc = 1+2*numComparisons:numSanity:numComparisons*2+numSanity*2

pairtype{block} = Shuffle(pairtype{block});
leftGo{block} = Shuffle(leftGo{block});

% pairtype{block}= Shuffle([ 1 1 1 1 1 1 1 1  1 1 1 1 1 1 1 1  2 2 2 2 2 2 2 2  2 2 2 2 2 2 2 2  3 3 3 3 3 3 3 3  3 3 3 3 3 3 3 3  4 4 4 4 4 4 4 4  4 4 4 4 4 4 4 4 ]);
% leftGo{block}=Shuffle([  1 1 1 1 1 1 1 1  0 0 0 0 0 0 0 0  1 1 1 1 1 1 1 1  0 0 0 0 0 0 0 0  1 1 1 1 1 1 1 1  0 0 0 0 0 0 0 0  1 1 1 1 1 1 1 1  0 0 0 0 0 0 0 0 ]);

HV_beep=shuffle_HV_beep_new;
HV_nobeep=shuffle_HV_nobeep_new;
LV_beep=shuffle_LV_beep_new;
LV_nobeep=shuffle_LV_nobeep_new;

sanityHV_nobeep=shuffle_sanityHV_nobeep_new;
sanityLV_nobeep=shuffle_sanityLV_nobeep_new;
sanityLV_beep=shuffle_sanityLV_beep_new;
sanityHV_beep=shuffle_sanityHV_beep_new;

HH=1;
LL=1;
HL_S=1;
HL_G=1;

total_num_trials = length(pairtype{block});

for i=1:total_num_trials % trial num within block
    switch pairtype{block}(i)
        case 1
            
            % HighValue Go vs. HighValue NoGo(Stop)
            % - - - - - - - - - - - - - - - - - - -
            
            stimnum1{block}(i)=HV_beep(HH);
            stimnum2{block}(i)=HV_nobeep(HH);
            HH=HH+1;
            if leftGo{block}(i)==1
                leftname{block}(i)=stimName(stimnum1{block}(i));
                rightname{block}(i)=stimName(stimnum2{block}(i));
            else
                leftname{block}(i)=stimName(stimnum2{block}(i));
                rightname{block}(i)=stimName(stimnum1{block}(i));
            end
            
        case 2
            
            % LowValue Go vs. LowValue NoGo(Stop)
            % - - - - - - - - - - - - - - - - - - -
            
            stimnum1{block}(i)=LV_beep(LL);
            stimnum2{block}(i)=LV_nobeep(LL);
            LL=LL+1;
            if leftGo{block}(i)==1
                leftname{block}(i)=stimName(stimnum1{block}(i));
                rightname{block}(i)=stimName(stimnum2{block}(i));
            else
                leftname{block}(i)=stimName(stimnum2{block}(i));
                rightname{block}(i)=stimName(stimnum1{block}(i));
            end
            
        case 3
            
            % HighValue NoGo(Stop) vs. LowValue NoGo(Stop)
            % - - - - - - - - - - - - - - - - - - -
            
            stimnum1{block}(i)=sanityHV_beep(HL_S);
            stimnum2{block}(i)=sanityLV_beep(HL_S);
            HL_S=HL_S+1;
            if leftGo{block}(i)==1
                leftname{block}(i)=stimName(stimnum1{block}(i));
                rightname{block}(i)=stimName(stimnum2{block}(i));
            else
                leftname{block}(i)=stimName(stimnum2{block}(i));
                rightname{block}(i)=stimName(stimnum1{block}(i));
            end
            
        case 4
            
            % HighValue Go vs. LowValue Go
            % - - - - - - - - - - - - - - - - - - -
            
            stimnum1{block}(i)=sanityHV_nobeep(HL_G);
            stimnum2{block}(i)=sanityLV_nobeep(HL_G);
            HL_G=HL_G+1;
            if leftGo{block}(i)==1
                leftname{block}(i)=stimName(stimnum1{block}(i));
                rightname{block}(i)=stimName(stimnum2{block}(i));
            else
                leftname{block}(i)=stimName(stimnum2{block}(i));
                rightname{block}(i)=stimName(stimnum1{block}(i));
            end
            
    end %switch pairtype
    
end %for i=1=total_num_trials

%-----------------------------------------------------------------
%% 'Write output file header'
%-----------------------------------------------------------------

fid1=fopen([outputPath '\' subjectID sprintf('_probe_block_%02d_', block) timestamp '.txt'], 'a');
fprintf(fid1,'subjectID scanner order block runtrial onsettime ImageLeft ImageRight bidIndexLeft bidIndexRight IsleftGo Response PairType Outcome RT bidIndexLeft bidIndexRight bidLeft bidRight \n'); %write the header line


%==============================================
%% 'Display Main Instructions'
%==============================================
KbQueueCreate;
Screen('TextSize',w, 40);

%%% While they are waiting for the trigger
if test_comp==1
    Screen('TextSize',w, 60);
    CenterText(w,'PART 4:', white,0,-325);
    
    Screen('TextSize',w, 40);
    CenterText(w,'In this part two pictures of food items will be presented on the Screen.', white,0,-270);
    CenterText(w,'For each trial, we want you to choose one of the items using the keyboard.', white,0,-215);
    CenterText(w,'You will have 1.5 seconds to make your choice on each trial, so please', white,0,-160);
    CenterText(w,'try to make your choice quickly.', white,0,-105);
    CenterText(w,'At the end of this part we will choose one trial at random and', white,0,-50);
    CenterText(w,'honor your choice on that trial and give you the food item.', white,0,5);
    CenterText(w,'Press the keys on the keypad for the left and right items respectively.', white,0,60);
    CenterText(w,'Waiting for trigger...GET READY....', white, 0, 180);
    
    escapeKey = KbName('t');
    while 1
        [keyIsDown,~,keyCode] = KbCheck(-1);
        if keyIsDown && keyCode(escapeKey)
            break;
        end
    end
    
    DisableKeysForKbCheck(KbName('t')); % So trigger is no longer detected
else
    Screen('TextSize',w, 60);
    if block == 1 || block == 2
        CenterText(w,'PART 4:', white,0,-500);
    else
        CenterText(w,'PART 2:', white,0,-500);
    end
    
         if stimuli==1
    Screen('TextSize',w, 40);
    CenterText(w,'In this part two pictures of food items will be presented on the Screen.', white,0,-380);
    CenterText(w,'For each trial, we want you to choose one of the items using the keyboard.', white,0,-320);
    CenterText(w,'You will have 1.5 seconds to make your choice on each trial,', white,0,-260);
    CenterText(w,'so please try to make your choice quickly.', white,0,-200);
    CenterText(w,'At the end of this part we will choose one trial at random and', white,0,-140);
    CenterText(w,'honor your choice on that trial and give you the food item.', white,0,-80);
    CenterText(w,'Press the `u` and `i` keys for the left and right items respectively.', white,0,-20);
    CenterText(w,'This is NOT a demo.', white,0,100);
    CenterText(w,'Press any key to continue', green,0,160);
    
         elseif stimuli==2
    Screen('TextSize',w, 40);
    CenterText(w,'In this part two pictures of faces will be presented on the Screen.', white,0,-380);
    CenterText(w,'For each trial, we want you to choose one of the faces using the keyboard.', white,0,-320);
    CenterText(w,'You will have 1.5 seconds to make your choice on each trial,', white,0,-260);
    CenterText(w,'so please try to make your choice quickly.', white,0,-200);

    CenterText(w,'Press the `u` and `i` keys for the left and right items respectively.', white,0,-20);
    CenterText(w,'This is NOT a demo.', white,0,100);
    CenterText(w,'Press any key to continue', green,0,160);
    
         elseif stimuli==3
    Screen('TextSize',w, 40);
    CenterText(w,'In this part two pictures of fractals will be presented on the Screen.', white,0,-380);
    CenterText(w,'For each trial, we want you to choose one of the fractals using the keyboard.', white,0,-320);
    CenterText(w,'You will have 1.5 seconds to make your choice on each trial,', white,0,-260);
    CenterText(w,'so please try to make your choice quickly.', white,0,-200);
 
    CenterText(w,'Press the `u` and `i` keys for the left and right items respectively.', white,0,-20);
    CenterText(w,'This is NOT a demo.', white,0,100);
    CenterText(w,'Press any key to continue', green,0,160);
         end
    
    Screen('Flip',w);
    
    noresp=1;
    while noresp,
        [keyIsDown] = KbCheck(-1);%deviceNumber=keyboard
        if keyIsDown && noresp,
            noresp=0;
        end;
    end;
end


%   baseline fixation cross
% - - - - - - - - - - - - -
prebaseline = GetSecs;
% baseline fixation - currently 10 seconds = 4*Volumes (2.5 TR)
while GetSecs < prebaseline+baseline_fixation_dur
    %    Screen(w,'Flip', anchor);
    CenterText(w,'+', white,0,0);
    Screen('TextSize',w, 60);
    Screen(w,'Flip');
    
end
postbaseline = GetSecs;
baseline_fixation = postbaseline - prebaseline;


%==============================================
%% 'Run Trials'
%==============================================

runtrial = 1;
runStart = GetSecs;
breakLength = 0;

% total_num_trials = length(pairtype{block});
total_num_trials = 6; % for debugging
for trial = 1:total_num_trials
    
    KbQueueStart;
    
    % initial box outline colors
    % - - - - - - -
    colorLeft = black;
    colorRight = black;
    out = 999;
    
    % Check if it is the middle of the run. If so, give the subject a
    % break
    if trial == 1 + total_num_trials/2
        breakStart = GetSecs;
        CenterText(w,sprintf('This is a short break.') ,white,0,-270);
        Screen('Flip',w);
        WaitSecs(3);
        CenterText(w,sprintf('This is a short break.') ,white,0,-270);
        CenterText(w,sprintf('Press any key when you are ready to continue.') ,white,0,-170);
        Screen('Flip',w);
        
        noresp=1;
        while noresp,
            [keyIsDown,~,~] = KbCheck;
            if keyIsDown && noresp,
                noresp=0;
            end;
        end;
        breakEnd = GetSecs;
        breakLength = breakEnd-breakStart;
        onsetlist(trial:end) = onsetlist(trial:end) + breakLength;
    end % end if trial = total_num_trials/2
    
    %-----------------------------------------------------------------
    % display images
    %-----------------------------------------------------------------
    if leftGo{block}(trial)==1
        Screen('PutImage',w,food_items{stimnum1{block}(trial)}, leftRect);
        Screen('PutImage',w,food_items{stimnum2{block}(trial)}, rightRect);
    else
        Screen('PutImage',w,food_items{stimnum2{block}(trial)}, leftRect);
        Screen('PutImage',w,food_items{stimnum1{block}(trial)}, rightRect);
    end
    CenterText(w,'+', white,0,0);
    StimOnset = Screen(w,'Flip', runStart+onsetlist(runtrial)+baseline_fixation);
    
    
    %-----------------------------------------------------------------
    % get response
    %-----------------------------------------------------------------
    
    noresp = 1;
    goodresp = 0;
    while noresp
        % check for response
        [keyIsDown, firstPress] = KbQueueCheck;
        
        if keyIsDown && noresp
            keyPressed = KbName(firstPress);
            if ischar(keyPressed)==0 % if 2 keys are hit at once, they become a cell, not a char. we need keyPressed to be a char, so this converts it and takes the first key pressed
                keyPressed = char(keyPressed);
                keyPressed = keyPressed(1);
            end
            switch keyPressed
                case leftstack
                    respTime = firstPress(KbName(leftstack))-StimOnset;
                    noresp = 0;
                    goodresp = 1;
                case rightstack
                    respTime = firstPress(KbName(rightstack))-StimOnset;
                    noresp = 0;
                    goodresp = 1;
            end
        end % end if keyIsDown && noresp
        
        
        % check for reaching time limit
        if noresp && GetSecs-runStart >= onsetlist(runtrial)+baseline_fixation+maxtime
            noresp = 0;
            keyPressed = badresp;
            respTime = maxtime;
        end
    end % end while noresp
    
    %-----------------------------------------------------------------
    % determine what bid to highlight
    %-----------------------------------------------------------------
    
    switch keyPressed
        case leftstack
            colorLeft = green;
            if leftGo{block}(trial)==0
                out=0;
            else
                out=1;
            end
        case rightstack
            colorRight = green;
            if leftGo{block}(trial)==1
                out=0;
            else
                out=1;
            end
    end
    
    if goodresp==1
        if leftGo{block}(trial)==1
            Screen('PutImage',w,food_items{stimnum1{block}(trial)}, leftRect);
            Screen('PutImage',w,food_items{stimnum2{block}(trial)}, rightRect);
        else
            Screen('PutImage',w,food_items{stimnum2{block}(trial)}, leftRect);
            Screen('PutImage',w,food_items{stimnum1{block}(trial)}, rightRect);
        end
        
        if keyPressed=='u'
            Screen('FrameRect', w, green, leftRect, penWidth);
        elseif keyPressed=='i'
            Screen('FrameRect', w, green, rightRect, penWidth);
        end
        
%         Screen('FrameRect', w, colorLeft, leftRect, penWidth);
%         Screen('FrameRect', w, colorRight, rightRect, penWidth);
        
        CenterText(w,'+', white,0,0);
        Screen(w,'Flip',runStart+onsetlist(trial)+respTime+baseline_fixation);
        
    else
        Screen('DrawText', w, 'You must respond faster!', xcenter-400, ycenter, white);
        Screen(w,'Flip',runStart+onsetlist(runtrial)+respTime+baseline_fixation);
    end % end if goodresp==1
    
    
    %-----------------------------------------------------------------
    % show fixation ITI
    %-----------------------------------------------------------------
    
    
    CenterText(w,'+', white,0,0);
    Screen(w,'Flip',runStart+onsetlist(runtrial)+respTime+.5+baseline_fixation);
    
    
    
    if goodresp ~= 1
        respTime = 999;
    end
    
    
    
    %-----------------------------------------------------------------
    % 'Save data'
    %-----------------------------------------------------------------
    if leftGo{block}(trial)==1
        fprintf(fid1,'%s %d %d %s %d %d %s %s %d %d %d %s %d %d %.2f %d %d %.2f %.2f \n', subjectID, test_comp, order, sprintf('%02d', block), runtrial, StimOnset-runStart, char(leftname{block}(trial)), char(rightname{block}(trial)), stimnum1{block}(trial), stimnum2{block}(trial), leftGo{block}(trial), keyPressed, pairtype{block}(trial), out, respTime*1000, bidIndex(stimnum1{block}(trial)),bidIndex(stimnum2{block}(trial)),bidValue(stimnum1{block}(trial)), bidValue(stimnum2{block}(trial)));
        dataToSave = {runtrial, StimOnset-runStart, char(leftname{block}(trial)), char(rightname{block}(trial)), stimnum1{block}(trial), stimnum2{block}(trial), leftGo{block}(trial), keyPressed, pairtype{block}(trial), out, respTime*1000, bidValue(stimnum1{block}(trial)), bidValue(stimnum2{block}(trial))};
        dataRange = ['A' num2str(6+trial)];
        xlsheet = ['Block' num2str(block)];
        xlswrite(xlsfilename,dataToSave,xlsheet,dataRange);
        timestamp_cell={timestamp};
        xlswrite(xlsfilename,timestamp_cell,xlsheet,'B3');
    else
        fprintf(fid1,'%s %d %d %s %d %d %s %s %d %d %d %s %d %d %.2f %d %d %.2f %.2f \n', subjectID, test_comp, order, sprintf('%02d', block), runtrial, StimOnset-runStart, char(leftname{block}(trial)), char(rightname{block}(trial)), stimnum2{block}(trial), stimnum1{block}(trial), leftGo{block}(trial), keyPressed, pairtype{block}(trial), out, respTime*1000, bidIndex(stimnum2{block}(trial)),bidIndex(stimnum1{block}(trial)),bidValue(stimnum2{block}(trial)), bidValue(stimnum1{block}(trial)));
        dataToSave = {runtrial, StimOnset-runStart, char(leftname{block}(trial)), char(rightname{block}(trial)), stimnum2{block}(trial), stimnum1{block}(trial), leftGo{block}(trial), keyPressed, pairtype{block}(trial), out, respTime*1000, bidValue(stimnum1{block}(trial)), bidValue(stimnum2{block}(trial))};
        dataRange = ['A' num2str(6+trial)];
        xlsheet = ['Block' num2str(block)];
        xlswrite(xlsfilename,dataToSave,xlsheet,dataRange);
        timestamp_cell={timestamp};
        xlswrite(xlsfilename,timestamp_cell,xlsheet,'B3');
    end
    
    runtrial=runtrial+1;
    KbQueueFlush;
    
end % loop through trials
fclose(fid1);


Postexperiment=GetSecs;
while GetSecs < Postexperiment+afterrunfixation;
    CenterText(w,'+', white,0,0);
    Screen('TextSize',w, 60);
    Screen(w,'Flip');
    
end


%-----------------------------------------------------------------
%	display outgoing message
%-----------------------------------------------------------------
WaitSecs(2);
Screen('FillRect', w, black);
Screen('TextSize',w, 40);

if test_comp == 1 % An fMRI experiment. Edit so that it would be good for the fmri experiment
    if mod(block,2) == 1
        %if block is an odd number
        CenterText(w,sprintf('In a moment we will complete another run of the same task') ,white,0,-170);
        Screen('Flip',w);
        WaitSecs(3);
        
    elseif mod(block,2) == 1 && sessionNum == 1
        %if block is an even number & it's the first session
        CenterText(w,sprintf('Part 2 is done') ,white,0,-270);
        CenterText(w,sprintf('Questions?') ,white,0,-170);
        Screen('Flip',w);
        WaitSecs(3);
        Screen('CloseAll');
        ShowCursor;
        
    elseif mod(block,2) == 1 && sessionNum > 1
        
        %if block is an even number & it's a follow-up session
        CenterText(w,sprintf('Part 4 is done') ,white,0,-270);
        CenterText(w,sprintf('Questions?') ,white,0,-170);
        Screen('Flip',w);
        WaitSecs(3);
        Screen('CloseAll');
        ShowCursor;
    end % end if mod(block,2) == 1
else % Not an fMRI experiment
    if mod(block,2) == 1 % first block of the session
        %if block is an odd number
        CenterText(w,sprintf('Once you are ready we will complete another run of the same task') ,white,0,-270);
        CenterText(w,sprintf('Press any key to continue.') ,white,0,-170);
        Screen('Flip',w);
        
        noresp=1;
        while noresp,
            [keyIsDown,~,~] = KbCheck;
            if keyIsDown && noresp,
                noresp=0;
            end;
        end;
        Screen('CloseAll');
        ShowCursor;
        WaitSecs(3);
        
    elseif mod(block,2) == 0 && sessionNum == 1
        %if block is an even number & it's the first session
        CenterText(w,sprintf('Please read the Part 5 instructions and continue on your own.') ,white,0,-270);
        CenterText(w,sprintf('Press any key to continue.') ,white,0,-170);
        Screen('Flip',w);
        
        noresp=1;
        while noresp,
            [keyIsDown,~,~] = KbCheck;
            if keyIsDown && noresp,
                noresp=0;
            end;
        end;
        Screen('CloseAll');
        ShowCursor;
        
    elseif mod(block,2) == 0 && sessionNum > 1
        
        %if block is an even number & it's a follow-up session
        CenterText(w,sprintf('Please read the Part 3 instructions and continue on your own.') ,white,0,-270);
        CenterText(w,sprintf('Press any key to continue.') ,white,0,-170);
        Screen('Flip',w);
        
        noresp=1;
        while noresp,
            [keyIsDown,~,~] = KbCheck;
            if keyIsDown && noresp,
                noresp=0;
            end;
        end;
        Screen('CloseAll');
        ShowCursor;
    end % end if mod(block,2) == 1
end % end if test)comp == 1

WaitSecs(3);


%---------------------------------------------------------------
% create a data structure with info about the run
%---------------------------------------------------------------
outfile=strcat(outputPath,'/', sprintf('%s_probe_block_%2d_%s.mat',subjectID,block,timestamp));

% create a data structure with info about the run
run_info.subject=subjectID;
run_info.date=date;
run_info.outfile=outfile;

run_info.script_name=mfilename;
clear food_items ;
save(outfile);

KbQueueFlush;

end % end function

