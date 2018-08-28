function BIS_Israel(subjectID, test_comp, mainPath)

% function BIS_Israel(subjectID, test_comp)

% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% =============== Created based on the previous boost codes ===============
% ==================== by Rotem Botvinik March 2015 ====================
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

% This function runs the (English version of) the BIS questionare,
% between the training and the probe of the cue-approach task.


% % % ---dummy info for testing purposes --------
subjuctID = 'test111';
order = 1;
test_comp = 4;

%---------------------------------------------------------------
%% 'Global variables'
%---------------------------------------------------------------


% Time
% - - - - - - - - -
c = clock;
hr = sprintf('%02d', c(4));
min = sprintf('%02d', c(5));
timestamp = [date,'_',hr,'h',min,'m'];

tic

% Questions
% - - - - - - - - -

qlist={'I plan tasks carefully.' 'I do things without thinking.' 'I make up my mind quickly.' 'I am happy-go-lucky.' 'I don`t ``pay attention``.' 'I have ``racing`` thoughts.' 'I plan trips well ahead of time.' 'I am self-controlled.' 'I concentrate easily.' 'I save regularly.' 'I ``squirm`` at plays or lectures.' 'I am a careful thinker.' 'I plan for job security.' 'I say things without thinking.' 'I like to think about complex problems.' 'I change jobs.' 'I act ``on impulse``.' 'I get easily bored when solving thought problems.' 'I act on the spur of the moment.' 'I am a steady thinker.' 'I change where I live.' 'I buy things on impulse.' 'I can only think about one problem at a time.' 'I change hobbies.' 'I spend or charge more than I earn.' 'I have outside thoughts when thinking.' 'I am more interested in the present than the future.'  'I am restless at lectures or talks.' 'I like puzzles.' 'I plan for the future.'};

onsetlist=[0    4.5000    9.0000   13.5000   18.0000   22.5000   27.0000   31.5000   36.0000   40.5000   45.0000   49.5000   54.0000   58.5000   63.0000 67.5000   72.0000   76.5000   81.0000   85.5000   90.0000   94.5000   99.0000  103.5000  108.0000  112.5000  117.0000  121.5000  126.0000  130.5000];

%---------------------------------------------------------------
%% 'INITIALIZE Screen variables'
%---------------------------------------------------------------

Screen('Preference', 'VisualDebuglevel', 3); %No PTB intro screen
screennum = max(Screen('Screens'));

pixelSize=32;
[w] = Screen('OpenWindow',screennum,[],[0 0 640 480],pixelSize);% %debugging screensize
% [w] = Screen('OpenWindow',screennum,[],[],pixelSize);

HideCursor;

% Set the colors
black = BlackIndex(w); % Should equal 0.
white = WhiteIndex(w); % Should equal 255.
yellow = [0 255 0];

Screen('FillRect', w, black);  % NB: only need to do this once!
Screen('Flip', w);

% set up screen positions for stimuli
[wWidth, wHeight]=Screen('WindowSize', w);
xcenter = wWidth/2;
ycenter = wHeight/2;

Screen('FillRect', w, black);  % NB: only need to do this once!
Screen('Flip', w);

% text settings
theFont = 'Arial';
Screen('TextFont',w,theFont);
% instrSZ = 40;
betsz = 50;
Screen('TextSize',w, 40);

%---------------------------------------------------------------
%% 'ASSIGN response keys'
%---------------------------------------------------------------
KbName('UnifyKeyNames');
if test_comp == 1
    leftstack = 'b';
    midleftstack = 'y';
    midrightstack = 'g';
    rightstack = 'r';
else % not inside the MRI
    leftstack = 'u';
    midleftstack = 'i';
    midrightstack = 'o';
    rightstack = 'p';
end

%-----------------------------------------------------------------


ListenChar(2);
KbQueueCreate;


%---------------------------------------------------------------
%% 'Write output file header'
%---------------------------------------------------------------

fid1 = fopen([mainPath '/Output/' subjectID '_BIS_' timestamp '.txt'], 'a');
fprintf(fid1,'subjectID scanner runtrial onsettime question Response RT \n'); % write the header line

%---------------------------------------------------------------
%% 'Display Main Instructions'
%---------------------------------------------------------------

Screen('TextSize',w, 50);
CenterText(w,'PART 3:',white,0,-300);
Screen('TextSize',w, 40);
CenterText(w,'Please fill in the following questionnaire on the screen.', white,0,-200);
CenterText(w,'Read the statement carefully and select the appropriate response below.', white,0,-100);
CenterText(w,'Please answer quickly and honestly.', white,0,0);

if test_comp == 1
        CenterText(w,'Select the appropriate answer using the 1, 2, 3 or 4', white,0,100);
        CenterText(w,'button on the keypad.', white,0,200);
else
        CenterText(w,'Select the appropriate answer using the `u` `i` `o` or `p`', white,0,100);
        CenterText(w,'button on the keyboard.', white,0,200);
end % end if test_comp == 1

CenterText(w,'Press any key to continue', yellow,0,300);
HideCursor;
Screen('Flip', w);
KbPressWait;


%---------------------------------------------------------------
%% 'Run Trials'
%---------------------------------------------------------------
runStart = GetSecs;

for trial = 1:6 % short run for debugging
% for trial = 1:length(qlist)

    colorright = white;
    colormidright = white;
    colormidleft = white;
    colorleft = white;

    %-----------------------------------------------------------------
    % set image
    Screen('TextSize',w, betsz);
    CenterText(w,qlist{trial}, white,0,-150);
    Screen('TextSize',w, 40);
    Screen('DrawText', w, 'Rarely/Never', xcenter-500, ycenter+100, white);
    Screen('DrawText', w, 'Occasionally', xcenter-150, ycenter+100, white);
    Screen('DrawText', w, 'Often', xcenter+150, ycenter+100, white);
    Screen('DrawText', w, 'Almost Always', xcenter+300, ycenter+100, white);

    StimOnset = Screen(w,'Flip');
    KbQueueStart;

    %-----------------------------------------------------------------
    % get response
    
    
    noresp = 1;
    while noresp
        % check for response
        [keyIsDown, firstPress] = KbQueueCheck;


        if keyIsDown && noresp
            keyPressed = KbName(firstPress);
            if ischar(keyPressed) == 0 % if 2 keys are hit at once, they become a cell, not a char. we need keyPressed to be a char, so this converts it and takes the first key pressed
                keyPressed = char(keyPressed);
                keyPressed = keyPressed(1);
            end
            switch keyPressed
                case leftstack
                    respTime = firstPress(KbName(leftstack))-StimOnset;
                    noresp = 0;
                case midleftstack
                    respTime = firstPress(KbName(midleftstack))-StimOnset;
                    noresp=0;
                case midrightstack
                    respTime = firstPress(KbName(midrightstack))-StimOnset;
                    noresp = 0;
                case rightstack
                    respTime = firstPress(KbName(rightstack))-StimOnset;
                    noresp = 0;
            end
        end

    end

    %-----------------------------------------------------------------

    
    % determine what bid to highlight
    
    switch keyPressed
        case leftstack
            colorleft = yellow;
            bid = 1;
            
        case midleftstack
            colormidleft = yellow;
            bid = 2;
            
        case midrightstack
            colormidright = yellow;
            bid = 3;
            
        case rightstack
            colorright = yellow;
            bid = 4;
    end

    Screen('TextSize',w, betsz);
    CenterText(w,qlist{trial}, white,0,-150);
    Screen('TextSize',w, 40);
    Screen('DrawText', w, 'Rarely/Never', xcenter-500, ycenter+100, colorleft);
    Screen('DrawText', w, 'Occasionally', xcenter-150, ycenter+100, colormidleft);
    Screen('DrawText', w, 'Often', xcenter+150, ycenter+100, colormidright);
    Screen('DrawText', w, 'Almost Always', xcenter+300, ycenter+100, colorright);
    Screen(w,'Flip');    
    WaitSecs(.5);

 
    
    
    %-----------------------------------------------------------------
    % show fixation ITI
    Screen('TextSize',w, betsz);
    Screen('DrawText', w, '+', xcenter, ycenter, white);
    Screen(w,'Flip');
    WaitSecs(1);
    
    %-----------------------------------------------------------------
    % write to output file
    
    fprintf(fid1,'%s %d %d %d %s %d %d \n', subjectID, test_comp, trial, onsetlist(trial), qlist{trial}, bid, respTime); 
    KbQueueFlush;
end





Screen('TextSize',w, betsz);
CenterText(w,'Thank you!', yellow,0,-200);
CenterText(w,'Please read the instructions for Part 4 and proceed on your own.', white,0,0);
Screen('Flip', w);
WaitSecs(0.5);

if test_comp==1
    fprintf(['\n \n \n You just ran BIS( `' subjectID '`,' num2str(test_comp) '). Next you want to run probe( `' subjectID '`,TrainOrder,' num2str(test_comp) ') \n \n \n']);
end
ListenChar(0);

while noresp,
    [keyIsDown,~,~] = KbCheck;
    if keyIsDown && noresp,
        noresp=0;
    end;
end;

Screen('CloseAll');

toc

end




