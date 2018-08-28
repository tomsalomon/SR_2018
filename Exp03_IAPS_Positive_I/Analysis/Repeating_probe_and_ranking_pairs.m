
clear all

%   'timestamp'
% - - - - - - - - - - - - - - - - -
c = clock;
hr = sprintf('%02d', c(4));
minutes = sprintf('%02d', c(5));
timestamp = [date,'_',hr,'h',minutes,'m'];


subjects=101:115; % Define here your subjects' codes.
% exclude:

analysis_path=pwd; % Analysis folder location
outpath=[analysis_path(1:end-8),'Output\']; % Output folder location
probe_results=zeros(length(subjects),11);
probe_results(:,1)=subjects;

for subjInd=1:length(subjects)
    
    data=Probe_recode(subjects(subjInd));
    % The Probe_recode function will join all present output file for each
    % subject into a single matrix, these are the matrix columns:
    % 1-subjectID       2-scanner	 3-order        4-block         5-run       6-trial	 7-onsettime    8-ImageLeft	 9-ImageRight	10-bidIndexLeft
    % 11-bidIndexRight	12-IsleftGo	 13-Response    14-PairType     15-Outcome  16-RT	 17-bidLeft     18-bidRight
    
    all_subjs_data{subjInd}=data; %All subjects' data
    order=data(1,3);
    PairType=data(:,14);
    Outcome=data(:,15);
    
    % % Check how many probe pairs were presented in the binary ranking part
    
    % Open the binary ranking output file
    binary_ranking_file=dir([outpath,'BMI_bf_',num2str(subjects(subjInd)),'_faces_probe_ranking','*.txt']);
    fid=fopen([outpath,binary_ranking_file.name]);
    binary_ranking_data=textscan(fid, '%s %f %f %s %s %f %f %s %f %f ', 'HeaderLines', 1);
    fclose(fid);
    
    % Open the stopGo file
    stopGo_file=dir([outpath,'BMI_bf_',num2str(subjects(subjInd)),'_stopGoList_allstim_order',num2str(order),'.txt']);
    fid=fopen([outpath,stopGo_file.name]);
    stopGo=textscan(fid, '%s %f %f %f %f');
    fclose(fid);
    
    % create two lists of all presented pairs in the binary ranking part, according to their numerical names
    stim1=binary_ranking_data{4};
    stim2=binary_ranking_data{5};
    pairs_binary=zeros(length(binary_ranking_data{1}),1);
    for i=1:length(stim1) % Convert all string variables into numbers
        stim1{i}=str2num(stim1{i}(1:3));
        stim2{i}=str2num(stim2{i}(1:3));
        pairs_binary(i)=stim2{i}*1000+max(stim1{i},stim2{i}); % This variable returns a unique index for each pair of stimuli: min*1000+max,
        %   e.g: the pair [105,032] will be given the index 32105. The index 55002 is translated to the pair [055,002].
    end
    % The same indexing process, now on the pairs in the probe part of the experiment.
    image_left=data(:,8);
    image_right=data(:,9);
    pairs_probe=zeros(length(image_left),2);
    for i=1:length(image_left)
        pairs_probe(i,1)=min(image_left(i),image_right(i))*1000+max(image_left(i),image_right(i)); % unique index for each pair of stimuli: min*1000+max
        pairs_probe(i,2)=sum(pairs_binary==pairs_probe(i,1)); %count how many times each probe pair appeared in the ranking part
    end
    
    repeating_pairs=ismember(pairs_binary,pairs_probe(:,1).*pairs_probe(:,2)); % indices in the binary file of pairs which were presented in both ranking and probe part
    
    out_subjID=binary_ranking_data{1}(repeating_pairs);
    out_stim_left=binary_ranking_data{4}(repeating_pairs);
    out_stim_right=binary_ranking_data{5}(repeating_pairs);
    out_response=cell2mat(binary_ranking_data{8}(repeating_pairs));
    out_response_rt=binary_ranking_data{10}(repeating_pairs);
    
    out_rank_left=zeros(length(out_subjID),1);
    out_rank_right=zeros(length(out_subjID),1);
    out_colley_left=zeros(length(out_subjID),1);
    out_colley_right=zeros(length(out_subjID),1);
    
    % save output file - this name WILL NOT run over older versions
    fid2=fopen([outpath,'Repeating_choices\BMI_bf',num2str(subjects(subjInd)),'_Ranking_repeated_choices_',timestamp,'.txt'],'a');
    
    % save output file - this name WILL run over older versions
    %     fid2=fopen([outpath,'Repeating_choices\BMI_bf',num2str(subjects(subjInd)),'_Binary_ranking_choices_which_repeated_in_probe.txt'],'a');
    
    fprintf(fid2,'Subject\t ImageLeft\t ImageRight\t Response\t Response_RT\t ImageLeftRank\t ImageRightRank\t ImageLeftColley\t ImageRightColley\n');
    
    for i=1:length(out_subjID)
        out_rank_left(i)=stopGo{3}(strcmp(out_stim_left(i),stopGo{1}));
        out_rank_right(i)=stopGo{3}(strcmp(out_stim_right(i),stopGo{1}));
        out_colley_left(i)= stopGo{4}(strcmp(out_stim_left(i),stopGo{1}));
        out_colley_right(i)= stopGo{4}(strcmp(out_stim_right(i),stopGo{1}));
        
        fprintf(fid2,'%s\t %s\t %s\t %s\t %.2f\t %.0f\t %.0f\t %f\t %f\n',out_subjID{1},out_stim_left{i},out_stim_right{i},out_response(i),out_response_rt(i),out_rank_left(i),out_rank_right(i),out_colley_left(i),out_colley_right(i));
    end
    fclose(fid2);
end
