
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
exp_name={'Boost_IAPS_Negative_I';'Boost_IAPS_Negative_II';'Boost_IAPS_Positive_I';'Boost_IAPS_Positive_II';'Boost_aversive_cue';'Boost_faces_new';'Boost_fractals_I';'Boost_fractals_II';'Boost_visual_cue'};
num_of_exp=length(exp_name);
current_dir=pwd;

for exp_num=1:length(exp_name)
        exp_fast_dm_dir=[current_dir,'/../../',exp_name{exp_num},'/analysis/fast_dm'];

    if isempty(strfind(current_dir,exp_name{exp_num}))
%         delete(['./../../',exp_name{exp_num},'/Analysis/fast_dm/splitted_exp_outcome_v_free.txt'])
%         delete(['./../../',exp_name{exp_num},'/Analysis/fast_dm/splitted_exp_outcome_zr_free.txt'])
        copyfile([current_dir,'/fast_dm/experiment.ctl'],[exp_fast_dm_dir,'/experiment.ctl']);
    end
    cd(exp_fast_dm_dir)
system('fast-dm.exe');
end
cd(current_dir);