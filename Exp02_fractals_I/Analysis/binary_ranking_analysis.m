
clear all

% Define analysis and output paths
analysis_path=pwd;
outpath=['./../Output/'];

% These are all the subjects' ranking results files
ranking_files=dir([outpath '*ItemRankingRes*']);

rankings=zeros(length(ranking_files),60); % Rankings of the 60 stimuli, each column identify a particular stimulus
stdevs=zeros(length(ranking_files),1); % Standard deviations of the final ranking table of each sunject. Small STD 
% may indicate low preferences for different stimuli (i.e. the subject did not like certain stimuli more then others)
ReactionTime=zeros(length(ranking_files),1);

% Go through each sunbject's file and extract the data
for i=1:length(ranking_files)
    fid=fopen([outpath,ranking_files(i).name]);
    data=textscan(fid,'%s %s %f %f %f %f %f','Headerlines',1);
    
% contains a table with the data sorted by the stimuli's names: 1)SubjectID	2)StimName	3)StimNum	4)Rank	5)Wins	6)Loses  7)Total
    rankings(i,:)=data{4}'; % Stimuli's rankings, sorted alphabetically (e.g - first number is the '001.TIFF' ranking; second number is the '002.TIFF' ranking, etc.)
    fid=fclose(fid);
    stdevs(i)=std(data{4});
end

choices_files=dir([outpath '*faces_probe_ranking_*.txt']);
no_choices=zeros(length(choices_files),1);
for i=1:length(choices_files)
    fid=fopen([outpath,choices_files(i).name]);
    data=textscan(fid,'%s %f %f %s %s %f %f %s %f %f','Headerlines',1);
    no_choices(i)=sum(cell2mat(data{8})=='x');
    RT=data{1,10};
    RT(RT==999000)=[];
    ReactionTime(i)=mean(RT);
    fid=fclose(fid);
end
