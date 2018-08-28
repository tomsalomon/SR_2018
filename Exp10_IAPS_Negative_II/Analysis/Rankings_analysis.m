
% ~~~~~~~~~~~ Script for analyzing binary ranking results ~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~ Written by Tom Salomon, May 2015 ~~~~~~~~~~~~~~~~~
%

subjects=[101:116,119:120,125:134]; % Define here your subjects' codes.
%exclude:
% 117 - did snack version of the experiment 3 month prior to the experimnet
% 118 & 121 - were over 40 years old
% 122:124 - did the training part with the Psychtoolbox's audio function

analysis_path=pwd; % Analysis folder location
outpath=[analysis_path(1:end-8),'Output\']; % Output folder location
all_subjs_data{length(subjects)}={};
% Rankings matrix: Each row is a subject and each column is one of 60 stimuli. First column is subject's id
rankings=zeros(length(subjects),61); 
stdevs=zeros(length(subjects),2);
stdevs(:,1)=subjects;
rankings(:,1)=subjects;

for subjInd=1:length(subjects)
    
    data_file=dir(strcat(outpath,'BMI_*',num2str(subjects(subjInd)),'*ItemRankingResults','*.txt')) ;
    subject_data=[];
    fid=fopen(strcat(outpath,data_file.name));
    data=textscan(fid, '%s%s%f%f%f%f%f' , 'HeaderLines', 1);     %read in Binary Ranking output file;
    % 1-subjectID       2-StimName	 3-StimNum (by name)        4-Rank from Colley
    % 5-Wins            6-Loses        7-Total
    fid=fclose(fid);
    
    rankings(subjInd,2:end)=data{4}'; 
    all_subjs_data{subjInd}=data; %All subjects' data
    stdevs(subjInd,2)=std(data{4}); % Standard deviations of the rankings. Small STD indicates ranking were 
    % similar to one each other due to poor trasitivity of choices.
end
