function [pressingAllSubjects] = analyzePressingTraining(mainPath, experimentName, Subjects)
% function [analyzePressingAllSubjects] = percentGoodPressingTraining(mainPath, experimentName, Subjects)
% this function calculates how many times each subject pressed when no beep
% was heard (wrong positive)

if nargin < 3
    Subjects = [102, 105, 116, 125]; % write here only the subjects that should be analyzed (were not excluded)
    % exclude:
    % 
end

if nargin < 2
    experimentName = '*';
end

if nargin < 1
    mainPath = './../';
end

% analysisOutputPath = [mainPath '/Output'];
pressingAllSubjectsMat = zeros(length(Subjects),8);
pressingAllSubjectsMat(:,1) = Subjects;

for subjectInd = 1:length(Subjects)
    % join all the training files of the subject to one matrix
    subjectTrainingData = joinTraining(mainPath, experimentName, Subjects(subjectInd));
    
    % count different types of responses
    countTruePositive = sum(subjectTrainingData(:,8)==110 | subjectTrainingData(:,8)==220);
    countEarlyTruePositive = sum(subjectTrainingData(:,8)==11 | subjectTrainingData(:,8)==22);
    countLateTruePositive = sum(subjectTrainingData(:,8)==1100 | subjectTrainingData(:,8)==2200);
    countTotalTruePositive = countTruePositive + countEarlyTruePositive + countLateTruePositive;
    countFalsePositive = sum(subjectTrainingData(:,8)==12 | subjectTrainingData(:,8)==24);
    countFalseNegative = sum(subjectTrainingData(:,8)==1 | subjectTrainingData(:,8)==2);
    countTrueNegative = sum(subjectTrainingData(:,8)==120 | subjectTrainingData(:,8)==240);
    countGoTrials = sum(subjectTrainingData(:,6)==11 | subjectTrainingData(:,6)==22);
    countNoGoTrials = sum(subjectTrainingData(:,6)==12 | subjectTrainingData(:,6)==24);
    percentTruePositive = countTotalTruePositive / countGoTrials * 100;
    percentFalsePositive = countFalsePositive / countNoGoTrials * 100;
    percentTrueNegative = countTrueNegative / countNoGoTrials * 100;
    percentFalseNegative = countFalseNegative / countGoTrials * 100;
    totalNumTrials = countGoTrials + countNoGoTrials;
    
    % add counts to all subjects' data matrix
    pressingAllSubjectsMat(subjectInd,2) = countGoTrials;
    pressingAllSubjectsMat(subjectInd,3) = countTruePositive;
    pressingAllSubjectsMat(subjectInd,4) = countEarlyTruePositive;
    pressingAllSubjectsMat(subjectInd,5) = countLateTruePositive;
    pressingAllSubjectsMat(subjectInd,6) = countTotalTruePositive;
    pressingAllSubjectsMat(subjectInd,7) = percentTruePositive;
    pressingAllSubjectsMat(subjectInd,8) = countFalseNegative;
    pressingAllSubjectsMat(subjectInd,9) = percentFalseNegative;
    pressingAllSubjectsMat(subjectInd,10) = countNoGoTrials;
    pressingAllSubjectsMat(subjectInd,11) = countTrueNegative;
    pressingAllSubjectsMat(subjectInd,12) = percentTrueNegative;
    pressingAllSubjectsMat(subjectInd,13) = countFalsePositive;
    pressingAllSubjectsMat(subjectInd,14) = percentFalsePositive;
    pressingAllSubjectsMat(subjectInd,15) = totalNumTrials;
    
    fprintf(['Subject # ' num2str(Subjects(subjectInd)) ' pressed when not needed on ' num2str(countFalsePositive) ' trials of training out of ' num2str(totalNumTrials) '\n']);
    fprintf(['Subject # ' num2str(Subjects(subjectInd)) ' did not pressed when needed on ' num2str(countFalseNegative) ' trials of training out of ' num2str(totalNumTrials) '\n']);
end % end for subjectInd = 1:length(Subjects)

pressingAllSubjects = cell(1+size(pressingAllSubjectsMat,1),size(pressingAllSubjectsMat,2));
Titles = {'Subject', '#Go', '#TruePositive', '#EarlyTruePositive', '#LateTruePositive', '#TotalTruePositive', '%TruePositive', '#FalseNegative', '%FalseNegative', '#NoGo', '#TrueNegative', '%TrueNegative', '#FalsePositive', '%FalsePositive', 'total Num Trials'};
pressingAllSubjects(1,:) = Titles;
pressingAllSubjects(2:end,:) = num2cell(pressingAllSubjectsMat);

end % end function

