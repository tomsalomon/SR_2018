function [wrongPressingAllSubjects] = wrongPressingTraining(mainPath, experimentName, Subjects)
% function [wrongPressingAllSubjects] = wrongPressingTraining(mainPath, experimentName, Subjects)
% this function calculates how many times each subject pressed when no beep
% was heard (wrong positive)

if nargin < 3
    Subjects = 101:106; % write here only the subjects that should be analyzed (were not excluded)
    % exclude:
    % 
end

if nargin < 2
    experimentName = 'BMI_bs_40';
end

if nargin < 1
    mainPath = 'D:\Rotem\Dropbox\Experiment_Israel\Codes\BMI_bs_40';
end

analysisOutputPath = [mainPath '/Output'];
wrongPressingAllSubjects = zeros(length(Subjects),2);
wrongPressingAllSubjects(:,1) = Subjects;

for subjectInd = 1:length(Subjects)
    % join all the training files of the subject to one matrix
    subjectTrainingData = joinTraining(mainPath, experimentName, Subjects(subjectInd));
    % search the subject data for trials of type 12 or 24 in which a button
    % was pressed
    countWrongPressing = sum(subjectTrainingData(:,8)==12 | subjectTrainingData(:,8)==24);
    wrongPressingAllSubjects(subjectInd,2) = countWrongPressing;
    fprintf(['Subject # ' num2str(Subjects(subjectInd)) ' pressed when not needed on ' num2str(countWrongPressing) ' trials of training\n']);
end % end for subjectInd = 1:length(Subjects)



end % end function

