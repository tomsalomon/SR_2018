function [] = training_Israel(subjectID,order,mainPath,test_comp,runInd,total_num_runs,xlsfilename)
% TRAINING_ISRAEL
% Created based on the previous boost codes, by Rotem Botvinik 13/11/2014
% This function runs the training session of the boost (cue-approach) task.

% % % % %
% % % % % % % %---dummy info for testing purposes --------
% % % % % subjectID = 'BM_9001';
% % % % % test_comp = 3;
% % % % % order = 1;
% % % % %
% % % % % runInd = 1
% % % % % total_num_runs = 1;
% % % % % LADDER1IN = 750;
% % % % % LADDER2IN = 750;
% % % %
% % % % %   Exterior files needed for task to run correctly:
% % % % % - - - - - - - - - - - - - - -
% % % % %   [mainPath '/Output/' subjectID sprintf('_stopGoList_allstim_order%d.txt', order)]
% % % % %   [mainPath '/Onset_files/train_onset_' num2str(r(1)) '.mat']        where r=1-4
% % % % %   all the contents of     'stim/'     food images
% % % % %   'Misc/soundfile.mat'
% % % % %   'Misc/demo_items.txt'
% % % % %   'Misc/demo_go.mat'
% % % % %   'CenterText.m'


%---------------------------------------------------------
%%  'SCRIPT VERSION'
%---------------------------------------------------------
notes=('Design developed by Schonberg, Bakkour and Poldrack, inspired by Boynton');
script_name='Boost_behavioral_Israel';
script_version='1';
revision_date='11-18-2014';
fprintf('%s %s (revised %s)\n',script_name,script_version,revision_date);

%---------------------------------------------------------------
%%   'GLOBAL VARIABLES'
%---------------------------------------------------------------

outputPath = [mainPath '/Output'];

% about timing
c = clock;
hr = sprintf('%02d', c(4));
minutes = sprintf('%02d', c(5));
timestamp=[date,'_',hr,'h',minutes,'m'];

% about ladders
Step = 50;

% about timing
image_duration=1; %because stim duration is 1.5 secs in opt_stop
baseline_fixation=1;
afterrunfixation=1;

% -----------------------------------------------
%% 'INITIALIZE SCREEN'
%---------------------------------------------------------------

Screen('Preference', 'VisualDebuglevel', 3); %No PTB intro screen
screennum = max(Screen('Screens'));

pixelSize=32;
% [w] = Screen('OpenWindow',screennum,[],[0 0 640 480],pixelSize);% %debugging screensize
[w] = Screen('OpenWindow',screennum,[],[],pixelSize);

%   colors
% - - - - - -
black=BlackIndex(w); % Should equal 0.
white=WhiteIndex(w); % Should equal 255.
Green=[0 255 0];

Screen('FillRect', w, black);
Screen('Flip', w);

%   stim position
% - - - - - -
[wWidth, wHeight]=Screen('WindowSize', w);

% xcenter=wWidth/2;
% ycenter=wHeight/2;

%   text
% - - - - - -
theFont='Arial';
Screen('TextSize',w,36);
Screen('TextFont',w,theFont);
Screen('TextColor',w,white);


WaitSecs(1);
HideCursor;

% -------------------------------------------------------
%% 'Setting up the sound stuff'
%%---------------------------------------------------------------

load('Misc/soundfile.mat');

wave=sin(1:0.25:1000);

freq=22254;
nrchannels = size(wave,1);

deviceID = -1;

reqlatencyclass = 2; % class 2 empirically the best, 3 & 4 == 2

% Initialize driver, request low-latency preinit:
InitializePsychSound(1);

% Open audio device for low-latency output:
pahandle = PsychPortAudio('Open', deviceID, [], reqlatencyclass, freq, nrchannels);
PsychPortAudio('RunMode', pahandle, 1);

%Play the sound
PsychPortAudio('FillBuffer', pahandle, wave);
PsychPortAudio('Start', pahandle, 1, 0, 0);
WaitSecs(1);
PsychPortAudio('Stop', pahandle);




%%---------------------------------------------------------------
%%  'FEEDBACK VARIABLES'
%%---------------------------------------------------------------

if test_comp==1
    %     trigger = KbName('t');
    blue = KbName('b');
    yellow = KbName('y');
    %     green = KbName('g');
    %     red = KbName('r');
    %     LEFT=[98 5 10];   %blue (5) green (10)
    %     RIGHT=[121 28 21]; %yellow (28) red (21)
else
    BUTTON=98;%[197];  %<
    %RIGHT=[110];%[198]; %>
end; % end if test_comp==1

%---------------------------------------------------------------
%%   'PRE-TRIAL DATA ORGANIZATION'
%---------------------------------------------------------------

%   'Reading in the sorted BDM list - defines which items will be GO/NOGO'
% - - - - - - - - - - - - - - -
file = dir([outputPath '/' subjectID sprintf('_stopGoList_allstim_order%d.txt', order)]);
fid = fopen([outputPath '/' sprintf(file(length(file)).name)]);
vars = textscan(fid, '%s %d %d %f %d') ;% these contain everything from the sortbdm
fclose(fid);

%   Read in info about ladders
% - - - - - - - - - - - - - - -
if runInd == 1
    LADDER1IN = 750;
    LADDER2IN = 750;
else
    tmp2=dir([outputPath '/' subjectID '_ladders_run_' num2str(runInd - 1) '.txt']);
    fid2=fopen([outputPath '/' tmp2(length(tmp2)).name]);
    ladders=textscan(fid2, '%d %d %d', 'Headerlines',1);
    fclose(fid2);
    
    LADDER1IN =ladders{1};
    LADDER2IN = ladders{2};
    runInd=ladders{3}+1;
end

%---------------------------------------------------------------
%% 'Display Main Instructions'
%---------------------------------------------------------------
Screen('TextSize', w, 24); %Set textsize

if test_comp==1;
    CenterText(w,'Please focus on the food item onscreen when you hear the sound.',white,0,-220);
    CenterText(w,'You will receive a bonus for looking at the images.',white,0,-170);
    CenterText(w,'Waiting for trigger...Get READY....',white, 0, -50);
    
    Screen('Flip',w);
    
    escapeKey = KbName('t');
    while 1
        [keyIsDown,secs,keyCode] = KbCheck(-1); %#ok<ASGLU>
        if keyIsDown && keyCode(escapeKey)
            break;
        end
    end
    
    KbQueueCreate(-1,keylist) ;%starting the response cue after the trigger
    
else
    KbQueueCreate;
    KbQueueStart;
    
    Screen('TextSize',w, 50);
    CenterText(w,'PART 2:', white,0,-440);
    Screen('TextSize',w, 40);
    
    CenterText(w,'Press the button b when you hear the sound.',white,0,-270);
    CenterText(w,'Press the button as FAST as you can.',white,0,-170);
    
    CenterText(w,'This is NOT a demo. Press any button to continue',Green, 0, 100);
    Screen('Flip',w);
    
    noresp=1;
    while noresp,
        [keyIsDown,~,~] = KbCheck;%(experimenter_device);
        if keyIsDown && noresp,
            noresp=0;
        end;
    end;
    WaitSecs(0.001);
    KbQueueFlush;
end

DisableKeysForKbCheck(KbName('t')); % So trigger is no longer detected


%---------------------------------------------------------------
%%  'TRIAL PRESENTATION'
%---------------------------------------------------------------
%
%   trial_type definitions:
% - - - - - - - - - - - -
% 11=High-Value GO
% 12=High-Value NOGO
% 22=Low-Value GO
% 24=Low-Value NOGO

% Setting the size of the variables for the loop
%---------------------------
shuff_names = cell(1,total_num_runs);
shuff_ind = cell(1,total_num_runs);
bidIndex = cell(1,total_num_runs);
shuff_bidIndex = cell(1,total_num_runs);
itemnameIndex = cell(1,total_num_runs);
shuff_itemnameIndex = cell(1,total_num_runs);
trialType = cell(1,total_num_runs);
shuff_trialType = cell(1,total_num_runs);
Audio_time = cell(1,total_num_runs);
respTime = cell(1,total_num_runs);
respInTime = cell(1,total_num_runs);
keyPressed = cell(1,total_num_runs);
Ladder1 = cell(1,total_num_runs);
Ladder2 = cell(1,total_num_runs);
actual_onset_time = cell(1,total_num_runs);
fix_time = cell(1,total_num_runs);
fixcrosstime = cell(1,total_num_runs);
Ladder1end = cell(1,total_num_runs);
Ladder2end = cell(1,total_num_runs);
correct = cell(1,total_num_runs);
mean_RT = cell(1,total_num_runs);
meanRT_2runs = cell(1,total_num_runs);
% make it ouput and input if you want this cell array to be filled with all
% the runs

for runNum=runInd:runInd+1 %this for loop only allows 2 runs to be completed
    
    
    anchor=GetSecs ; % (before baseline fixation) ;
    
    %   'load onsets'
    %---------------------------
    r=Shuffle(1:4);
    load(['Onset_files/train_onset_' num2str(r(1)) '.mat']);
    
    
    %   'Write output file header'
    %---------------------------------------------------------------
    c = clock;
    hr = sprintf('%02d', c(4));
    minutes = sprintf('%02d', c(5));
    timestamp=[date,'_',hr,'h',minutes,'m'];
    
    
    fid1=fopen([outputPath '/' subjectID '_training_run_' sprintf('%02d',runNum) '_' timestamp '.txt'], 'a');
    fprintf(fid1,'subjectID order runNum itemName onsetTime shuff_trialType RT respInTime AudioTime response fixationTime ladder1 ladder2 bidIndex itemNameIndex bidValue\n'); %write the header line
    %
    
    %   'pre-trial fixation'
    %---------------------------
    
    firstOrSecond = mod(runNum,2);
    
    switch firstOrSecond
        case 1
            prebaseline=GetSecs;
            % baseline fixation - currently 10 seconds = 4*Volumes (2.5 TR)
            while GetSecs < prebaseline+baseline_fixation
                CenterText(w,'+', white,0,0);
                Screen('TextSize',w, 60);
                Screen(w,'Flip');
            end
        case 0
            prebaseline=GetSecs;
            % baseline fixation - currently 10 seconds = 4*Volumes (2.5 TR)
            while GetSecs < prebaseline+afterrunfixation
                CenterText(w,'+', white,0,0);
                Screen('TextSize',w, 60);
                Screen(w,'Flip');
            end
    end
    
    
    %   Reading everying from the sorted StopGo file - vars has everything
    %---------------------------
    [shuff_names{runNum},shuff_ind{runNum}]=Shuffle(vars{1});
    
    trialType{runNum}=vars{2};
    shuff_trialType{runNum}=trialType{runNum}(shuff_ind{runNum});
    
    bidIndex{runNum}=vars{3};
    shuff_bidIndex{runNum}=bidIndex{runNum}(shuff_ind{runNum});
    
    bidValues{runNum}=vars{4};
    shuff_bidValues{runNum}=bidValues{runNum}(shuff_ind{runNum});
    
    itemnameIndex{runNum}=vars{5};
    shuff_itemnameIndex{runNum}=itemnameIndex{runNum}(shuff_ind{runNum});
    
    %	pre-allocating matrices
    %---------------------------
    Audio_time{runNum}(1:length(shuff_trialType{runNum}),1)=999;
    respTime{runNum}(1:length(shuff_trialType{runNum}),1)=999;
    respInTime{runNum}(1:length(shuff_trialType{runNum}),1)=999;
    keyPressed{runNum}(1:length(shuff_trialType{runNum}),1)=999;
    
    %   reading in images
    %---------------------------
    for i=1:length(shuff_names{runNum})
        food_items{i}=imread(sprintf('stim/%s',shuff_names{runNum}{i}));
    end
    
    %   ladders
    %---------------------------
    if runNum == runInd
        % above we define LADDER1IN & LADDER2IN for the input_runNum: they are EITHER the end ladder value
        % from the previous run or 750 & 750 (start points)
        
        Ladder1{runNum}(1,1)=LADDER1IN;
        Ladder2{runNum}(1,1)=LADDER2IN;
        
    else
        % otherwise, Ladder values are from the previous run (stored within this function)
        
        Ladder1{runNum}(1,1)=Ladder1end{runInd};
        Ladder2{runNum}(1,1)=Ladder2end{runInd};
        
    end
    
    
    %   Loop thru all trials in a run
    %---------------------------
    runStartTime=GetSecs-anchor;
    
%     for trialNum=1:length(shuff_trialType{runNum})/10; % shorter version
%     for debugging
    for trialNum=1:length(shuff_trialType{runNum})   % To cover all the items in one run.
        
        Screen('PutImage',w,food_items{trialNum});
        Screen('Flip',w,anchor+onsets(trialNum)+runStartTime); % display images according to Onset times
        image_start_time = GetSecs;
        actual_onset_time{runNum}(trialNum,1)=image_start_time-anchor ;
        
        noresp=1;
        notone=1;
        KbQueueStart;
        
        %---------------------------------------------------
        %% 'EVALUATE RESPONSE & ADJUST LADDER ACCORDINGLY'
        %---------------------------------------------------
        while (GetSecs-image_start_time < image_duration),
            
            %High-Valued BEEP items
            %---------------------------
            if  shuff_trialType{runNum}(trialNum)==11 && (GetSecs - image_start_time >=Ladder1{runNum}(length(Ladder1{runNum}),1)/1000) && notone %shuff_trialType contains the information if a certain image is a GO/NOGO trial
                
                
                % Beep!
                PsychPortAudio('FillBuffer', pahandle, wave);
                PsychPortAudio('Start', pahandle, 1, 0, 0);
                notone=0;
                Audio_time{runNum}(trialNum,1)=GetSecs-image_start_time;
                
                
                %   look for response
                [pressed, firstPress, ~, ~, ~] = KbQueueCheck;
                if pressed && noresp
                    findfirstPress=find(firstPress);
                    respTime{runNum}(trialNum,1) = firstPress(findfirstPress(1))-image_start_time;
                    
                    tmp = KbName(firstPress);
                    if ischar(tmp)==0 % if 2 keys are hit at once, they become a cell, not a char. we need keyPressed{runnum} to be a char, so this converts it and takes the first key pressed
                        tmp=char(tmp);
                    end
                    keyPressed{runNum}(trialNum,1) = tmp(1);
                    
                    
                    %   different response types in scanner or in testing room
                    if test_comp == 1
                        if keyPressed{runNum}(trialNum,1)==blue || keyPressed{runNum}(trialNum,1)==yellow
                            noresp=0;
                            
                            if respTime{runNum}(trialNum,1) < Ladder1{runNum}(length(Ladder1{runNum}),1)/1000
                                respInTime{runNum}(trialNum,1)=11; %was a GO trial with HV item but responded before SS
                            else
                                respInTime{runNum}(trialNum,1)=110; %was a Go trial with HV item but responded after SS within 1000 msec
                            end
                        end
                    else
                        
                        if keyPressed{runNum}(trialNum,1)==BUTTON %| keyPressed{runnum}(trialnum,1)==RIGHT
                            noresp=0;
                            
                            if respTime{runNum}(trialNum,1) < Ladder1{runNum}(length(Ladder1{runNum}),1)/1000
                                respInTime{runNum}(trialNum,1)=11; %was a GO trial with HV item but responded before SS
                            else
                                respInTime{runNum}(trialNum,1)=110; %was a Go trial with HV item and responded after SS within 1000 msec - good trial
                            end
                        end
                    end % if test_comp == 1
                    
                end
                
                %Low-Valued BEEP items
                %---------------------------
            elseif  shuff_trialType{runNum}(trialNum)==22 && (GetSecs - image_start_time >=Ladder2{runNum}(length(Ladder2{runNum}),1)/1000) && notone %shuff_trialType contains the information if a certain image is a GO/NOGO trial
                
                % Beep!
                PsychPortAudio('FillBuffer', pahandle, wave);
                PsychPortAudio('Start', pahandle, 1, 0, 0);
                notone=0;
                Audio_time{runNum}(trialNum,1)=GetSecs-image_start_time;
                
                
                %   look for response
                [pressed, firstPress, ~, ~, ~] = KbQueueCheck;
                if pressed && noresp
                    findfirstPress=find(firstPress);
                    respTime{runNum}(trialNum,1) = firstPress(findfirstPress(1))-image_start_time;
                    
                    tmp = KbName(firstPress);
                    if ischar(tmp)==0 % if 2 keys are hit at once, they become a cell, not a char. we need keyPressed{runnum} to be a char, so this converts it and takes the first key pressed
                        tmp=char(tmp);
                    end
                    keyPressed{runNum}(trialNum,1) = tmp(1);
                    
                    %   different response types in scanner or in testing room
                    if test_comp == 1
                        if keyPressed{runNum}(trialNum,1)==blue || keyPressed{runNum}(trialNum,1)==yellow
                            noresp=0;
                            if respTime{runNum}(trialNum,1) < Ladder2{runNum}(length(Ladder2{runNum}),1)/1000
                                respInTime{runNum}(trialNum,1)=22; %was a GO trial with LV item but responded before SS
                            else
                                respInTime{runNum}(trialNum,1)=220; %was a Go trial with LV item but responded after SS within 1000 msec
                            end
                        end
                    else
                        if keyPressed{runNum}(trialNum,1)==BUTTON %| keyPressed{runnum}(trialnum,1)==RIGHT
                            noresp=0;
                            if respTime{runNum}(trialNum,1) < Ladder2{runNum}(length(Ladder2{runNum}),1)/1000
                                respInTime{runNum}(trialNum,1)=22;  %was a GO trial with LV item but responded before SS
                            else
                                respInTime{runNum}(trialNum,1)=220; %was a Go trial with LV item and responded after SS within 1000 msec - good trial
                            end
                        end
                    end % if test_comp == 1
                    
                end % end if pressed && noresp
                
                %No-BEEP
                %---------------------------
            elseif   mod(shuff_trialType{runNum}(trialNum),11)~=0 && noresp % these will now be the NOGO trials
                
                %   look for response
                [pressed, firstPress, ~, ~, ~] = KbQueueCheck;
                if pressed && noresp
                    findfirstPress=find(firstPress);
                    respTime{runNum}(trialNum,1) = firstPress(findfirstPress(1))-image_start_time;
                    tmp = KbName(firstPress);
                    if ischar(tmp)==0 % if 2 keys are hit at once, they become a cell, not a char. we need keyPressed{runnum} to be a char, so this converts it and takes the first key pressed
                        tmp=char(tmp);
                    end
                    keyPressed{runNum}(trialNum,1) = tmp(1);
                    
                    %   different response types in scanner or in testing room
                    if test_comp == 1
                        if keyPressed{runNum}(trialNum,1)==blue || keyPressed{runNum}(trialNum,1)==yellow
                            noresp=0;
                            if shuff_trialType{runNum}(trialNum)==12
                                respInTime{runNum}(trialNum,1)=12; % a stop trial but responded within 1000 msec HV item - not good but don't do anything
                            else
                                respInTime{runNum}(trialNum,1)=24; % a stop trial but responded within 1000 msec LV item - not good but don't do anything
                            end
                        end
                    else
                        if keyPressed{runNum}(trialNum,1)==BUTTON %| keyPressed{runnum}(trialnum,1)==RIGHT
                            noresp=0;
                            if shuff_trialType{runNum}(trialNum)==12
                                respInTime{runNum}(trialNum,1)=12; %% a stop trial but responded within 1000 msec HV item - not good but don't do anything
                            else
                                respInTime{runNum}(trialNum,1)=24; %% a stop trial but responded within 1000 msec LV item - not good but don't do anything
                            end
                        end
                    end % end if test+comp == 1
                    
                end % end if pressed && noresp
            end %evaluate trial_type
            
        end %%% End big while waiting for response within 1000 msec
        
        %   Close the Audio port
        %---------------------------
        PsychPortAudio('Stop', pahandle);
        
        
        %   Show fixation
        %---------------------------
        CenterText(w,'+', white,0,0);
        Screen('TextSize',w, 60);
        Screen(w,'Flip', image_start_time+1);
        fix_time{runNum}(trialNum,1)=GetSecs ;
        fixcrosstime{runNum} = GetSecs;
        
        
        
        %   if noresp
        %---------------------------
        % these are additional 500msec to monitor responses
        
        while (GetSecs-fix_time{runNum}(trialNum,1)< 0.5)
            
            [pressed, firstPress, ~, ~, ~] = KbQueueCheck;
            if pressed && noresp
                findfirstPress=find(firstPress);
                respTime{runNum}(trialNum,1) = firstPress(findfirstPress(1))-image_start_time;
                
                tmp = KbName(firstPress);
                if ischar(tmp)==0 % if 2 keys are hit at once, they become a cell, not a char. we need keyPressed{runnum} to be a char, so this converts it and takes the first key pressed
                    tmp=char(tmp);
                end
                keyPressed{runNum}(trialNum,1) = tmp(1);
                if test_comp==1
                    if keyPressed{runNum}(trialNum,1)==blue || keyPressed{runNum}(trialNum,1)==yellow
                        noresp=0;
                        switch shuff_trialType{runNum}(trialNum)
                            case 11
                                if respTime{runNum}(trialNum,1)>=1
                                    respInTime{runNum}(trialNum,1)=1100; % a Go trial and  responded after 1000msec  HV item - make it easier decrease SSD
                                elseif respTime{runNum}(trialNum,1)<1
                                    respInTime{runNum}(trialNum,1)=110;
                                end
                            case 22
                                if respTime{runNum}(trialNum,1)>=1
                                    respInTime{runNum}(trialNum,1)=2200; % a Go trial and  responded after 1000msec  HV item - make it easier decrease SSD
                                elseif respTime{runNum}(trialNum,1)<1
                                    respInTime{runNum}(trialNum,1)=220;
                                end
                            case 12
                                respInTime{runNum}(trialNum,1)=12; % a stop trial and responded after 1000 msec  HV item - don't touch
                            case 24
                                respInTime{runNum}(trialNum,1)=24; % % a stop trial and  responded after 1000 msec HV item - don't touch
                        end
                    end
                    
                else
                    
                    if keyPressed{runNum}(trialNum,1)==BUTTON % | keyPressed{runnum}(trialnum,1)==RIGHT
                        noresp=0;
                        switch shuff_trialType{runNum}(trialNum)
                            case 11
                                if respTime{runNum}(trialNum,1)>=1
                                    respInTime{runNum}(trialNum,1)=1100;% a Go trial and responded after 1000msec  HV item  - make it easier decrease SSD
                                elseif respTime{runNum}(trialNum,1)<1
                                    respInTime{runNum}(trialNum,1)=110;% a Go trial and responded before 1000msec  HV item  -  make it harder increase SSD/3
                                end
                            case 22
                                if respTime{runNum}(trialNum,1)>1
                                    respInTime{runNum}(trialNum,1)=2200;% a Go trial and responded after 1000msec  LV item - - make it easier decrease SSD
                                elseif respTime{runNum}(trialNum,1)<1
                                    respInTime{runNum}(trialNum,1)=220;% a Go trial and responded before 1000msec  LV item - - make it harder increase SSD/3
                                end
                            case 12
                                respInTime{runNum}(trialNum,1)=12;% a NOGO trial and didnt respond on time HV item - don't touch
                            case 24
                                respInTime{runNum}(trialNum,1)=24;% a NOGO trial and didnt respond on time LV item - don't touch
                                
                        end
                    end
                end % end if test_comp == 1
            end % end if pressed && noresp
        end % End while of additional 500 msec
        
        %%	This is where its all decided !
        %---------------------------
        if noresp
            switch shuff_trialType{runNum}(trialNum)
                case 11
                    respInTime{runNum}(trialNum,1)=1; %unsuccessful Go trial HV - didn't press a button at all - trial too hard - need to decrease ladder
                case 22
                    respInTime{runNum}(trialNum,1)=2; % unsuccessful Go trial LV - didn't press a button at all - trial too hard - need to decrease ladder
                case 12
                    respInTime{runNum}(trialNum,1)=120; % ok NOGO trial didn't respond after 1500 msec in NOGO trial HV
                case 24
                    respInTime{runNum}(trialNum,1)=240; % ok NOGO trial didn't respond after 1500 msec in NOGO trial LV
            end
        end
        
        
        switch respInTime{runNum}(trialNum,1)
            case 1 % didn't respond even after 1500 msec on HV GO trial - make it easier decrease SSD by step
                if (Ladder1{runNum}(length(Ladder1{runNum}),1)<0.001)
                    Ladder1{runNum}(length(Ladder1{runNum})+1,1)=Ladder1{runNum}(length(Ladder1{runNum}),1);
                else
                    Ladder1{runNum}(length(Ladder1{runNum})+1,1)=Ladder1{runNum}(length(Ladder1{runNum}),1)-Step;
                end;
                
            case 2 % didn't respond even after 1500 msec on LV GO trial - make it easier decrease SSD by step
                if (Ladder2{runNum}(length(Ladder2{runNum}),1)<0.001)
                    Ladder2{runNum}(length(Ladder2{runNum})+1,1)=Ladder2{runNum}(length(Ladder2{runNum}),1);
                else
                    Ladder2{runNum}(length(Ladder2{runNum})+1,1)=Ladder2{runNum}(length(Ladder2{runNum}),1)-Step;
                end;
                
                
            case 1100 %  responded after 1500 msec on HV GO trial - make it easier decrease SSD by step
                if (Ladder1{runNum}(length(Ladder1{runNum}),1)<0.001)
                    Ladder1{runNum}(length(Ladder1{runNum})+1,1)=Ladder1{runNum}(length(Ladder1{runNum}),1);
                else
                    Ladder1{runNum}(length(Ladder1{runNum})+1,1)=Ladder1{runNum}(length(Ladder1{runNum}),1)-Step;
                end;
                
            case 2200 %  responded after 1500 msec on LV GO trial - make it easier decrease SSD by step
                if (Ladder2{runNum}(length(Ladder2{runNum}),1)<0.001)
                    Ladder2{runNum}(length(Ladder2{runNum})+1,1)=Ladder2{runNum}(length(Ladder2{runNum}),1);
                else
                    Ladder2{runNum}(length(Ladder2{runNum})+1,1)=Ladder2{runNum}(length(Ladder2{runNum}),1)-Step;
                end;
                
                
                
            case 11
                if (Ladder1{runNum}(length(Ladder1{runNum}),1)>999.999); %was a GO trial with HV item but responded before SS make it harder - increase SSD by Step/3
                    Ladder1{runNum}(length(Ladder1{runNum})+1,1)=Ladder1{runNum}(length(Ladder1{runNum}),1);
                else
                    Ladder1{runNum}(length(Ladder1{runNum})+1,1)=Ladder1{runNum}(length(Ladder1{runNum}),1)+Step/3;
                end;
                
            case 22
                if (Ladder2{runNum}(length(Ladder2{runNum}),1)>999.999); %was a GO trial with LV item but responded before SS make it harder - - increase SSD by Step/3
                    Ladder2{runNum}(length(Ladder2{runNum})+1,1)=Ladder2{runNum}(length(Ladder2{runNum}),1);
                else
                    Ladder2{runNum}(length(Ladder2{runNum})+1,1)=Ladder2{runNum}(length(Ladder2{runNum}),1)+Step/3;
                end;
                
            case 110 % pressed after Go signal but below 1000 - - increase SSD by Step/3 - these are the good trials!
                if (Ladder1{runNum}(length(Ladder1{runNum}),1)>999.999);
                    Ladder1{runNum}(length(Ladder1{runNum})+1,1)=Ladder1{runNum}(length(Ladder1{runNum}),1);
                else
                    Ladder1{runNum}(length(Ladder1{runNum})+1,1)=Ladder1{runNum}(length(Ladder1{runNum}),1)+Step/3;
                end;
                
            case 220 % pressed after Go signal but below 1000 - - increase SSD by Step/3 - these are the good trials!
                if (Ladder2{runNum}(length(Ladder2{runNum}),1)>999.999);
                    Ladder2{runNum}(length(Ladder2{runNum})+1,1)=Ladder2{runNum}(length(Ladder2{runNum}),1);
                else
                    Ladder2{runNum}(length(Ladder2{runNum})+1,1)=Ladder2{runNum}(length(Ladder2{runNum}),1)+Step/3;
                end;
                
        end % end switch respInTime{runNum}(trialNum,1)
        KbQueueFlush;
        
        
        %   'Save data'
        %---------------------------
        
        fprintf(fid1,'%s %d %d %s %d %d %d %d %d %d %d %.2f %.2f %.2f %d %.2f \n', subjectID, order, runNum, shuff_names{runNum}{trialNum}, actual_onset_time{runNum}(trialNum,1), shuff_trialType{runNum}(trialNum), respTime{runNum}(trialNum,1)*1000, respInTime{runNum}(trialNum,1), Audio_time{runNum}(trialNum,1)*1000, keyPressed{runNum}(trialNum,1),   fix_time{runNum}(trialNum,1)-anchor, Ladder1{runNum}(length(Ladder1{runNum})), Ladder2{runNum}(length(Ladder2{runNum})), shuff_bidIndex{runNum}(trialNum,1), shuff_itemnameIndex{runNum}(trialNum,1),shuff_bidValues{runNum}(trialNum,1));
%         dataToSave = {num2str(trialNum), shuff_names{runNum}{trialNum}, actual_onset_time{runNum}(trialNum,1), shuff_trialType{runNum}(trialNum), respTime{runNum}(trialNum,1)*1000, respInTime{runNum}(trialNum,1), Audio_time{runNum}(trialNum,1)*1000, keyPressed{runNum}(trialNum,1),   fix_time{runNum}(trialNum,1)-anchor, Ladder1{runNum}(length(Ladder1{runNum})), Ladder2{runNum}(length(Ladder2{runNum})), shuff_bidIndex{runNum}(trialNum,1), shuff_itemnameIndex{runNum}(trialNum,1), shuff_bidValues{runNum}(trialNum,1)};
%         dataRange = ['A' num2str(6+trialNum)];
%         xlsheet = ['Run' num2str(runNum) '_noEyetrack'];
%         xlswrite(xlsfilename,dataToSave,xlsheet,dataRange);
%         timestamp_cell={timestamp};
%         xlswrite(xlsfilename,timestamp_cell,xlsheet,'B3');
        
        
        
    end; %	End the big trialnum loop showing all the images in one run.
    
    
    
    Ladder1end{runNum}=Ladder1{runNum}(length(Ladder1{runNum}));
    Ladder2end{runNum}=Ladder2{runNum}(length(Ladder2{runNum}));
    correct{runNum}(1)=0;
    
    correct{runNum}(1)= length(find(respInTime{runNum}==110 | respInTime{runNum}==220 ));
    mean_RT{runNum}=mean(respTime{runNum}(respInTime{runNum}==110 | respInTime{runNum}==220));
    
    % afterrun fixation
    % ---------------------------
    postexperiment=GetSecs;
    while GetSecs < postexperiment+afterrunfixation;
        CenterText(w,'+', white,0,0);
        Screen('TextSize',w, 60);
        Screen(w,'Flip');
        
    end
    
    switch firstOrSecond
        case 0
            meanRT_2runs{runNum}=(mean_RT{runNum-1}+mean_RT{runNum})/2;
            Screen('TextSize', w, 40); %Set textsize
            %             CenterText(w,strcat(sprintf('You responded on %.2f', ((correct{runnum-1}(1)+correct{runnum}(1)))/32*100), '% of Go trials'), white, 0,-270);
            CenterText(w,strcat(sprintf('You responded on %.2f', (correct{runNum}(1))/16*100), '% of BEEP trials'), white, 0,-300);
            CenterText(w,sprintf('Press any key to continue to the next run') ,Green,0,-100);
            Screen('Flip',w);
            
            noresp=1;
            while noresp,
                [keyIsDown,~,~] = KbCheck;
                if keyIsDown && noresp,
                    noresp=0;
                end;
            end;
            WaitSecs(0.5);
    end
    
    
end%%% End the run loop to go over all the runs

%---------------------------------------------------------------
%%   save data to a file & close out
%---------------------------------------------------------------
% outfile=strcat(outputPath, '/', subjectID,'_training_run', sprintf('%02d',runInd),'_to_run', sprintf('%02d',runNum), '_eyetracking_', timestamp,'.edf');
outfile=strcat(outputPath, '/', subjectID,'_training_run', sprintf('%02d',runInd),'_to_run', sprintf('%02d',runNum), '_eyetracking_', timestamp,'.mat');
% create a data structure with info about the run
run_info.subject=subjectID;
run_info.date=date;
run_info.outfile=outfile;
run_info.script_version=script_version;
run_info.revision_date=revision_date;
run_info.script_name=mfilename;
clear food_items ;

save(outfile);


% Close the audio device:
PsychPortAudio('Close', pahandle);

%   write Ladders info to txt file
% ------------------------------
fid2=fopen([outputPath '\' subjectID sprintf('_ladders_run_%d.txt', runNum)], 'w');
fprintf(fid2,'Ladder1 Ladder2 runnum \n'); %write the header line
fprintf(fid2, '%d \t %d \t %d \t \n', Ladder1{runNum}(length(Ladder1{runNum})), Ladder2{runNum}(length(Ladder2{runNum})),runNum);
fprintf(fid2, '\n');
fclose(fid2);

%   outgoing msg
% ------------------------------
Screen('TextSize',w,36);
Screen('TextFont',w,'Ariel');

if firstOrSecond == 0 % this is the second out of the two consecutive runs
    if runNum == total_num_runs % this is the final training run
        CenterText(w,'Part 3 will begin soon', white, 0, -270);
        CenterText(w,'Please read the Part 3 instructions in front of you,',white, 0,-170);
        CenterText(w,'then press any key to proceed with Part 3 on your own.',Green, 0,-70);
        Screen('Flip',w);
        
        noresp=1;
        while noresp,
            [keyIsDown,~,~] = KbCheck;%(experimenter_device);
            if keyIsDown && noresp,
                noresp=0;
            end;
        end;
        WaitSecs(0.001);
        KbQueueFlush;
        
        Screen('CloseAll');
        ShowCursor;
    else
        CenterText(w,'Another run of the same task with the same instructions will start soon.', white, 0, -270);
        CenterText(w,'Thank you!',white, 0,-170);
        Screen('Flip',w);
        WaitSecs(2);
    end
end


end % end function

