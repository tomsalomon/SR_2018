
clear all

%   'timestamp'
% - - - - - - - - - - - - - - - - -
c = clock;
hr = sprintf('%02d', c(4));
minutes = sprintf('%02d', c(5));
timestamp = [date,'_',hr,'h',minutes,'m'];

subjects=[101:120,122:126]; % Define here your subjects' codes.
%exclude:
% 121 - did not look at the images during training

analysis_path=pwd; % Analysis folder location
outpath='./../Output/'; % Output folder location
probe_results=zeros(length(subjects),11);
probe_results(:,1)=subjects;

for subjInd=1:length(subjects)
    
       % Open Probe data and convert to one matrix
    ProbeLogs=dir([outpath,'*',num2str(subjects(subjInd)),'_probe_block*.txt']) ;
    Probe_data=[];
    for datafile = 1:length(ProbeLogs)
        fid=fopen(strcat(outpath,ProbeLogs(datafile).name));
        Data=textscan(fid, '%s%f%f%f%f%f%f%s%s%f%f%f%s%f%f%f%f%f' , 'HeaderLines', 1);     %read in probe output file into P ;
        
        % Convert all string variables into numbers
        Data{1}(:)={subjects(subjInd)}; %subject's code
        for i=1:length(Data{1})
            Data{8}{i}=str2num(Data{8}{i}(1:end-4)); % left stimulus
            Data{9}{i}=str2num(Data{9}{i}(1:end-4)); % right stimulus
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
    binary_ranking_file=dir([outpath,'*',num2str(subjects(subjInd)),'_binary_ranking*.txt']);
    fid=fopen([outpath,binary_ranking_file.name]);
    binary_ranking_data=textscan(fid, '%s %f %f %s %s %f %f %s %f %f ', 'HeaderLines', 1);
    fclose(fid);
    
    % Open the stopGo file
    stopGo_file=dir([outpath,'*',num2str(subjects(subjInd)),'_stopGoList_allstim_order',num2str(order),'.txt']);
    fid=fopen([outpath,stopGo_file.name]);
    stopGo=textscan(fid, '%s %f %f %f %f');
    fclose(fid);
    
    % create two lists of all presented pairs in the binary ranking part, according to their numerical names
    binary_ranking_stim_left=binary_ranking_data{4};
    binary_ranking_stim_right=binary_ranking_data{5};
    pairs_binary=zeros(length(binary_ranking_data{1}),1);
    for i=1:length(binary_ranking_stim_left) % Convert all string variables into numbers
        binary_ranking_stim_left{i}=str2num(binary_ranking_stim_left{i}(1:end-3));
        binary_ranking_stim_right{i}=str2num(binary_ranking_stim_right{i}(1:end-3));
        pairs_binary(i)=max(binary_ranking_stim_left{i},binary_ranking_stim_right{i})*10000+min(binary_ranking_stim_left{i},binary_ranking_stim_right{i}); % This variable returns a unique index for each pair of stimuli: min*1000+max,
        %   e.g: the pair [105,032] will be given the index 32105. The index 55002 is translated to the pair [055,002].
    end
    % The same indexing process, now on the pairs in the probe part of the experiment.
    image_left=Probe_data(:,8);
    image_right=Probe_data(:,9);
    pairs_probe=zeros(length(image_left),2);
    for i=1:length(image_left)
        pairs_probe(i,1)=max(image_left(i),image_right(i))*10000+min(image_left(i),image_right(i)); % unique index for each pair of stimuli: min*1000+max
        pairs_probe(i,2)=sum(pairs_binary==pairs_probe(i,1)); %count how many times each probe pair appeared in the ranking part
    end
    
    repeating_pairs=ismember(pairs_binary,pairs_probe(:,1).*pairs_probe(:,2)); % indices in the binary file of pairs which were presented in both ranking and probe part
    repeating_choises_matrix=zeros(sum(repeating_pairs),10);
    
    repeating_choises_matrix(:,1)=Probe_data(1); % subject ID
    repeating_choises_matrix(:,2)=binary_ranking_stim_left(repeating_pairs); % stim left
    repeating_choises_matrix(:,3)=binary_ranking_stim_right(repeating_pairs); % stim right
    repeating_choises_matrix(:,4)=pairs_binary(repeating_pairs);
    repeating_choises_matrix(:,4)=cell2mat(binary_ranking_data{8}(repeating_pairs)); % Subject response - 1 left, 0 - right
    
    for i=1:sum(repeating_pairs)
        this_pair_in_probe
        repeating_choises_matrix(i,5) = % is left Go?
        repeating_choises_matrix(i,6) = % Outcome - did subject chose the Go item in binary ranking choices
        repeating_choises_matrix(i,7) = % PairType

        out_rank_left(i)=stopGo{3}(strcmp(out_stim_left(i),stopGo{1}));
        out_rank_right(i)=stopGo{3}(strcmp(out_stim_right(i),stopGo{1}));
        out_colley_left(i)= stopGo{4}(strcmp(out_stim_left(i),stopGo{1}));
        out_colley_right(i)= stopGo{4}(strcmp(out_stim_right(i),stopGo{1}));
        
        fprintf(fid2,'%s\t %s\t %s\t %s\t %.2f\t %.0f\t %.0f\t %f\t %f\n',out_subjID{1},out_stim_left{i},out_stim_right{i},out_response(i),out_response_rt(i),out_rank_left(i),out_rank_right(i),out_colley_left(i),out_colley_right(i));
    end
    fclose(fid2);
end
