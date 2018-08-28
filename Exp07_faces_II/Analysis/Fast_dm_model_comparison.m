
% ~~~~~~~~~~ Script for analyzing fast_dm resultst ~~~~~~~~~
% ~~~~~~~~~~~~~~~ Tom Salomon, September 2016  ~~~~~~~~~~~~~~


clear;
close all;

% set the names of the samples to include, as appearing in their dir name
exp_name={'Boost_faces_new';'Boost_fractals_I';'Boost_fractals_II';'Boost_visual_cue';'Boost_aversive_cue';'Boost_IAPS_Positive_I';'Boost_IAPS_Positive_II';'Boost_IAPS_Negative_I';'Boost_IAPS_Negative_II'};
exp_name_spaced = strrep(exp_name, '_', ' ');
num_of_exp=length(exp_name);
current_dir=pwd;
fast_dm_data=zeros(1,14);
Statistics=zeros(length(exp_name),8);
header_both=cell(11,1);
header_zr=cell(10,1);
header_v=cell(10,1);
% number of parameters estimated
k_both=6;
k_zr=5;
k_v=5;

figure('units','normalized','outerposition',[0 0 1 1])

for exp_num=1:length(exp_name)
    analysis_path=['./../../',exp_name{exp_num},'/Analysis'];
    fid_both=fopen([analysis_path,'/fast_dm/splitted_exp_outcome_both_free.txt']);
    fid_zr=fopen([analysis_path,'/fast_dm/splitted_exp_outcome_zr_free.txt']);
    fid_v=fopen([analysis_path,'/fast_dm/splitted_exp_outcome_v_free.txt']);
    
    % dataset       zr        a        v       t0        d      szr       sv      st0  penalty      fit     time   method
    headers_cell_both=textscan(fid_both, '%s %s %s %s %s %s %s %s %s %s %s %s %s',1);
    headers_cell_zr=textscan(fid_zr, '%s %s %s %s %s %s %s %s %s %s %s %s',1);
    headers_cell_v=textscan(fid_v, '%s %s %s %s %s %s %s %s %s %s %s %s',1);
    
    for i=1:length(headers_cell_both)
        header_both{i}=cell2mat(headers_cell_both{i});
        if i<=length(headers_cell_zr)
            header_zr{i}=cell2mat(headers_cell_zr{i});
            header_v{i}=cell2mat(headers_cell_v{i});
        end
    end
    
    data_both=textscan(fid_both, '%s %f %f %f %f %f %f %f %f %f %s');     %read output file
    data_zr=textscan(fid_zr, '%s %f %f %f %f %f %f %f %f %s');     %read output file
    data_v=textscan(fid_v, '%s %f %f %f %f %f %f %f %f %s');     %read output file
    
    fid_both=fclose(fid_both);
    fid_zr=fclose(fid_zr);
    fid_v=fclose(fid_v);
    
    sample=ones(size(data_both{1}))*exp_num;
    unique_id=exp_num*1000+str2num(cell2mat(data_both{1}));
    zr_both=data_both{strcmp(header_both,'zr')};
    zr_zr=data_zr{strcmp(header_zr,'zr')};
    zr_v=ones(size(zr_zr))*0.5; %fixed to 0.5
    
    v_both=data_both{strcmp(header_both,'v')};
    v_zr=zeros(size(zr_zr)); %fixed to 0
    v_v=data_v{strcmp(header_v,'v')};
    
    fit_both=data_both{strcmp(header_both,'fit')};
    fit_zr=data_zr{strcmp(header_zr,'fit')};
    fit_v=data_v{strcmp(header_v,'fit')};
    
    %     if strcmp(exp_name{exp_num},'Boost_IAPS_Negative_II')
    %         dm_files=dir([analysis_path,'/fast_dm/2*.dat']);
    %     else
    %         dm_files=dir([analysis_path,'/fast_dm/1*.dat']);
    %     end
    
    
    dm_files=dir([analysis_path,'/fast_dm/splitted*.dat']);
    
    
    n=zeros(length(dm_files),1);
    for j=1:length(dm_files)
        fid=fopen([analysis_path,'/fast_dm/',dm_files(j).name]);
        read_dm_files=textscan(fid,'%f %f %f %f %f %f');
        fid=fclose(fid);
        n(j)=length(read_dm_files{1});
    end
    % BIC=-2LogLikelihood+k*ln(n)
    BIC_both= 2*fit_both+k_both*log(n);
    BIC_zr= 2*fit_zr+k_zr*log(n);
    BIC_v= 2*fit_v+k_v*log(n);
    % [~,best_model]=min([BIC_both,BIC_zr,BIC_v],[],2);
    [~,best_model]=min([BIC_both,BIC_zr,BIC_v],[],2);
    
    % Get Probe results
    subjects=str2num(cell2mat(data_both{1}));
    outpath=[analysis_path,'/fast_dm/'];
    probe_results=zeros(length(subjects),2);
    probe_results(:,1)=subjects;
    for subjInd=1:length(subjects)
        data_probe=csvread([outpath,'splitted_probe_',num2str(subjects(subjInd)),'.txt']);
        PairType=data_probe(:,14);
        Outcome=data_probe(:,15);
        probe_results(subjInd,2)=sum(PairType<=2&Outcome==1)/sum(PairType<=2&Outcome~=999); % Percent chosen Go
    end
    
    % Plot a pie chart of the best model
    pie_categories={'Both: ';'Zr: ';'V: '};
    pie_values1=[sum(best_model==1);sum(best_model==2);sum(best_model==3)];
    pie_annot1 = strcat(pie_categories,num2str(pie_values1));
    subplot(2,length(exp_name),exp_num)
    pie(pie_values1,pie_annot1)
    title(exp_name{exp_num},'Interpreter','None');
    
    
    thresh=0.7;
    pie_values2=[sum(best_model==1&probe_results(:,2)>thresh);sum(best_model==2&probe_results(:,2)>thresh);sum(best_model==3&probe_results(:,2)>thresh)];
    pie_annot2 = strcat(pie_categories,num2str(pie_values2));
    subplot(2,length(exp_name),exp_num+length(exp_name))
    pie(pie_values2,pie_annot2)
    title([exp_name_spaced{exp_num},' Probe>',num2str(thresh)],'Interpreter','None');
    
    sample_data=[sample,unique_id,probe_results,best_model,BIC_both,BIC_zr,BIC_v,zr_both,zr_zr,zr_v,v_v,v_zr,v_v];
    fast_dm_data(end+1:end+length(data_both{1}),:)=sample_data;
    
    %     data(end)=[] ;% remove last method col
    %     sample_data=(data);
    %     fast_dm_data(end+1:end+length(data{1}),:)=[sample_data(:,1)+1000*exp_num,exp_num*ones(length(data{1}),1),sample_data];
    
    % DESCRIPTIVE STATISTICS
    
    Statistics(exp_num,1)=mean(zr_both); % Zr when both parameters are estimated
    Statistics(exp_num,2)=mean(zr_zr); % Zr when V is fixed
    Statistics(exp_num,3)=mean(v_both); % V when both parameters are estimated
    Statistics(exp_num,4)=mean(v_v); %  V when Zr is fixed
    
    % STATISTICS
    
    [~,Statistics(exp_num,5)]=ttest(zr_both,0.5);
    [~,Statistics(exp_num,6)]=ttest(zr_zr,0.5);
    [~,Statistics(exp_num,7)]=ttest(v_both,0);
    [~,Statistics(exp_num,8)]=ttest(v_v,0);
    
    
end
% remove first line of zeros
fast_dm_data(1,:)=[];

fast_dm_var_names={'Experiment','UniqeID','ID','Probe','Best_model','BIC_both','BIC_zr','BIC_v','zr_both','zr_zr','zr_v','v_both','v_zr','v_v'};
fast_dm_table=array2table(fast_dm_data,'VariableNames',fast_dm_var_names);
Statistics_var_names={'zr_both','zr_zr','v_both','v_v','zr_both_p','zr_zr_p','v_both_p','v_v_p'};
Statistics_table=array2table(Statistics,'RowNames',exp_name,'VariableNames',Statistics_var_names);

fast_dm_table.delta_BIC=fast_dm_table.BIC_zr-fast_dm_table.BIC_v;
figure

% minimun and maximum values, rounded to 2 digits time
xlim_delta_BIC=10*[floor(min(fast_dm_table.delta_BIC)/10),ceil(max(fast_dm_table.delta_BIC)/10)];
for exp_num=1:length(exp_name)
    subplot(2,ceil(length(exp_name)/2),exp_num)
    %figure;
    scatter(fast_dm_table.delta_BIC(fast_dm_table.Experiment==exp_num),fast_dm_table.Probe(fast_dm_table.Experiment==exp_num),'k','filled')
    xlabel('\Delta BIC: Zr minus V')
    ylabel('Proportion chosen Go')
    ylim([0,1])
    xlim(xlim_delta_BIC)
    chance_level=refline(0,0.5);
    chance_level.Color='k';
    chance_level.LineStyle='--';
    hold on
    plot([0 0],[0 1],'k--')
    [correlations_BIC_diff(exp_num),correlations_BIC_diff_p(exp_num)]=corr(fast_dm_table.delta_BIC(fast_dm_table.Experiment==exp_num),fast_dm_table.Probe(fast_dm_table.Experiment==exp_num));
    title([exp_name_spaced{exp_num},': r=',num2str(round(correlations_BIC_diff(exp_num),2))],'Interpreter','None')
    %     title(['Experiment ',num2str(exp_num)])
    prop_pos_delta_BIC(exp_num)=sum(fast_dm_table.delta_BIC(fast_dm_table.Experiment==exp_num)>0)/sum(fast_dm_table.Experiment==exp_num);
    mean_delta_BIC(exp_num)=mean(fast_dm_table.delta_BIC(fast_dm_table.Experiment==exp_num)');
    std_delts_BIC(exp_num)=std(fast_dm_table.delta_BIC(fast_dm_table.Experiment==exp_num)');
    stderr_delts_BIC(exp_num)=std_delts_BIC(exp_num)/sqrt(sum(fast_dm_table.Experiment==exp_num));
    %     set(gca,'FontSize',24)
    %     saveas(gcf,[num2str(exp_num),'.jpg'])
end

figure
% minimun and maximum values, rounded to 2 digits time
xlim_BIC=10*[floor(min([fast_dm_table.BIC_zr;fast_dm_table.BIC_v])/10),ceil(max([fast_dm_table.BIC_zr;fast_dm_table.BIC_v])/10)];
for exp_num=1:length(exp_name)
    subplot(2,ceil(length(exp_name)/2),exp_num)
    scatter(fast_dm_table.BIC_zr(fast_dm_table.Experiment==exp_num),fast_dm_table.Probe(fast_dm_table.Experiment==exp_num),'r')
    hold on
    scatter(fast_dm_table.BIC_v(fast_dm_table.Experiment==exp_num),fast_dm_table.Probe(fast_dm_table.Experiment==exp_num),'b')
    xlabel('BIC')
    ylabel('Proportion chosen Go')
    ylim([0,1])
    xlim(xlim_BIC)
    legend({'Zr','V'})
    chance_level=refline(0,0.5);
    chance_level.Color='k';
    chance_level.LineStyle='--';
    correlations(exp_num,1)=corr(fast_dm_table.BIC_zr(fast_dm_table.Experiment==exp_num),fast_dm_table.Probe(fast_dm_table.Experiment==exp_num));
    correlations(exp_num,2)=corr(fast_dm_table.BIC_v(fast_dm_table.Experiment==exp_num),fast_dm_table.Probe(fast_dm_table.Experiment==exp_num));
    title([exp_name_spaced{exp_num},': r_zr=',num2str(round(correlations(exp_num,1),2)),'; r_v=',num2str(round(correlations(exp_num,2),2))],'Interpreter','None')
end

for exp_num=1:length(exp_name)
    [~,ttest_results(exp_num)]=ttest(fast_dm_table.BIC_zr(fast_dm_table.Experiment==exp_num),fast_dm_table.BIC_v(fast_dm_table.Experiment==exp_num));
    Wilcoxon_results(exp_num)=signrank(fast_dm_table.BIC_zr(fast_dm_table.Experiment==exp_num),fast_dm_table.BIC_v(fast_dm_table.Experiment==exp_num));
    permutation_results(exp_num)=dependent_samples_permutation_test(fast_dm_table.BIC_zr(fast_dm_table.Experiment==exp_num),fast_dm_table.BIC_v(fast_dm_table.Experiment==exp_num));
end