function [subjectData] = joinProbe_firstBlock(outputPath,experimentName,subjectInd)
% function [subjectData] = joinProbe(outputPath,experimentName,subjectInd)
% This function joins the blocks*num_runs_per_block probe results files
% of the subject to one data cell array

filename = strcat(outputPath,sprintf('/%s_%d',experimentName,subjectInd));
logs = dir(strcat(filename, '_probe_block_01','*.txt')) ;
subjectData = zeros(68*length(logs),18);
for datafile = 1:length(logs)
    fid = fopen(strcat(outputPath,'/',logs(datafile).name));
    Data = textscan(fid, '%s%f%f%f%f%f%f%s%s%f%f%f%s%f%f%f%f%f' , 'HeaderLines', 1);     %read in probe output file into P ;
    
%     % Convert all string variables into numbers
    Data{1}(:) = {subjectInd}; % subject's code
%     for ind = 1:length(Data{1})
%         Data{8}{ind} = str2num(Data{8}{ind}(1:3)); % left stimulus
%         Data{9}{ind} = str2num(Data{9}{ind}(1:3)); % right stimulus
%     end
    Data{8}=zeros(size(Data{8})); % zero all the names of the snacks because we want the cell array to be a matrix, and we don't use the names of the snacks anyway
    Data{9}=zeros(size(Data{9})); % zero all the names of the snacks because we want the cell array to be a matrix, and we don't use the names of the snacks anyway
    Data{13}(strcmp(Data{13},'u'))={1}; % response: 1 for left
    Data{13}(strcmp(Data{13},'i'))={0}; % response: 0 for right
    Data{13}(strcmp(Data{13},'x'))={999}; % response: 999 for no response
    
    Data{1} = cell2mat(Data{1});
    Data{13} = cell2mat(Data{13});
    
    DataMat = cell2mat(Data); % convert Data to matrix (instead of cell array)
    
    fclose(fid);
    
    numComparisonsPerFile = length(Data{1});
    subjectData(1+numComparisonsPerFile*(datafile-1):numComparisonsPerFile*(datafile),1:18) = DataMat;
end % end for datafile = 1:length(logs)

end % end function
