
% ~~~~~~~~~~~ Script for analyzing binary ranking results ~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~ Written by Tom Salomon, May 2015 ~~~~~~~~~~~~~~~~~
%
clear; 
close all;

subjects=[101:113,115:124,126:127]; % Define here your subjects' codes.
%exclude:
% 114 - had problems with the sound at one training run
% 125 - stop responding in parts of training


analysis_path=pwd; % Analysis folder location
outpath=['./../Output/']; % Output folder location
all_subjs_data{length(subjects)}={};
% Rankings matrix: Each row is a subject and each column is one of 60 stimuli. First column is subject's id
rankings_colley=zeros(length(subjects),61);
rankings_order=zeros(length(subjects),61); 

stdevs=zeros(length(subjects),2);
stdevs(:,1)=subjects;
rankings_colley(:,1)=subjects;
rankings_order(:,1)=subjects;
for subjInd=1:length(subjects)
    
    data_file=dir(strcat(outpath,'BMI_*',num2str(subjects(subjInd)),'*ItemRankingResults','*.txt')) ;
    subject_data=[];
    fid=fopen(strcat(outpath,data_file.name));
    data=textscan(fid, '%s%s%f%f%f%f%f' , 'HeaderLines', 1);     %read in Binary Ranking output file;
    % 1-subjectID       2-StimName	 3-StimNum (by name)        4-Rank from Colley
    % 5-Wins            6-Loses        7-Total
    fid=fclose(fid);
    
    rankings_colley(subjInd,2:end)=data{4}'; 
    [~,~,rankings_order(subjInd,2:end)]=unique(1./data{4}');
    all_subjs_data{subjInd}=data; %All subjects' data
    stdevs(subjInd,2)=std(data{4}); % Standard deviations of the rankings. Small STD indicates ranking were 
    % similar to one each other due to poor trasitivity of choices.
end
means_table=[data{2},num2cell([mean(rankings_colley(:,2:end))',mean(rankings_order(:,2:end))'])];

