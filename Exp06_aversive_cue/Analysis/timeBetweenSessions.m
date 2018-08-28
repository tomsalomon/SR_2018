% function [Days_data, by_subject]= timeBetweenSessions(mainPath, experimentName, Subjects)


%This function calculates the time elapsed between sessions, on average, the SD, min and max (in number of days)

Subjects=[101:103,109:110,113, 117,119,121:122,123,125,128,132]; % exluding bad subjects
experimentName = 'BOA'; %this should be compatible with the prefix of the subjects serial numbers
mainPath = './..'; % write the enclosing folder of the experiment data


by_subject= zeros(length(Subjects),2);
by_subject(:,1)=Subjects;


session1_outputPath = [mainPath,'/Output']; % write/correct ccording to the path of the first session results
session2_outputPath = [mainPath,'/Output/followup']; % write/correct ccording to the path of the second session results

for subjectInd = 1:length(Subjects)
    
    filename1 = strcat(session1_outputPath,sprintf('/%s_%d',experimentName,Subjects(subjectInd)));
    logs1 = dir(strcat(filename1, '_probe_block','*.txt')) ;
    
    filename2 = strcat(session2_outputPath,sprintf('/%s_%d',experimentName,Subjects(subjectInd)));
    logs2 = dir(strcat(filename2, '_probe_block','*.txt')) ;
    
    NumDays = daysact(logs1(1).date,  logs2(1).date);
    by_subject(subjectInd,2)=NumDays;
end

Days_data(1,1)=mean(by_subject(:,2));
Days_data(1,2)=std(by_subject(:,2));
Days_data(1,3)=min(by_subject(:,2));
Days_data(1,4)=max(by_subject(:,2));


