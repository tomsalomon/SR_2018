% This script takes all the pictures (.bmp) from the folder in the first line,
% and creates a list of all the filenames with " before and after each
% name, and ', ' between names.
% The final list will be in the 'list' variable

finalSnacks = dir('D:\Rotem\Dropbox\Experiment_Israel\Snacks\Final_Stimuli\Snacks60\*.bmp');
allNames = cell(length(finalSnacks),1);
list = '[';
for ind = 1:length(allNames)
    allNames{ind} = finalSnacks(ind).name;
    if ind < length(allNames)
        list = [list '"' allNames{ind} '", '];
    else
        list = [list '"' allNames{ind} '"]'];
    end
end