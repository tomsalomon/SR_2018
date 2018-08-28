
function Recognition_results=recognition_d_prime_analysis(subjects,outpath)

if nargin<1
    subjects=[101:120,122:126]; % Define here your subjects' codes.
    %exclude:
    
end

if nargin <2
    outpath='./../Output/';
end
Recognition_results=nan(length(subjects),15);



for subjInd=1:length(subjects)
    
    % memory log file
    IsGoLogs=dir([outpath,'/*',num2str(subjects(subjInd)),'_reco*.txt']) ;
    IsGoLogs_followup=dir([outpath,'/recall/*',num2str(subjects(subjInd)),'_reco*.txt']) ;
    
    % in the confidence task only one log file will exist
    is_confidence=length(IsGoLogs)==1;
    
    % look for follow-up files
    is_followup=length(IsGoLogs_followup)>=1;
    
    fid=fopen(strcat(outpath,IsGoLogs(1).name));
    if is_confidence
        RecognitionData=textscan(fid, '%s %f %f %s %f %f %f %f %f %f %f %f %f %f %f %f' , 'HeaderLines', 1); %read output file
        %   1 - subjectID           2 - order           3 - itemIndABC      4 - stimName
        %   5 - bidInd              6 - runtrial        7 - isOld?          8 - subjectAnswerIsOld
        %   9 - onsettime_isOld     10 - resp_isOld     11 - RT_isOld       12 - isGo?
        %   13 - subjectAnswerIsGo	14 - onsettime_isGo 15 - resp_isGo      16 - RT_isGo
        
        fclose(fid);
        
        
        IsOld=RecognitionData{7};
        IsGo=RecognitionData{12};
        subjectAnswerGoConfidence=RecognitionData{13};
        
        % create binary response variable where: 0 - stimuli is new/NoGo,
        %1 - Stimulus is old/Go, 999 - not sure.
        subjectAnswerGo=zeros(length(subjectAnswerGoConfidence),1);
        subjectAnswerGo(subjectAnswerGoConfidence==3)=999;
        subjectAnswerGo(subjectAnswerGoConfidence<=2)=1;
        
    else
        IsGoData=textscan(fid, '%s %f %s %f %f %f %f %f %f %f %f %s %f', 'HeaderLines', 1);     %read output file
        %       1 - subjectID       2 - order           3 - stimName        4 - itemIndABC 5 - bidIND      6 - runtrial
        %       7 - IsOld?           8 -  subjectAnswerIsOld          9 -  isBeep?    10 - subjectAnswerIsBeep             11 - onsettime     12 - resp_choice 13 - RT
        
        fclose(fid);
        
        IsOld=IsGoData{7};
        IsGo=IsGoData{9};
        subjectAnswerGo=IsGoData{10};
    end
    
    % calculate signal detection coun where not sure is a false response
    IsGoTruePositive=   sum(IsOld==1&IsGo==1&subjectAnswerGo==1);
    IsGoTrueNegative=   sum(IsOld==1&IsGo==0&subjectAnswerGo==0);
    IsGoMiss=           sum(IsOld==1&IsGo==1&subjectAnswerGo~=1);
    IsGoFalseAlarm=     sum(IsOld==1&IsGo==0&subjectAnswerGo~=0);
    
    % add a correction for 100% or 0% responses
    p_hit=(IsGoTruePositive+0.5)/(IsGoTruePositive+IsGoMiss+1);
    p_false_alarm=(IsGoFalseAlarm+0.5)/(IsGoTrueNegative+IsGoFalseAlarm+1);
    
    % d' = z(hit) - z(false_alarm)
    % p to z score (icdf = standard normal distribution with mean 0, std 1)
    d_prime=icdf('normal',p_hit,0,1)-icdf('normal',p_false_alarm,0,1);
    
    if is_followup
        fid_followup=fopen(strcat(outpath,'/recall/',IsGoLogs_followup(1).name));
        if is_confidence
            RecognitionData=textscan(fid_followup, '%s %f %f %s %f %f %f %f %f %f %f %f %f %f %f %f' , 'HeaderLines', 1); %read output file
            %   1 - subjectID           2 - order           3 - itemIndABC      4 - stimName
            %   5 - bidInd              6 - runtrial        7 - isOld?          8 - subjectAnswerIsOld
            %   9 - onsettime_isOld     10 - resp_isOld     11 - RT_isOld       12 - isGo?
            %   13 - subjectAnswerIsGo	14 - onsettime_isGo 15 - resp_isGo      16 - RT_isGo
            
            fclose(fid);
            
            
            IsOld=RecognitionData{7};
            IsGo=RecognitionData{12};
            subjectAnswerGoConfidence=RecognitionData{13};
            
            % create binary response variable where: 0 - stimuli is new/NoGo,
            %1 - Stimulus is old/Go, 999 - not sure.
            subjectAnswerGo=zeros(length(subjectAnswerGoConfidence),1);
            subjectAnswerGo(subjectAnswerGoConfidence==3)=999;
            subjectAnswerGo(subjectAnswerGoConfidence<=2)=1;
            
        else
            IsGoData=textscan(fid, '%s %f %s %f %f %f %f %f %f %f %f %s %f', 'HeaderLines', 1);     %read output file
            %       1 - subjectID       2 - order           3 - stimName        4 - itemIndABC 5 - bidIND      6 - runtrial
            %       7 - IsOld?           8 -  subjectAnswerIsOld          9 -  isBeep?    10 - subjectAnswerIsBeep             11 - onsettime     12 - resp_choice 13 - RT
            
            fclose(fid);
            
            IsOld=IsGoData{7};
            IsGo=IsGoData{9};
            subjectAnswerGo=IsGoData{10};
        end
        
        % calculate signal detection coun where not sure is a false response
        IsGoTruePositive_followup=   sum(IsOld==1&IsGo==1&subjectAnswerGo==1);
        IsGoTrueNegative_followup=   sum(IsOld==1&IsGo==0&subjectAnswerGo==0);
        IsGoMiss_followup=           sum(IsOld==1&IsGo==1&subjectAnswerGo~=1);
        IsGoFalseAlarm_followup=     sum(IsOld==1&IsGo==0&subjectAnswerGo~=0);
        
        % add a correction for 100% or 0% responses
        p_hit_followup=(IsGoTruePositive_followup+0.5)/(IsGoTruePositive_followup+IsGoMiss_followup+1);
        p_false_alarm_followup=(IsGoFalseAlarm_followup+0.5)/(IsGoTrueNegative_followup+IsGoFalseAlarm_followup+1);
        
        % d' = z(hit) - z(false_alarm)
        % p to z score (icdf = standard normal distribution with mean 0, std 1)
        d_prime_followup=icdf('normal',p_hit_followup,0,1)-icdf('normal',p_false_alarm_followup,0,1);
    end
    
    
    Recognition_results(subjInd,1)=subjects(subjInd);
    
    Recognition_results(subjInd,2)=d_prime;
    
    Recognition_results(subjInd,3)=p_hit;
    Recognition_results(subjInd,4)=p_false_alarm;
    
    Recognition_results(subjInd,5)=IsGoTruePositive;
    Recognition_results(subjInd,6)=IsGoTrueNegative;
    Recognition_results(subjInd,7)=IsGoMiss;
    Recognition_results(subjInd,8)=IsGoFalseAlarm;
    
    if is_followup
        Recognition_results(subjInd,9)=d_prime_followup;
        
        Recognition_results(subjInd,10)=p_hit_followup;
        Recognition_results(subjInd,11)=p_false_alarm_followup;
        
        Recognition_results(subjInd,12)=IsGoTruePositive_followup;
        Recognition_results(subjInd,13)=IsGoTrueNegative_followup;
        Recognition_results(subjInd,14)=IsGoMiss_followup;
        Recognition_results(subjInd,15)=IsGoFalseAlarm_followup;
    end
    
end




