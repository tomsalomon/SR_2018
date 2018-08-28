
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
outpath='./../Output/'; % Output folder location
probe_results=zeros(length(subjects),11);
probe_results(:,1)=subjects;

for subjInd=1:length(subjects)
    
       % Open Probe data and convert to one matrix
    ProbeLogs=dir([outpath,'*',num2str(subjects(subjInd)),'_probe*.txt']) ;
    Probe_data=[];
    for datafile = 1:length(ProbeLogs)
        fid=fopen(strcat(outpath,ProbeLogs(datafile).name));
        Data=textscan(fid, '%s%f%f%f%f%f%f%s%s%f%f%f%s%f%f%f%f%f' , 'HeaderLines', 1);     %read in probe output file into P ;
        
        % Convert all string variables into numbers
        Data{1}(:)={subjects(subjInd)}; %subject's code
        for i=1:length(Data{1})
            Data{8}{i}=str2num(Data{8}{i}(1:end-4)); % left stimulus
            Data{9}{i}=str2num(Data{9}{i}(1:3)); % right stimulus
        end
        Data{13}(strcmp(Data{13},'u'))={1}; % response: 1 for left
        Data{13}(strcmp(Data{13},'i'))={0}; % response: 0 for right
        Data{13}(strcmp(Data{13},'x'))={999}; % response: 99 for no response
        
        Data{1}=cell2mat(Data{1});
        Data{8}=cell2mat(Data{8});
        Data{9}=cell2mat(Data{9});
        Data{13}=cell2mat(Data{13});
        
        fid=fclose(fid);
        Probe_data(end+1:end+length(Data{1}),:)=cell2mat(Data);
    end
        
    all_subjs_data{subjInd}=Probe_data; %All subjects' data
    order=Probe_data(1,3);
    PairType=Probe_data(:,14);
    Outcome=Probe_data(:,15);
    
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
    image_left=Probe_data(:,8);
    image_right=Probe_data(:,9);
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
