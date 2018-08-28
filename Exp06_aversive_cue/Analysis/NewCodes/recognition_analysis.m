
function Recognition_results = recognition_analysis(mainPath, experimentName, Subjects)

if nargin < 3
Subjects = [101 103:107 109:113 117:119]; % Define here your subjects' codes.
% exclude:
% 102 - exclduded due to BDM results
% 108 - excluded due to training (ladders went down to 0)
% 114:115 - vegans
% 116 - very strange behavior, very very tired and hungry
end

if nargin < 2
    experimentName = 'BMI_bs';
end

if nargin < 1
    mainPath = 'D:\Rotem\Dropbox\Experiment_Israel\Codes\Boost_Israel_New_Rotem_mac';
end

outputPath = [mainPath '/Output/'];

Recognition_results = zeros(length(Subjects),10);



for subjectInd = 1:length(Subjects)
    filename = strcat(outputPath,'/',[experimentName '_' num2str(Subjects(subjectInd))]);
    IsOldLogs = dir(strcat(filename, '_recognitionNewOld1','*.txt')) ;
    IsGoLogs = dir(strcat(filename, '_recognitionGoNoGo1','*.txt')) ;
    fid1 = fopen(strcat(outputPath,IsOldLogs(1).name));
    fid2 = fopen(strcat(outputPath,IsGoLogs(1).name));
    IsOldData = textscan(fid1, '%s %f %f %f %f %f %f %s %s %f %f %f' , 'HeaderLines', 1);     %read output file
    %       1 - subjectID       2 - order           3 - itemIndABC     4 - runtrial         5 - isOld?      6 - subjectAnswer
    %       7 - onsettime      8 - Name          9 - resp_choice    10 - RT             11 - bidInd     12 - isBeep?
    IsGoData = textscan(fid2, '%s %f %s %f %f %f %f %f %f %f %f %s %f', 'HeaderLines', 1);     %read output file
    %       1 - subjectID       2 - order           3 - stimName        4 - itemIndABC 5 - bidIND      6 - runtrial
    %       7 - IsOld?           8 -  subjectAnswerIsOld          9 -  isBeep?    10 - subjectAnswerIsBeep             11 - onsettime     12 - resp_choice 13 - RT
    fclose(fid1);
    fclose(fid2);
    
    IsOld = IsOldData{5};
    subjectAnswerOld = IsOldData{6};
    
    IsGo = IsGoData{9};
    subjectAnswerGo = IsGoData{10};
    
    IsOldCorrectResponse = IsOld==subjectAnswerOld;
    IsGoCorrectResponse = IsGo==subjectAnswerGo;
    
    IsOldTruePositive = IsOld==1 & subjectAnswerOld==1;
    IsOldTrueNegative = IsOld==0 & subjectAnswerOld==0;
    IsOldMiss = IsOld==1 & subjectAnswerOld==0;
    IsOldFalseAlarm = IsOld==0 & subjectAnswerOld==1;
    
    IsGoTruePositive = IsGo==1 & subjectAnswerGo==1;
    IsGoTrueNegative = IsGo==0 & subjectAnswerGo==0;
    IsGoMiss = IsGo==1 & subjectAnswerGo==0;
    IsGoFalseAlarm = IsGo==0 & subjectAnswerGo==1;
    
    highest = ismember(IsGoData{5},7:14);
    high_middle = ismember(IsGoData{5},15:22);
    low_middle = ismember(IsGoData{5},39:46);
    lowest = ismember(IsGoData{5},47:54);
    
    Recognition_results(subjectInd,1) = Subjects(subjectInd);
    Recognition_results(subjectInd,2) = sum(IsOldCorrectResponse)/length(IsOld);
    Recognition_results(subjectInd,3) = sum(IsGoCorrectResponse)/length(IsGo);
    
    Recognition_results(subjectInd,4) = sum(IsOldTruePositive)/sum(IsOld==1);
    Recognition_results(subjectInd,5) = sum(IsOldTrueNegative)/sum(IsOld==0);
    Recognition_results(subjectInd,6) = sum(IsOldMiss)/sum(IsOld==1);
    Recognition_results(subjectInd,7) = sum(IsOldFalseAlarm)/sum(IsOld==0);
    
    Recognition_results(subjectInd,8) = sum(IsGoTruePositive)/sum(IsGo==1);
    Recognition_results(subjectInd,9) = sum(IsGoTrueNegative)/sum(IsGo==0);
    Recognition_results(subjectInd,10) = sum(IsGoMiss)/sum(IsGo==1);
    Recognition_results(subjectInd,11) = sum(IsGoFalseAlarm)/sum(IsGo==0);
    
    Recognition_results(subjectInd,12) = sum(highest&IsGoCorrectResponse)/sum(highest);
    Recognition_results(subjectInd,13) = sum(high_middle&IsGoCorrectResponse)/sum(high_middle);
    Recognition_results(subjectInd,14) = sum(low_middle&IsGoCorrectResponse)/sum(low_middle);
    Recognition_results(subjectInd,15) = sum(lowest&IsGoCorrectResponse)/sum(lowest);
        
end % end for subjectInd

end % end function

