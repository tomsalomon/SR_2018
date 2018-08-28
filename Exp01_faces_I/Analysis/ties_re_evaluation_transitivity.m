
% function []=ties_re_evaluation_transitivity
% This script will open Colley rankings re calculated using 3 ties handeling
% methods (created using '\Experiment_Israel\Shai\Colley_NoTies\'
% colley_tie_handeling code.
% Then it will re calculate the transitivity of the choices with the
% different Colley rankings.
%
% Written by: Tom Salomon
% July 2015

% SubjID, faces_original, faces_TiesRemoved, faces_TiesDuplicated, snacks_original, snacks_TiesRemoved, snacks_TiesDuplicated, Num_of_Ties


transitivity_matrix=zeros(12,9);
transitivity_matrix(:,1)=1:12;

subjects=[101:131,133:134];

choices_all_subjects_faces=cell(length(subjects));
% choices_all_subjects_snacks=cell(length(subjects));

for subj=1:length(subjects)
    rankings_faces=dir(['../rankings_tie_handling/*' num2str(subjects(subj)) '_faces*.txt']);
    %     rankings_snacks=dir(['../rankings_tie_handling/*' subjects(subj) '_*snacks*.txt']);
    binary_choices_faces=dir(['../Output/*' num2str(subjects(subj)) '_faces_probe_ranking*.txt']);
    %     binary_choices_snacks=dir(['../Output/*' subjects(subj) '_snacks_probe_ranking*.txt']);
    
    fid1=fopen(['../rankings_tie_handling/' rankings_faces.name]);
    %     fid2=fopen(['../rankings_tie_handling/' rankings_snacks.name]);
    fid3=fopen(['../Output/' binary_choices_faces.name]);
    %     fid4=fopen(['../Output/' binary_choices_snacks.name]);
    
    
    Colley_faces=textscan(fid1,'%f %f %f %f %f %f %f %f %f %f %f','HeaderLines',1);
    %     Colley_snacks=textscan(fid2,'%f %f %f %f %f %f %f %f %f %f %f','HeaderLines',1);
    Binary_faces=textscan(fid3,'%s %f %f %s %s %f %f %s %f %f','HeaderLines',1);
    %     Binary_snacks=textscan(fid4,'%s %f %f %s %s %f %f %s %f %f','HeaderLines',1);
    
    fid1=fclose(fid1);
    fid3=fclose(fid3);
    
    
    ranks_faces_Colley_original = Colley_faces{2};
    ranks_faces_Colley_TiesRemoved = Colley_faces{3};
    ranks_faces_Colley_TiesDuplicated = Colley_faces{4};
    
    
    num_of_ties_faces=sum(Colley_faces{11})/2;
    
    %     choices is a matrix containing all choices.
    %     subject chose the right side item (1-yes, 0-no, 999-tie). next cols are the
    %     differences of right minus left) items ranking based on: 2 - Original rankings, 3 - ties removed, 4 - ties duplicated
    choices_faces = zeros(length(Binary_faces{1}),10);
    choices_faces(:,1) = 1:length(Binary_faces{1});
    choices_faces(:,2:3) =[Binary_faces{6},Binary_faces{7}];
    choices_faces(cell2mat(Binary_faces{8})=='i',4)=1;
    choices_faces(cell2mat(Binary_faces{8})=='x',4)=999;
    choices_faces(:,5)=ranks_faces_Colley_original(Binary_faces{7})-ranks_faces_Colley_original(Binary_faces{6});
    choices_faces(:,6)=ranks_faces_Colley_TiesRemoved(Binary_faces{7})-ranks_faces_Colley_original(Binary_faces{6});
    choices_faces(:,7)=ranks_faces_Colley_TiesDuplicated(Binary_faces{7})-ranks_faces_Colley_original(Binary_faces{6});
    choices_faces(:,8) = ((choices_faces(:,4)==0)&(choices_faces(:,5)>0))+((choices_faces(:,4)==1)&(choices_faces(:,5)<0));
    choices_faces(:,9) = ((choices_faces(:,4)==0)&(choices_faces(:,6)>0))+((choices_faces(:,4)==1)&(choices_faces(:,6)<0));
    choices_faces(:,10) = ((choices_faces(:,4)==0)&(choices_faces(:,7)>0))+((choices_faces(:,4)==1)&(choices_faces(:,7)<0));
    
    choices_all_subjects_faces{subj}=choices_faces;
    
    transitivity_matrix(subj,2) = sum(choices_faces(:,8)); % number of intransiant face choices - by original Colley
    transitivity_matrix(subj,3) = sum(choices_faces(:,9)); % number of intransiant face choices - by ties-removed Colley
    transitivity_matrix(subj,4) = sum(choices_faces(:,10)); % number of intransiant face choices - by ties-duplicated Colley
    
    transitivity_matrix(subj,5) = num_of_ties_faces;
end

[~,p]=ttest(transitivity_matrix(:,3),transitivity_matrix(:,4));
means=mean(transitivity_matrix,1);

fprintf('\n<strong>Mean number of intransitive choices:\n</strong>');
fprintf('Original Colley Ranking: %.2f\n',means(2));
fprintf('Ties-Removed Colley Ranking: %.2f\n',means(3));
fprintf('Ties-Duplicated Colley Ranking: %.2f\n',means(4));
fprintf('\n<strong>Difference between the two solutions, T test p-value: %.3f</strong>\n',p);
fprintf('Mean number of ties: %.2f\n\n',means(5));

% end