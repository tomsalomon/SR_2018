mainPath = 'C:\Users\Rotem\Dropbox\Experiment_Israel\Codes\BMI_bs_40';
outputPath = [mainPath '\Output'];
experimentName = 'BMI_bs_40';
Subjects = 101:111;
probeStimAllSubjects = zeros(152,length(Subjects)*2);

for ind = 1:length(Subjects)
   [subjectData] = joinProbe(outputPath,experimentName,Subjects(ind));
   probeStimAllSubjects(:,ind) = subjectData(:,10);
   probeStimAllSubjects(:,ind+length(Subjects)) = subjectData(:,11);   
end
newOrder = 1:0.5:length(Subjects)+0.5;
newOrder(2:2:end) = 1+length(Subjects):2*length(Subjects);
probeStimAllSubjects = probeStimAllSubjects(:,newOrder);