
% ~~~ Script for analyzing probe results, modified for face experiment ~~~
% ~~~~~~~~~~~~~~~ Tom Salomon, February 2015  ~~~~~~~~~~~~~~
%
% In order to run the script, you must locate and run the script from within
% "Analysis" folder. The script uses external function, called
% "Probe_recode" which join all probe output file into one matrix. Please
% make sure that function is also present in the analysis folder.
%
% Note: this script and "Probe_recode" function were written specifically
% for face stimuli in a specific numeric name format. For other stimuli, you need
% to modify the Probe_recode function first.
%
% Enjoy!

clear;
close all;

% set the names of the samples to include, as appearing in their dir name
exp_name={'Boost_IAPS_Negative_I';'Boost_IAPS_Negative_II';'Boost_IAPS_Positive_I';'Boost_IAPS_Positive_II';'Boost_aversive_cue';'Boost_faces_new';'Boost_familiar_faces';'Boost_fractals_I';'Boost_fractals_II';'Boost_visual_cue'};
current_dir=pwd;

for exp_num=1:length(exp_name)
    cd(['./../../',exp_name{exp_num},'/Analysis']);
    load('subjects');
    
    for subjInd=1:length(subjects)
        
        data=Probe_recode(subjects(subjInd));
        % The Probe_recode function will join all present output file for each subject into a single matrix, these are the matrix columns:
        % 1-subjectID       2-scanner	 3-order        4-block         5-run       6-trial	 7-onsettime    8-ImageLeft	 9-ImageRight	10-bidIndexLeft
        % 11-bidIndexRight	12-IsleftGo	 13-Response    14-PairType     15-Outcome  16-RT	 17-bidLeft     18-bidRight
        
        % split data into probe and fast dm trials
        split_fast_dm_trials=repmat([true;false],[ceil(length(data)/2),1]);
        % remove excess length
        if length(split_fast_dm_trials)>length(data)
            split_fast_dm_trials(end)=[];
        end
        split_probe_trials= ~split_fast_dm_trials;
        fast_dm_data_lines=(subjInd-1)*sum(split_fast_dm_trials)+1:(subjInd)*sum(split_fast_dm_trials);
        
        sub=data(1,1);
        
        % 1-subID, 2-trial num (all runs combined), 3-pair type, 4-is left go, 5-subject chose Go, 6-RT in ms
        fast_dm=data(split_fast_dm_trials,[1,6,14,12,15,16]);
        fast_dm(:,6)=fast_dm(:,6)/1000; % RT in seconds
        fast_dm(fast_dm(:,5)==999|fast_dm(:,3)>2|fast_dm(:,6)<0.2,:)=[]; % remove missed trials, sanity, and RT below 200 ms
        dlmwrite(['./fast_dm/splitted_fast_dm_',num2str(sub),'.dat'],fast_dm,' ')
        
        probe_data=data(split_probe_trials,:);
        dlmwrite(['./fast_dm/splitted_probe_',num2str(sub),'.txt'],probe_data,'\t')
        
    end
end
cd(current_dir);