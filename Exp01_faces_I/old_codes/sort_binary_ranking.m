function [] = sort_binary_ranking(subjectID,order,outputPath)
% function [] = sort_BDM_Israel(subjectID,order,outputPath)
% Created based on the previous boost codes, by Rotem Botvinik November 2014
% Sorts the stimuli according to the BDM results
%
%   FILES REQUIRED TO RUN PROPERLY
% - - - - - - - - - - - - - - -  
%   mainPath'/Output/' subjectID '_BDM1.txt'


%   CREATES THE FOLLOWING FILES
% - - - - - - - - - - - - - - -  
%   'stopGoList_allstim.txt'
%   'stopGoList_trainingstim.txt'
%   'order_testcomp.txt'


% %---dummy info for testing purposes --------
% subjectID='BM_9001';
% order=1;
% outputPath='D:/Rotem/Matlab/Boost_Israel_New_Rotem/Output'; % On Rotem's PC 


%=========================================================================
%%  read in info from BDM1.txt
%=========================================================================
% outputPath='E:\Tom\Dropbox\Experiment_Israel\Codes\Boost_Israel_New_Tom\Output'; %Output path for testing purpose


subj_rank_file=dir(fullfile(outputPath,[subjectID,'_faces_ItemRankingResults*']));
fid=fopen(fullfile(outputPath,subj_rank_file.name));
BDM1_data=textscan(fid, '%s %s %s %s %s %s %s'); %read in data as new matrix   
fclose(fid);


%=========================================================================
%%  Create matrix sorted by descending bid value
%========================================================================

[bids_sort,trialnum_sort_bybid]=sort(str2num(cell2mat(BDM1_data{4}(2:end))),'descend');
% [bids_sort,trialnum_sort_bybid]=sort(BDM1_data{3},'descend');

bid_sortedM(:,1)=trialnum_sort_bybid; %trialnums organized by descending bid amt
bid_sortedM(:,2)=bids_sort; %bids sorted large to small
bid_sortedM(:,3)=1:1:60; %stimrank

stimnames_sorted_by_bid=BDM1_data{2}(trialnum_sort_bybid+1);


%=========================================================================
%%   The ranking of the stimuli determine the stimtype
%=========================================================================

if order == 1

    bid_sortedM([          7 10 12 13 15 18 20 21   24 25         ], 4) = 11; %HV_beep
    bid_sortedM([ 1:6      8  9 11 14 16 17 19 22   23 26   27:30 ], 4) = 12; %HV_nobeep
    bid_sortedM([         39 42 44 45 47 50 52 53   36 37         ], 4) = 22; %LV_beep
    bid_sortedM([ 31:34   40 41 43 46 48 49 51 54   35 38   55:60 ], 4) = 24; %LV_nobeep

    else

    bid_sortedM([          8  9 11 14 16 17 19 22   23 26         ], 4) = 11; %HV_beep
    bid_sortedM([ 1:6      7 10 12 13 15 18 20 21   24 25   27:30 ], 4) = 12; %HV_nobeep
    bid_sortedM([         40 41 43 46 48 49 51 54   35 38         ], 4) = 22; %LV_beep
    bid_sortedM([ 31:34   39 42 44 45 47 50 52 53   36 37   55:60 ], 4) = 24; %LV_nobeep

end % end if order == 1


%=========================================================================
%%  create stopGoList_allstim.txt
%   this file is used during probe
%=========================================================================

fid2=fopen([outputPath '\' subjectID sprintf('_stopGoList_allstim_order%d.txt', order)], 'w');    

for i=1:length(bid_sortedM)
    fprintf(fid2, '%s\t%d\t%d\t%d\t%d\t\n', stimnames_sorted_by_bid{i,1},bid_sortedM(i,4),bid_sortedM(i,3),bid_sortedM(i,2),bid_sortedM(i,1)); 
end
fprintf(fid2, '\n');
fclose(fid2);



end % end function

