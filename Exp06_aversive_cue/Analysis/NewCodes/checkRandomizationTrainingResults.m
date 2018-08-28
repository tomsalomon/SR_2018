mainPath = 'C:\Users\Rotem\Dropbox\Experiment_Israel\Codes\BMI_bs_40';
experimentName = 'BMI_bs_40';
Subjects = 101:111;
trainingStimAllSubjects = zeros(800,length(Subjects));

for ind = 1:length(Subjects)
   [subjectData] = joinTraining(mainPath,experimentName,Subjects(ind));
   trainingStimAllSubjects(:,ind) = subjectData(:,14);  
end