
function Recognition_results=recognition_analysis(subjects,outpath)

if nargin<1
    subjects=[103:116,119:120,125:134]; % Define here your subjects' codes.
    %exclude:
    % 117 - did snack version of the experiment 3 month prior to the experimnet
    % 118 & 121 - were over 40 years old
    % 122:124 - did the training part with the Psychtoolbox's audio function
end

analysis_path=pwd;
if nargin <2
outpath='./../Output/';
end
Recognition_results=zeros(length(subjects),10);



for subjInd=1:length(subjects)
    
    IsOldLogs=dir([outpath,'/*',num2str(subjects(subjInd)),'_recognitionNewOld*.txt']) ;
    IsGoLogs=dir([outpath,'/*',num2str(subjects(subjInd)),'_recognitionGoNoGo*.txt']) ;
    fid1=fopen(strcat(outpath,IsOldLogs(1).name));
    fid2=fopen(strcat(outpath,IsGoLogs(1).name));
    IsOldData=textscan(fid1, '%s %f %f %f %f %f %f %s %s %f %f %f' , 'HeaderLines', 1);     %read output file
    %       1 - subjectID       2 - order           3 - itemIndABC     4 - runtrial         5 - isOld?      6 - subjectAnswer
    %       7 - onsettime      8 - Name          9 - resp_choice    10 - RT             11 - bidInd     12 - isBeep?
    IsGoData=textscan(fid2, '%s %f %s %f %f %f %f %f %f %f %f %s %f', 'HeaderLines', 1);     %read output file
    %       1 - subjectID       2 - order           3 - stimName        4 - itemIndABC 5 - bidIND      6 - runtrial
    %       7 - IsOld?           8 -  subjectAnswerIsOld          9 -  isBeep?    10 - subjectAnswerIsBeep             11 - onsettime     12 - resp_choice 13 - RT
    fclose(fid1);
    fclose(fid2);
    
    IsOld=IsOldData{5};
    subjectAnswerOld=IsOldData{6};
    
    IsGo=IsGoData{9};
    subjectAnswerGo=IsGoData{10};
    
    IsOldCorrectResponse=IsOld==subjectAnswerOld;
    IsGoCorrectResponse=IsGo==subjectAnswerGo;
    
    IsOldTruePositive=IsOld==1&subjectAnswerOld==1;
    IsOldTrueNegative=IsOld==0&subjectAnswerOld==0;
    IsOldMiss=IsOld==1&subjectAnswerOld==0;
    IsOldFalseAlarm=IsOld==0&subjectAnswerOld==1;
    
    IsGoTruePositive=IsGo==1&subjectAnswerGo==1;
    IsGoTrueNegative=IsGo==0&subjectAnswerGo==0;
    IsGoMiss=IsGo==1&subjectAnswerGo==0;
    IsGoFalseAlarm=IsGo==0&subjectAnswerGo==1;
    
    high_value=ismember(IsGoData{5},7:22);
    low_value=ismember(IsGoData{5},39:54);
    
    Recognition_results(subjInd,1)=subjects(subjInd);
    Recognition_results(subjInd,2)=sum(IsOldCorrectResponse)/length(IsOld);
    Recognition_results(subjInd,3)=sum(IsGoCorrectResponse)/length(IsGo);
    
    Recognition_results(subjInd,4)=sum(IsOldTruePositive)/sum(IsOld==1);
    Recognition_results(subjInd,5)=sum(IsOldTrueNegative)/sum(IsOld==0);
    Recognition_results(subjInd,6)=sum(IsOldMiss)/sum(IsOld==1);
    Recognition_results(subjInd,7)=sum(IsOldFalseAlarm)/sum(IsOld==0);
    
    Recognition_results(subjInd,8)=sum(IsGoTruePositive)/sum(IsGo==1);
    Recognition_results(subjInd,9)=sum(IsGoTrueNegative)/sum(IsGo==0);
    Recognition_results(subjInd,10)=sum(IsGoMiss)/sum(IsGo==1);
    Recognition_results(subjInd,11)=sum(IsGoFalseAlarm)/sum(IsGo==0);
    
    Recognition_results(subjInd,12)=sum(high_value&IsGoCorrectResponse)/sum(high_value);
    Recognition_results(subjInd,13)=sum(low_value&IsGoCorrectResponse)/sum(low_value);
    
end
end




