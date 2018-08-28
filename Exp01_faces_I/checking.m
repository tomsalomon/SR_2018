KbQueueCreate;
KbQueueStart;
fprintf('KbQueueStart \n')
% WaitSecs(5);
startTime = GetSecs;
WaitSecs(6);
fprintf('KbQueueCheck \n')
ind = 1;
while (GetSecs-startTime < 10)  % these are additional 500msec to monitor responses
    [Pressed, firstPress, ~, ~, ~] = KbQueueCheck;
    if Pressed
        fprintf('Pressed! \n')
        findfirstPress = find(firstPress);
        timePressed(ind) = firstPress(findfirstPress(1));
        RT(ind) = timePressed(ind)-startTime;
        
        tmp = KbName(firstPress);
        if ischar(tmp)==0 % if 2 keys are hit at once, they become a cell, not a char. we need keyPressed{runNum} to be a char, so this converts it and takes the first key pressed
            tmp=char(tmp);
        end
        keyPressed(ind) = tmp(1);

%         break
    ind = ind+1;
    end
    %  KbQueueFlush;
    
end % End while of additional 500 msec
fprintf('time is over \n')

% KbQueueRelease;