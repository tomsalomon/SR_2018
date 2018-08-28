
% ~~~~~~~~~~ Script for analyzing correlation of probe and memory d'~~~~~~~~~
% ~~~~~~~~~~~~~~~ Tom Salomon, November 2016  ~~~~~~~~~~~~~~


clear;
close all;

% set the names of the samples to include, as appearing in their dir name
exp_name={'Boost_faces_new';'Boost_fractals_I';'Boost_fractals_II';'Boost_visual_cue';'Boost_aversive_cue';'Boost_IAPS_Positive_I';'Boost_IAPS_Positive_II';'Boost_IAPS_Negative_I';'Boost_IAPS_Negative_II'};
exp_name_spaced = strrep(exp_name, '_', ' ');
num_of_exp=length(exp_name);
current_dir=pwd;
Probe_d_correlation=zeros(num_of_exp,8);
results_all_exp=cell(num_of_exp,1);

% assuming the script is located within one of the experiments'
% Analysis directory, the main path is two directories above
main_scripts_path='./../../';

for exp_num=1:length(exp_name)
    % dirs location
    analysis_path=[main_scripts_path,exp_name{exp_num},'/Analysis'];
    outpath=[analysis_path,'/../Output/'];
    outpath_followup=[outpath,'recall/'];
    
    % Get Probe results
    % open subjects
    load([analysis_path,'/subjects.mat']);
    
    % summerize probe and d' results in one matrix:
    % 1-SubID 2-probe 3-ProbeFollowup 4-dPrime 5-dPrimeFollowup
    results=zeros(length(subjects),5);
    results(:,1)=subjects;
    for subjInd=1:length(subjects)
        data_probe=Probe_recode(subjects(subjInd),outpath);
        data_probe_followup=Probe_recode(subjects(subjInd),outpath_followup);
        if isempty(data_probe_followup)
            data_probe_followup=nan(size(data_probe));
        end
        data_d_prime=recognition_d_prime_analysis(subjects(subjInd),outpath);
        
        
        PairType=data_probe(:,14);
        Outcome=data_probe(:,15);
        
        PairType_followup=data_probe_followup(:,14);
        Outcome_followup=data_probe_followup(:,15);
        
        results(subjInd,2)=sum(PairType<=1&Outcome==1)/sum(PairType<=1&Outcome~=999); % Percent chosen Go
        results(subjInd,3)=sum(PairType_followup<=1&Outcome_followup==1)/sum(PairType_followup<=1&Outcome_followup~=999); % Percent chosen Go - follow up
        results(subjInd,4)=data_d_prime(2); % memory d'
        results(subjInd,5)=data_d_prime(9); % memory d' - followup
    end
    
    results_all_exp{exp_num}=results;
    results_probe{exp_num}=results(:,2);
    results_probe_followup{exp_num}=results(:,3);
    results_d_prime{exp_num}=results(:,4);
    results_d_prime_followup{exp_num}=results(:,5);
    
    % Calculate probe and d' correlations - original sample
    [Probe_d_correlation(exp_num,1),Probe_d_correlation(exp_num,5)]= corr(results(:,2),results(:,4)); % probe with d'
    
    % Calculate probe and d' correlations - follow-up sample
    try
        [Probe_d_correlation(exp_num,2),Probe_d_correlation(exp_num,6)]= corr(results(:,3),results(:,5),'rows','Complete'); % follow-up probe with follow-up d'
        [Probe_d_correlation(exp_num,3),Probe_d_correlation(exp_num,7)]= corr(results(:,3),results(:,4),'rows','Complete'); % follow-up probe with d'
        [Probe_d_correlation(exp_num,4),Probe_d_correlation(exp_num,8)]= corr(results(:,2),results(:,5),'rows','Complete'); % probe with follow-up d'
    catch
        Probe_d_correlation(exp_num,[2:4,6:8])=nan;
    end
end
