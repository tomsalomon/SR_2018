
% ~~~~~~~~~~ Script for analyzing fast_dm resultst ~~~~~~~~~
% ~~~~~~~~~~~~~~~ Tom Salomon, September 2016  ~~~~~~~~~~~~~~


clear;
close all;

% set the names of the samples to include, as appearing in their dir name
exp_name={'Boost_faces_new';'Boost_fractals_I';'Boost_fractals_II';'Boost_visual_cue';'Boost_aversive_cue';'Boost_IAPS_Positive_I';'Boost_IAPS_Positive_II';'Boost_IAPS_Negative_I';'Boost_IAPS_Negative_II'};
num_of_exp=length(exp_name);
current_dir=pwd;
fast_dm_data=zeros(1,7);
Statistics=zeros(length(exp_name),8);
header=cell(15,1);
for exp_num=1:length(exp_name)
    fid=fopen(['./../../',exp_name{exp_num},'/Analysis/fast_dm/exp_outcome.txt']);
    
    
    % 	dataset	zr_2	zr_1	a	v_2	t0	d	szr	sv	st0	v_1	penalty	fit	time	method
    headers_cell=textscan(fid, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1);
    for i=1:length(headers_cell)
        header{i}=cell2mat(headers_cell{i});
    end
    data=textscan(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %s');     %read output file
    fid=fclose(fid);
    

    unique_id=exp_num*1000+data{1};
    zr_1=data{strcmp(header,'zr_1')};
    zr_2=data{strcmp(header,'zr_2')};
    v_1=data{strcmp(header,'v_1')};
    v_2=data{strcmp(header,'v_2')};
    t0=data{strcmp(header,'t0')};
    fit=data{strcmp(header,'fit')};
    
    sample_data=[unique_id,zr_1,zr_2,v_1,v_2,t0,fit];
    fast_dm_data(end+1:end+length(data{1}),:)=sample_data;
    
    %     data(end)=[] ;% remove last method col
    %     sample_data=(data);
    %     fast_dm_data(end+1:end+length(data{1}),:)=[sample_data(:,1)+1000*exp_num,exp_num*ones(length(data{1}),1),sample_data];
    
    % DESCRIPTIVE STATISTICS
    
    Statistics(exp_num,1)=mean(zr_1); % Zr 1
    Statistics(exp_num,2)=mean(zr_2); % Zr 2
    Statistics(exp_num,3)=mean(v_1); % V 1
    Statistics(exp_num,4)=mean(v_2); % V 2
    
    % STATISTICS
    
    [~,Statistics(exp_num,5)]=ttest(zr_1,0.5);  % Zr 1
    [~,Statistics(exp_num,6)]=ttest(zr_2,0.5);  % Zr 2
    [~,Statistics(exp_num,7)]=ttest(v_1,0);  % V 1
    [~,Statistics(exp_num,8)]=ttest(v_2,0); % V 2
    
    
end
% remove first line of zeros
fast_dm_data(1,:)=[];

fast_dm_var_names={'UniqeID','zr_1','zr_2','v_1','v_2','t0','fit'};
fast_dm_table=array2table(fast_dm_data,'VariableNames',fast_dm_var_names);
Statistics_var_names={'zr1','zr2','v1','v2','zr1_p','zr2_p','v1_p','v2_p'};
Statistics_table=array2table(Statistics,'RowNames',exp_name,'VariableNames',Statistics_var_names);
