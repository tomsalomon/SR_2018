
function binary_ranking_demo(subjid,test_comp,stimuli,path)


%=========================================================================
% Probe task code
%=========================================================================

% %---dummy info for testing purposes --------
% subjid='BM2_000';
% order=1;
% test_comp=0;
% sessNum = 1;

%==============================================
%% 'GLOBAL VARIABLES'
%==============================================

%'stimuli' - new meaning (Tom's experiments) - 1 for snacks, 2 for faces, 3
%for fractals
% 'block' indicates how many times the subject has completed all
% 64 trials of the probe experiment.  Therefore, the first time the subj completes
% a probe block on his/her 2nd session, it is actually probe block 3 for
% that person:

block = 1;

%   'timestamp'
% - - - - - - - - - - - - - - - - -
c = clock;
hr = sprintf('%02d', c(4));
min = sprintf('%02d', c(5));
timestamp=[date,'_',hr,'h',min,'m'];
rand('state',sum(100*clock));


%   'set phase times'
% - - - - - - - - - - - - - - - - -
maxtime=2.5;      % 2.5 second limit on each selection
baseline_fixation_dur=0.5; % Need to modify based on if first few volumes are saved or not
afterrunfixation=0.5;

tic
%==============================================
%% 'INITIALIZE Screen variables'
%==============================================
Screen('Preference', 'VisualDebuglevel', 3); %No PTB intro screen
screennum = max(Screen('Screens'));

pixelSize=32;
% [w] = Screen('OpenWindow',screennum,[],[0 0 640 480],pixelSize);% %debugging screensize
[w] = Screen('OpenWindow',screennum,[],[],pixelSize);

HideCursor;


% Define Colors
% - - - - - - - - - - - - - - -
black=BlackIndex(w); % Should equal 0.
white=WhiteIndex(w); % Should equal 255.
yellow=[0 255 0];

Screen('FillRect', w, black);  % NB: only need to do this once!
Screen('Flip', w);


% text stuffs
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

% HideCursor;

%==============================================
%% 'ASSIGN response keys'
%==============================================
KbName('UnifyKeyNames');
%MRI=0;
switch test_comp
    case {0,2,3}
        leftstack='u';
        rightstack= 'i';
        badresp='x';
    case 1
        leftstack='b';
        rightstack= 'y';
        badresp='x';
end



%==============================================
%% 'Read in data'
%==============================================

%   'read in sorted file'
% - - - - - - - - - - - - - - - - -
if stimuli==1;
    fid=fopen([path,'\Stimuli_List_snack_demo.txt']);
    stimuli_type='snacks';
elseif stimuli==2
    fid=fopen([path,'\Stimuli_List_face_demo.txt']);
        stimuli_type='faces';
        elseif stimuli==3
    fid=fopen([path,'\Stimuli_List_fractal_demo.txt']);
        stimuli_type='fractal';
end

data=textscan(fid, '%s') ;% these contain everything from the sortbdm
stimname=data{1};

%   'load image arrays'
% - - - - - - - - - - - - - - -
for i=1:length(stimname)
    food_items{i}=imread(sprintf('%s',path,'\stim\demo\',stimname{i}));
end

% for i=1:length(stimname)
%     food_items{i}=imread(sprintf('stim/%s',stimname{i}));
% end

%   'load onsets'
% - - - - - - - - - - - - - - -

% onsetlist=load([path,'Dropbox\Experiment_Israel\Codes\Boost_Israel\Face_exp\onsets_new_colley.mat']);
% onsetlist=onsetlist.onsets_new; % onset list is determined to be: onsetlist=0:2.5:250;
onsetlist=0:3.5:1200;

%==============================================
%%   'PRE-TRIAL DATA ORGANIZATION'
%==============================================

n=length(stimname);
number_of_trials=4; 

% craete two lists of all possible non-ovelapping comparisons
shuffle_stimlist1=[1,2,3,4];
shuffle_stimlist2=[4,3,1,2];

%  ==================================
%  Create the Colley's ranking analysis variables
%  ==================================
N=zeros(n,3); %create the C matrix of (win,loses,total) for each stimulus (each row represent a specific stimulus). To be used in Colley's ranking
T=zeros(n,n); %create the T symetric matrix of "competitions"  (each row represent a specific stimulus). T(a,b)=T(b,a)=-1 means a "competition" had taken place between stimuli a&b. To be used in Colley's ranking

for stimulus=1:n
    T(stimulus,shuffle_stimlist1(shuffle_stimlist2==stimulus))=-1;
    T(shuffle_stimlist1(shuffle_stimlist2==stimulus),stimulus)=-1;
    T(stimulus,shuffle_stimlist2(shuffle_stimlist1==stimulus))=-1;
    T(shuffle_stimlist2(shuffle_stimlist1==stimulus),stimulus)=-1;
    
    N(stimulus,3)=(sum(shuffle_stimlist1==stimulus)+sum(shuffle_stimlist2==stimulus));
end



% 
% %-----------------------------------------------------------------
% %% 'Write output file header'
% %-----------------------------------------------------------------
% fid1=fopen([path,'Dropbox\Experiment_Israel\Codes\Boost_Israel\Face_exp\Output\' subjid '_' stimuli_type sprintf('_probe_ranking_'), timestamp '.txt'], 'a');
% fprintf(fid1,'subjid runtrial onsettime ImageLeft ImageRight StimNumLeft StimNumRight Response Outcome RT \n'); %write the header line




%==============================================
%% 'Display Main Instructions'
%==============================================
KbQueueCreate;
Screen('TextSize',w, 40);

%%% While they are waiting for the trigger
if test_comp==1
    Screen('TextSize',w, 60);
    CenterText(w,'Selection Test:', white,0,-325);
       
    escapeKey = KbName('t');
    while 1
        [keyIsDown,secs,keyCode] = KbCheck(-1);
        if keyIsDown && keyCode(escapeKey)
            break;
        end
    end
    
    DisableKeysForKbCheck(KbName('t')); % So trigger is no longer detected
else
    Screen('TextSize',w, 60);
        Screen('TextSize',w, 60);
        CenterText(w,'Part 1 - Demo', white,0,-500);

     if stimuli==1
    Screen('TextSize',w, 40);
    CenterText(w,'In this part two pictures of food items will be presented on the Screen.', white,0,-270);
    CenterText(w,'For each trial, we want you to choose one of the items using the keyboard.', white,0,-215);
    CenterText(w,'You will have 2.5 seconds to make your choice on each trial, so please', white,0,-160);
    CenterText(w,'try to make your choice quickly.', white,0,-105);
    CenterText(w,'At the end of this part we will choose one trial at random and', white,0,-50);
    CenterText(w,'honor your choice on that trial and give you the food item.', white,0,5);
    CenterText(w,'Press the `u` and `i` keys for the left and right items respectively.', white,0,60);
    CenterText(w,'Press any key to start.', white, 0, 180);
 
    elseif  stimuli==2
    Screen('TextSize',w, 40);
    CenterText(w,'In this part two pictures of faces will be presented on the Screen.', white,0,-270);
    CenterText(w,'For each trial, we want you to choose one of the faces using the keyboard.', white,0,-215);
    CenterText(w,'You will have 2.5 seconds to make your choice on each trial, so please', white,0,-160);
    CenterText(w,'try to make your choice quickly.', white,0,-105);
%     CenterText(w,'At the end of this part we will choose one trial at random and', white,0,-50);
%     CenterText(w,'honor your choice on that trial and give you the food item.', white,0,5);
    CenterText(w,'Press the `u` and `i` keys for the left and right items respectively.', white,0,60);
    CenterText(w,'Press any key to start.', white, 0, 180);    
        
         elseif  stimuli==3
    Screen('TextSize',w, 40);
    CenterText(w,'In this part two pictures of fractals will be presented on the Screen.', white,0,-270);
    CenterText(w,'For each trial, we want you to choose one of the faces using the keyboard.', white,0,-215);
    CenterText(w,'You will have 2.5 seconds to make your choice on each trial, so please', white,0,-160);
    CenterText(w,'try to make your choice quickly.', white,0,-105);
%     CenterText(w,'At the end of this part we will choose one trial at random and', white,0,-50);
%     CenterText(w,'honor your choice on that trial and give you the food item.', white,0,5);
    CenterText(w,'Press the `u` and `i` keys for the left and right items respectively.', white,0,60);
    CenterText(w,'Press any key to start.', white, 0, 180);    
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


% % % % % % % % STEP 5 of Eyetracker Initialization
% % % % % % % % start recording eye position
% % % % % % % % - - - - - - - - - - - - -
% % % % % % % Eyelink('StartRecording');
% % % % % % % WaitSecs(.05);
% % % % % % % Eyelink('Message', 'SYNCTIME after fixations'); % mark start time in file


%==============================================
%% 'Run Trials'
%==============================================



runtrial=1;
runStart=GetSecs;

% % % % % % %     % Eyelink msg
% % % % % % %     % - - - - - - -
% % % % % % % Eyelink('Message', strcat('block', sprintf('%02d', block), 'Start=',num2str(runStart)));

for trial=1:number_of_trials
    
    chose_rand=rand;
    if chose_rand<=0.5
        leftname(trial)=stimname(shuffle_stimlist1(trial));
        rightname(trial)=stimname(shuffle_stimlist2(trial));
    else
        leftname(trial)=stimname(shuffle_stimlist2(trial));
        rightname(trial)=stimname(shuffle_stimlist1(trial));
    end
    
    KbQueueStart;
    % % % % % % %
    % % % % % % %         % Eyelink msg
    % % % % % % %         % - - - - - - -
    % % % % % % %         trialmessage=strcat('trial ',num2str(trial));
    % % % % % % %         Eyelink('Message',trialmessage);
    
    
    
    % initial box outline colors
    % - - - - - - -
    colorleft=black;
    colorright=black;
    out=999;
    
    %-----------------------------------------------------------------
    % display images
    %-----------------------------------------------------------------
    if chose_rand<=0.5
        Screen('PutImage',w,food_items{shuffle_stimlist1(trial)}, leftRect);
        Screen('PutImage',w,food_items{shuffle_stimlist2(trial)}, rightRect);
    else
        Screen('PutImage',w,food_items{shuffle_stimlist2(trial)}, leftRect);
        Screen('PutImage',w,food_items{shuffle_stimlist1(trial)}, rightRect);
    end
    CenterText(w,'+', white,0,0);
    StimOnset=Screen(w,'Flip', runStart+onsetlist(runtrial)+baseline_fixation);
    
    
    
    % % % % % % %     % Eyelink msg
    % % % % % % %     % - - - - - - -
    % % % % % % %     onsetmessage=num2str(StimOnset-runStart);
    % % % % % % %     Eyelink('Message',onsetmessage);
    
    
    %-----------------------------------------------------------------
    % get response
    %-----------------------------------------------------------------
    
    noresp=1;
    goodresp=0;
    while noresp
        
        % check for response
        [keyIsDown, firstPress] = KbQueueCheck;
        
        if keyIsDown && noresp
            keyPressed=KbName(firstPress);
            
            if ischar(keyPressed)==0 % if 2 keys are hit at once, they become a cell, not a char. we need keyPressed to be a char, so this converts it and takes the first key pressed
                keyPressed=char(keyPressed);
                keyPressed=keyPressed(1);
            end
            
            switch keyPressed
                case leftstack
                    respTime=firstPress(KbName(leftstack))-StimOnset;
                    noresp=0;
                    goodresp=1;
                case rightstack
                    respTime=firstPress(KbName(rightstack))-StimOnset;
                    noresp=0;
                    goodresp=1;
            end
            
            % % % % % % %             % Eyelink msg
            % % % % % % %             % - - - - - - -
            % % % % % % %             rtstr = strcat('responsetime=',num2str(respTime));
            % % % % % % %             Eyelink('Message',rtstr);
            % % % % % % %
        end
        
        
        % check for reaching time limit
        if noresp && GetSecs-runStart >= onsetlist(runtrial)+baseline_fixation+maxtime
            noresp=0;
            keyPressed=badresp;
            respTime=maxtime;
            
            
            % % % % % % %             % Eyelink msg
            % % % % % % %             % - - - - - - -
            % % % % % % %             rtstr = strcat('responsetime=maxtime ',num2str(respTime));
            % % % % % % %             Eyelink('Message',rtstr);
            
        end
    end
    
    %-----------------------------------------------------------------
    % determine what bid to highlight
    %-----------------------------------------------------------------
    
    switch keyPressed
        case leftstack
            colorleft=yellow;
            if shuffle_stimlist2(trial)==0
                out=1;
            else
                out=0;
            end
        case rightstack
            colorright=yellow;
            if shuffle_stimlist2(trial)==1
                out=1;
            else
                out=0;
            end
    end
    
    if goodresp==1
        
        if chose_rand<=0.5
            Screen('PutImage',w,food_items{shuffle_stimlist1(trial)}, leftRect);
            Screen('PutImage',w,food_items{shuffle_stimlist2(trial)}, rightRect);
        else
            Screen('PutImage',w,food_items{shuffle_stimlist2(trial)}, leftRect);
            Screen('PutImage',w,food_items{shuffle_stimlist1(trial)}, rightRect);
         
        end
        
        if keyPressed=='u'
            Screen('FrameRect', w, colorleft, leftRect, penWidth);
        elseif keyPressed=='i'
            Screen('FrameRect', w, colorright, rightRect, penWidth);
        end
            
%         Screen('FrameRect', w, colorleft, leftRect, penWidth);
%         Screen('FrameRect', w, colorright, rightRect, penWidth);
        CenterText(w,'+', white,0,0);
        Screen(w,'Flip',runStart+onsetlist(trial)+respTime+baseline_fixation);
        
    else
        Screen('DrawText', w, 'You must respond faster!', xcenter-450, ycenter, white);
        Screen(w,'Flip',runStart+onsetlist(runtrial)+respTime+baseline_fixation);
    end
    
    
    %-----------------------------------------------------------------
    % show fixation ITI
    %-----------------------------------------------------------------
    
    
    CenterText(w,'+', white,0,0);
    Screen(w,'Flip',runStart+onsetlist(runtrial)+respTime+.5+baseline_fixation);
    
    
    % % % % % % %     % Eyelink msg
    % % % % % % %     % - - - - - - -
    % % % % % % %     fixcrosstime = strcat('fixcrosstime=',num2str(runStart+onsetlist(runtrial)+respTime+.5+baseline_fixation));
    % % % % % % %     Eyelink('Message',fixcrosstime);
    
    
    if goodresp ~= 1
        respTime=999;
    end
    
    
    
    %-----------------------------------------------------------------
    % write to output file
    %-----------------------------------------------------------------
%     if chose_rand<=0.5
%         fprintf(fid1,'%s %d %d %s %s %d %d %s %d %d\n', subjid, runtrial, StimOnset-runStart, char(leftname(trial)), char(rightname(trial)), shuffle_stimlist1(trial), shuffle_stimlist2(trial), keyPressed, out, respTime*1000);
%     else
%         fprintf(fid1,'%s %d %d %s %s %d %d %s %d %d\n', subjid, runtrial, StimOnset-runStart, char(leftname(trial)), char(rightname(trial)), shuffle_stimlist2(trial), shuffle_stimlist1(trial), keyPressed,  out, respTime*1000);
%     end
    
    if chose_rand<=0.5 
        if keyPressed=='u'
        N(shuffle_stimlist1(trial),1)=N(shuffle_stimlist1(trial),1)+1;
        N(shuffle_stimlist2(trial),2)=N(shuffle_stimlist2(trial),2)+1;
        elseif keyPressed=='i'
        N(shuffle_stimlist2(trial),1)=N(shuffle_stimlist2(trial),1)+1;
        N(shuffle_stimlist1(trial),2)=N(shuffle_stimlist1(trial),2)+1;
        end
    else
        if keyPressed=='i'
        N(shuffle_stimlist1(trial),1)=N(shuffle_stimlist1(trial),1)+1;
        N(shuffle_stimlist2(trial),2)=N(shuffle_stimlist2(trial),2)+1;
        elseif keyPressed=='u'
        N(shuffle_stimlist2(trial),1)=N(shuffle_stimlist2(trial),1)+1;
        N(shuffle_stimlist1(trial),2)=N(shuffle_stimlist1(trial),2)+1;
        end 
    end
    
    runtrial=runtrial+1;
    KbQueueFlush;
    
end % loop through trials
% fclose(fid1);

EndofBlock1Time=GetSecs;

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

if mod(block,2) == 1
    
    %if block is an odd number
    CenterText(w,sprintf('Thank you! Please call the experimenter.') ,white,0,-170);
    
% elseif mod(block,2) == 1 && sessNum == 1
%     
%     %if block is an even number & it's the first stimuli
%     CenterText(w,sprintf('Please read the Part 5 instructions and continue on your own.') ,white,0,-170);
%     
% elseif mod(block,2) == 1 && sessNum > 1
%     
%     %if block is an even number & it's a follow-up session
%     CenterText(w,sprintf('Please read the Part 3 instructions and continue on your own.') ,white,0,-170);
end

Screen('Flip',w);
WaitSecs(3);
Screen('CloseAll');

%---------------------------------------------------------------
% create a data structure with info about the run
%---------------------------------------------------------------
outfile=strcat(path,'\Output\', sprintf('%s_probe_ranking_%s',subjid,timestamp),'.mat');

% create a data structure with info about the run
run_info.subject=subjid;
run_info.date=date;
run_info.outfile=outfile;

% Run Colley's ranking 
stimuli_ranking=colley(T,N);
Rank_Output{1}=stimname;
Rank_Output{2}=[1:n]';
Rank_Output{3}=stimuli_ranking;

% fid2=fopen([path,'Dropbox\Experiment_Israel\Codes\Boost_Israel\Face_exp\Output\' subjid '_' stimuli_type sprintf('_ItemRankingResults_'), timestamp '.txt'], 'a');
% fprintf(fid2,'Subject StimName StimNum Rank Wins Loses Total\n');
% for a=1:n
%  fprintf(fid2,'%s %s %d %d %d %d %d\n', subjid, char(stimname(a)), a, stimuli_ranking(a), N(a,1), N(a,2), N(a,3));
% end
%     fclose(fid2);

run_info.script_name=mfilename;
clear food_items ;
save(outfile);

KbQueueFlush;


end

