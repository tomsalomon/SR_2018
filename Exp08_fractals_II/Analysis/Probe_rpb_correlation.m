
clear all

subjects=[101:113,115:124,126:127]; % Define here your subjects' codes.
%exclude:
% 114 - had problems with the sound at one training run
% stop responding in parts of training

analysis_path=pwd; % Analysis folder location
outpath=['./../Output/']; % Output folder location
all_subjs_data{length(subjects)}={};
probe_results=zeros(length(subjects),22);
probe_results(:,1)=subjects;

for subjInd=1:length(subjects)
    
    % Open Go/NoGo recognition data
    IsGoLogs=dir([outpath,'*',num2str(subjects(subjInd)),'_recognitionGoNoGo*.txt']) ;
    fid_isGO=fopen([outpath,IsGoLogs(1).name]);
    IsGoData=textscan(fid_isGO, '%s %f %s %f %f %f %f %f %f %f %f %s %f', 'HeaderLines', 1);     %read output file
    fid_isGO=fclose(fid_isGO);
    
    IsGo=IsGoData{9};
    subjectAnswerGo=IsGoData{10};
    IsGoCorrectResponse=IsGo==subjectAnswerGo;
    IsGoItemRank=IsGoData{5};
    order=IsGoData{2}(1);
    
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
    
    Probe_data(Probe_data(:,15)==999,15)=0;
    
    
    if order==1 %define which stimuli were Go items: [HighSanity   High   MidHighSanity   MidLowSanity   Low  LowSanity]
        HVGoStim=[7 10 12 13 15 18];
        LVGoStim=[44 45 47 50 52 53];
    elseif order==2
        HVGoStim=[8 9 11 14 16 17];
        LVGoStim=[43 46 48 49 51 54];
    end
    
    for GoStim=1:length(HVGoStim)
        % was the Go item correctly recognized as Go
        if sum(IsGoItemRank==HVGoStim(GoStim))==1
            recognition_table_HV(subjInd,GoStim)=IsGoCorrectResponse(IsGoItemRank==HVGoStim(GoStim));
        else
            recognition_table_HV(subjInd,GoStim)=0;
        end
        if sum(IsGoItemRank==LVGoStim(GoStim))==1
            recognition_table_LV(subjInd,GoStim)=IsGoCorrectResponse(IsGoItemRank==LVGoStim(GoStim));
        else
            recognition_table_LV(subjInd,GoStim)=0;
        end
        GoStim_location_in_probe_HV=(HVGoStim(GoStim)==Probe_data(:,10))|(HVGoStim(GoStim)==Probe_data(:,11));
        GoStim_location_in_probe_LV=(LVGoStim(GoStim)==Probe_data(:,10))|(LVGoStim(GoStim)==Probe_data(:,11));
        
        % number of times the Go item was chosen over the NoGo
        probe_table_HV(subjInd,GoStim)=sum(Probe_data(GoStim_location_in_probe_HV,15));
        probe_table_LV(subjInd,GoStim)=sum(Probe_data(GoStim_location_in_probe_LV,15));
        
    end
    
    [Rpb_corr(subjInd,1),Rpb_corr(subjInd,2)]=corr(recognition_table_HV(subjInd,:)',probe_table_HV(subjInd,:)');
    [Rpb_corr(subjInd,3),Rpb_corr(subjInd,4)]=corr(recognition_table_LV(subjInd,:)',probe_table_LV(subjInd,:)');
    
end

recognition_table_all=[recognition_table_HV,recognition_table_LV];
probe_table_all=[probe_table_HV,probe_table_LV];

for subjInd=1:length(subjects)
        [Rpb_corr(subjInd,5),Rpb_corr(subjInd,6)]=corr(recognition_table_all(subjInd,:)',probe_table_all(subjInd,:)');
end

mean_Rpb_HV=nanmean(Rpb_corr(:,1));
mean_Rpb_LV=nanmean(Rpb_corr(:,3));
mean_Rpb_All=nanmean(Rpb_corr(:,5));

fprintf('\nMean Rpb correlations:\n');
fprintf('HV: %.2f, valid n=%.0f\n',mean_Rpb_HV,length(Rpb_corr(:,1))-sum(isnan(Rpb_corr(:,1))));
fprintf('LV: %.2f, valid n=%.0f\n',mean_Rpb_LV,length(Rpb_corr(:,3))-sum(isnan(Rpb_corr(:,3))));
fprintf('All: %.2f, valid n=%.0f\n\n',mean_Rpb_All,length(Rpb_corr(:,5))-sum(isnan(Rpb_corr(:,5))));


