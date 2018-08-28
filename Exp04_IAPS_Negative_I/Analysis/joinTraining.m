function subjectTrainingData = joinTraining(mainPath, experimentName, subjectID)
% function subjectTrainingData = joinTraining(mainPath, experimentName, subjectID)
% this function joins all the files of the subject (one txt file for eacch training run) to one training data
% matrix

analysisOutputPath = [mainPath '/Output'];

filename = strcat(analysisOutputPath,sprintf('/%s%d',experimentName,subjectID));
logs = dir(strcat(filename, '_*training*run','*.txt')) ; % save to logs all the relevant files
fid = fopen(strcat(analysisOutputPath,'/',logs(1).name)); % open the first file
Data = textscan(fid, '%s\t %d\t %d\t %s\t %d\t %d\t %d\t %d\t %d\t %d\t %d\t %.2f\t %.2f\t %.2f\t %d\t %.2f\t \n' , 'HeaderLines', 1); % read the first file into Data to calculate size of data
fclose(fid);
subjectTrainingData = zeros(length(logs)*length(Data{1}),size(Data,2));

for datafile = 1:length(logs)
    fid = fopen(strcat(analysisOutputPath,'/',logs(datafile).name));
    Data = textscan(fid, '%s\t %d\t %d\t %s\t %d\t %d\t %d\t %d\t %d\t %d\t %d\t %.2f\t %.2f\t %.2f\t %d\t %.2f\t \n' , 'HeaderLines', 1);     %read in probe output file into Data ;
    fclose(fid);
    %     % Convert all string variables into numbers
    Data{1}(:) = {subjectID}; % subject's code
    Data{4} = zeros(size(Data{4})); % zero all the names of the snacks because we want the cell array to be a matrix, and we don't use the names of the snacks anyway
    Data{1} = cell2mat(Data{1});
    
    % the following loop is neccesary only if not al cells are in the same
    % class
    for column = [2:3 5:11 15]
        Data{column} = double(Data{column});
    end
    
    DataMat = cell2mat(Data); % convert Data to matrix (instead of cell array)
    
    numTrialsPerFile = length(Data{1});
    subjectTrainingData(1+numTrialsPerFile*(datafile-1):numTrialsPerFile*(datafile),:) = DataMat;
end % end for datafile = 1:length(logs)

end % end function