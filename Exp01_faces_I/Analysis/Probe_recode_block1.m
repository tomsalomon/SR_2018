
function [subject_data]=Probe_recode_block1 (subj_id_num)

analysis_path=pwd;
outpath=[analysis_path(1:end-8),'Output\'];

    filename=strcat(outpath,sprintf('BMI_bf_%d',subj_id_num));
    logs=dir(strcat(filename, '_probe_block_01','*.txt')) ;
    subject_data=[];
    for datafile = 1:length(logs)
        fid=fopen(strcat(outpath,logs(datafile).name));
        Data=textscan(fid, '%s%f%f%f%f%f%f%s%s%f%f%f%s%f%f%f%f%f' , 'HeaderLines', 1);     %read in probe output file into P ;
        
        % Convert all string variables into numbers
        Data{1}(:)={subj_id_num}; %subject's code
        for i=1:length(Data{1})
            Data{8}{i}=str2num(Data{8}{i}(1:3)); % left stimulus
            Data{9}{i}=str2num(Data{9}{i}(1:3)); % right stimulus
        end
        Data{13}(strcmp(Data{13},'u'))={1}; % response: 1 for left
        Data{13}(strcmp(Data{13},'i'))={0}; % response: 0 for right
        Data{13}(strcmp(Data{13},'x'))={999}; % response: 99 for no response
        
        Data{1}=cell2mat(Data{1});
        Data{8}=cell2mat(Data{8});
        Data{9}=cell2mat(Data{9});
        Data{13}=cell2mat(Data{13});
        
        fclose(fid);
  subject_data(end+1:end+68,:)=cell2mat(Data);     
    end
    
end
