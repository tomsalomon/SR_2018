
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Correlation between %HV_GO chosen or %HV_GO chosen with PHQ and STA
% quizzes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;

Probe_analysis_boost_faces_for_questionnairs;
HV_Go_percent_chosen = probe_results(:,7);
LV_Go_percent_chosen =  probe_results(:,8);
all_Go_percent_chosen = [HV_Go_percent_chosen LV_Go_percent_chosen];

outputPath= pwd ; % Output folder; location
file = dir([outputPath '/' sprintf('questionnaires*.txt')]);
fid = fopen([outputPath '/' sprintf(file(length(file)).name)]);
q_headers=fgetl(fid);
q_headers=strsplit(q_headers);
q_headers=q_headers(2:end);
data = textscan(fid, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f ');
fid=fclose(fid);

inverse_questions = [11 12 15 18 20 21 25 26 29 30 31 33 36 37 40 43 44 46 49];

for ind = 1:50
    if ismember(ind,inverse_questions) == 1
        for inv = 1: length(data{1,ind+1})
            switch data{1,ind+1}(inv)
                case 1
                    data{1,ind+1}(inv) = 4;
                case 2
                    data{1,ind+1}(inv) = 3;
                case 3
                    data{1,ind+1}(inv) = 2;
                case 4
                    data{1,ind+1}(inv) = 1;
            end
        end
    end
    questions(:,ind) = data{1,ind+1};
end
questions(questions==999)=nan;
for j = 1:length(HV_Go_percent_chosen)
    PHQ_score_sum(j) = nansum(questions(j,1:9))-9;
    PHQ_score_mean(j) = nanmean(questions(j,1:9))-0.9;
    
    SA_score_sum(j) = nansum (questions(j,11:30));
    SA_score_mean(j) = nanmean (questions(j,11:30));
    
    TA_score_sum(j) = nansum (questions(j,31:50));
    TA_score_mean(j) = nanmean (questions(j,31:50));
    
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %Min-Max-Mean
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Max_PHQ = max(PHQ_score_sum)
Min_PHQ = min(PHQ_score_sum)
Mean_PHQ = mean(PHQ_score_sum)

Max_SA = max(SA_score_sum)
Min_SA = min(SA_score_sum)
Mean_SA = mean(SA_score_sum)

Max_TA = max(TA_score_sum)
Min_TA = min(TA_score_sum)
Mean_TA = mean(TA_score_sum)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %PHQ correlations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PHQ_sum_subj_HV_RHO = corr(HV_Go_percent_chosen, PHQ_score_sum','type','Spearman');
PHQ_sum_subj_LV_RHO = corr(LV_Go_percent_chosen, PHQ_score_sum','type','Spearman');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %SA correlations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SA_sum_subj_HV_RHO = corr(HV_Go_percent_chosen, SA_score_sum','type','Spearman');
SA_sum_subj_LV_RHO = corr(LV_Go_percent_chosen, SA_score_sum','type','Spearman');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %TA correlations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TA_sum_subj_HV_RHO = corr(HV_Go_percent_chosen, TA_score_sum','type','Spearman');
TA_sum_subj_LV_RHO = corr(LV_Go_percent_chosen, TA_score_sum','type','Spearman');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %All questions correlations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
correlation_mat = zeros (2,length(questions)); % 1st row for HV, 2nd row for LV.
for HV_LV = 1:2
    for i = 1:length (questions)
        correlation_mat(HV_LV,i) = corr(all_Go_percent_chosen(:,HV_LV)*100,questions(:,i),'type', 'Spearman','rows','complete'); %need
    end
end

fprintf('\na total of %d item were found to in correlation greater than 0.3 with HV:\n', sum(abs(correlation_mat(1,:))>=0.3))
disp(q_headers(abs(correlation_mat(1,:))>=0.3));
disp(correlation_mat(1,abs(correlation_mat(1,:))>=0.3));
fprintf('\na total of %d item were found to in correlation greater than 0.3 with LV:\n', sum(abs(correlation_mat(2,:))>=0.3))
disp(q_headers(abs(correlation_mat(2,:))>=0.3));
disp(correlation_mat(2,abs(correlation_mat(2,:))>=0.3));

% rpb correlation with high PHQ score (>9) and cue approach results
high_PHQ_score=PHQ_score_sum'>=9 & PHQ_score_sum'<26;
low_PHQ_score=PHQ_score_sum'<9;

[~,PHQ_ttest_HV_p]=ttest2(all_Go_percent_chosen(high_PHQ_score,1),all_Go_percent_chosen(low_PHQ_score,1),'Vartype','unequal');
fprintf('\nPHQ score and HV ttest: p=%f\n',PHQ_ttest_HV_p);
[~,PHQ_ttest_LV_p]=ttest2(all_Go_percent_chosen(high_PHQ_score,2),all_Go_percent_chosen(low_PHQ_score,2),'Vartype','unequal');
fprintf('\nPHQ score and LV ttest: p=%f\n',PHQ_ttest_LV_p);

[r,p]=corr(high_PHQ_score,all_Go_percent_chosen(:,1));
fprintf('\nPHQ score and HV: rpb=%f, p=%f\n',r,p);
[r,p]=corr(high_PHQ_score,all_Go_percent_chosen(:,2));
fprintf('PHQ score and LV: rpb=%f, p=%f\n',r,p);

results=[Mean_PHQ,Min_PHQ,Max_PHQ,Mean_SA,Min_SA,Max_SA,Mean_TA,Min_TA,Max_TA,...
    PHQ_sum_subj_HV_RHO,PHQ_sum_subj_LV_RHO...
    SA_sum_subj_HV_RHO,SA_sum_subj_LV_RHO...
    TA_sum_subj_HV_RHO,TA_sum_subj_LV_RHO...
    PHQ_ttest_HV_p,PHQ_ttest_LV_p];
