
function [Recognition_results_table,Recognition_results_mat]=recognition_RT_analysis(subjects,outpath)

if nargin<1
    subjects=[101:120,122:126]; % Define here your subjects' codes.
    %exclude:
    
end

if nargin <2
    outpath='./../Output/';
end
Recognition_results_mat=nan(length(subjects),13);

for subjInd=1:length(subjects)
    
    % memory log file
    RecognitionLogs=dir([outpath,'/*',num2str(subjects(subjInd)),'_reco*.txt']) ;
    RecognitionLogs_followup=dir([outpath,'/recall/*',num2str(subjects(subjInd)),'_reco*.txt']) ;
    
    % in the confidence task only one log file will exist
    is_confidence=length(RecognitionLogs)==1;
    
    % look for follow-up files
    is_followup=length(RecognitionLogs_followup)>=1;
    
    if is_confidence
        if is_followup
            Recognition_file_Confidence=[outpath,'recall/',RecognitionLogs_followup(1).name];
            
            ConfidenceData=readtable_new(Recognition_file_Confidence,'\t');
            ConfidenceData(ConfidenceData.isOld_==0,:)=[]; % remove New items from analysis
            ConfidenceData(zscore(ConfidenceData.RT_isOld)>2|zscore(ConfidenceData.RT_isOld)<-2,:)=[]; %remove outlier RTs
            
            RT_IsOld=ConfidenceData.RT_isOld; % RT
            IsGo_IsOld=ConfidenceData.isGo_==1; % is it a Go item
            IsHV_IsOld=ConfidenceData.bidInd<30&ConfidenceData.bidInd>0; % is HV
            IsLV_IsOld=ConfidenceData.bidInd>30; % is LV
            
            % Calculate variables
            RT_All_Go_followup=mean(RT_IsOld(IsGo_IsOld==1)); % RT all Go items
            RT_All_NoGo_followup=mean(RT_IsOld(IsGo_IsOld==0)); % RT all NoGo items
            RT_HV_Go_followup=mean(RT_IsOld(IsGo_IsOld==1&IsHV_IsOld)); % RT HV Go items
            RT_HV_NoGo_followup=mean(RT_IsOld(IsGo_IsOld==0&IsHV_IsOld)); % RT HV NoGo items
            RT_LV_Go_followup=mean(RT_IsOld(IsGo_IsOld==1&IsLV_IsOld)); % RT LV Go items
            RT_LV_NoGo_followup=mean(RT_IsOld(IsGo_IsOld==0&IsLV_IsOld)); % LV all NoGo items
            
        end
        Recognition_file_Confidence=[outpath,RecognitionLogs(1).name]; % logs: 1 - GoNoGo, 3 - OldNew
        
        ConfidenceData=readtable_new(Recognition_file_Confidence,'\t');
        ConfidenceData(ConfidenceData.isOld_==0,:)=[]; % remove New items from analysis
        ConfidenceData(zscore(ConfidenceData.RT_isOld)>2|zscore(ConfidenceData.RT_isOld)<-2,:)=[]; %remove outlier RTs
        
        RT_IsOld=ConfidenceData.RT_isOld; % RT
        IsGo_IsOld=ConfidenceData.isGo_==1; % is it a Go item
        IsHV_IsOld=ConfidenceData.bidInd<30&ConfidenceData.bidInd>0; % is HV
        IsLV_IsOld=ConfidenceData.bidInd>30; % is LV
        
        % Calculate variables
        RT_All_Go=mean(RT_IsOld(IsGo_IsOld==1)); % RT all Go items
        RT_All_NoGo=mean(RT_IsOld(IsGo_IsOld==0)); % RT all NoGo items
        RT_HV_Go=mean(RT_IsOld(IsGo_IsOld==1&IsHV_IsOld)); % RT HV Go items
        RT_HV_NoGo=mean(RT_IsOld(IsGo_IsOld==0&IsHV_IsOld)); % RT HV NoGo items
        RT_LV_Go=mean(RT_IsOld(IsGo_IsOld==1&IsLV_IsOld)); % RT LV Go items
        RT_LV_NoGo=mean(RT_IsOld(IsGo_IsOld==0&IsLV_IsOld)); % LV all NoGo items
            
    else % Not a confidence recognition file
        if is_followup %Followup session data
            Recognition_file_OldNew=[outpath,'recall/',RecognitionLogs_followup(3).name]; % logs: 1 - GoNoGo, 3 - OldNew
            IsOldData=readtable_new(Recognition_file_OldNew,'\t');
            IsOldData(IsOldData.isOld_==0,:)=[]; % remove New items from analysis
            IsOldData(zscore(IsOldData.RT)>2|zscore(IsOldData.RT)<-2,:)=[]; %remove outlier RTs
            
            RT_IsOld=IsOldData.RT; % RT
            IsGo_IsOld=IsOldData.isBeep_==1; % is it a Go item
            IsHV_IsOld=IsOldData.bidInd<30&IsOldData.bidInd>0; % is HV
            IsLV_IsOld=IsOldData.bidInd>30; % is LV
            
            % Calculate variables
            RT_All_Go_followup=mean(RT_IsOld(IsGo_IsOld==1)); % RT all Go items
            RT_All_NoGo_followup=mean(RT_IsOld(IsGo_IsOld==0)); % RT all NoGo items
            RT_HV_Go_followup=mean(RT_IsOld(IsGo_IsOld==1&IsHV_IsOld)); % RT HV Go items
            RT_HV_NoGo_followup=mean(RT_IsOld(IsGo_IsOld==0&IsHV_IsOld)); % RT HV NoGo items
            RT_LV_Go_followup=mean(RT_IsOld(IsGo_IsOld==1&IsLV_IsOld)); % RT LV Go items
            RT_LV_NoGo_followup=mean(RT_IsOld(IsGo_IsOld==0&IsLV_IsOld)); % LV all NoGo items
            
        end
        % First Session data
        Recognition_file_OldNew=[outpath,RecognitionLogs(3).name]; % logs: 1 - GoNoGo, 3 - OldNew
        
        IsOldData=readtable_new(Recognition_file_OldNew,'\t');
        IsOldData(IsOldData.isOld_==0,:)=[]; % remove New items from analysis
        IsOldData(zscore(IsOldData.RT)>2|zscore(IsOldData.RT)<-2,:)=[]; %remove outlier RTs
        
        RT_IsOld=IsOldData.RT; % RT
        IsGo_IsOld=IsOldData.isBeep_==1; % is it a Go item
        IsHV_IsOld=IsOldData.bidInd<30&IsOldData.bidInd>0; % is HV
        IsLV_IsOld=IsOldData.bidInd>30; % is LV
        
        % Calculate variables
        RT_All_Go=mean(RT_IsOld(IsGo_IsOld==1)); % RT all Go items
        RT_All_NoGo=mean(RT_IsOld(IsGo_IsOld==0)); % RT all NoGo items
        RT_HV_Go=mean(RT_IsOld(IsGo_IsOld==1&IsHV_IsOld)); % RT HV Go items
        RT_HV_NoGo=mean(RT_IsOld(IsGo_IsOld==0&IsHV_IsOld)); % RT HV NoGo items
        RT_LV_Go=mean(RT_IsOld(IsGo_IsOld==1&IsLV_IsOld)); % RT LV Go items
        RT_LV_NoGo=mean(RT_IsOld(IsGo_IsOld==0&IsLV_IsOld)); % LV all NoGo items

    end
    
    
    Recognition_results_mat(subjInd,1)=subjects(subjInd);
    
    Recognition_results_mat(subjInd,2)=RT_All_Go;
    Recognition_results_mat(subjInd,3)=RT_All_NoGo;
    
    Recognition_results_mat(subjInd,4)=RT_HV_Go;
    Recognition_results_mat(subjInd,5)=RT_HV_NoGo;
    Recognition_results_mat(subjInd,6)=RT_LV_Go;
    Recognition_results_mat(subjInd,7)=RT_LV_NoGo;
    
    
    if is_followup
        Recognition_results_mat(subjInd,8)=RT_All_Go_followup;
        Recognition_results_mat(subjInd,9)=RT_All_NoGo_followup;
        
        Recognition_results_mat(subjInd,10)=RT_HV_Go_followup;
        Recognition_results_mat(subjInd,11)=RT_HV_NoGo_followup;
        Recognition_results_mat(subjInd,12)=RT_LV_Go_followup;
        Recognition_results_mat(subjInd,13)=RT_LV_NoGo_followup;
    end
end
TableHeaders={'SubID','RT_All_Go','RT_All_NoGo','RT_HV_Go','RT_HV_NoGo','RT_LV_Go','RT_LV_NoGo','RT_All_Go_Follwup','RT_All_NoGo_Follwup','RT_HV_Go_Follwup','RT_HV_NoGo_Follwup','RT_LV_Go_Follwup','RT_LV_NoGo_Follwup'};
Recognition_results_table=array2table(Recognition_results_mat,'VariableNames',TableHeaders);




