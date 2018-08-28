function [outputTrainingFiles,RTfromFiles,respInTimeFromFiles] = checkingTrainingOutput()

% ==================== Rotem Botvinik - December 2014 ====================
% function [outputTrainingFiles,RTfromFiles,respInTimeFromFiles] = checkingTrainingOutput()
% This function checks the output of the training session, by reading all
% training files (that are copied into the
% 'D:\Rotem\Matlab\Boost_old_preIsrael\Cheking_Training_Output_ChooseEyes'
% folder and putting the RTs in a new RT array and the respInTime in a new
% respInTime array. Then, the function scans the RTs for values that are negative.
% If it finds a negative value, it prints the number of file and number of
% RT in which there is a problem.
% It also scans the file for pre-defined mismatches, such as RT<1000 and
% respIntTime>1000

outputPath = 'D:\Rotem\Matlab\Boost_old_preIsrael\Cheking_Training_Output_ChooseEyes';
outputTrainingFiles = dir([outputPath '\*training*.txt']);
RTfromFiles = cell(length(outputTrainingFiles),1);
respInTimeFromFiles = cell(length(outputTrainingFiles),1);

% for fileInd = 306:306
for fileInd = 1:length(outputTrainingFiles)
    fid = fopen([outputPath '\' outputTrainingFiles(fileInd).name]);
    [dataFromFile] = textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s','Delimiter',' ');    RTfromFiles{fileInd} = dataFromFile{7};
    RTfromThisFile = dataFromFile{7}(2:end);
    RT = zeros(length(RTfromThisFile),1);
%     for ind = 7
    for ind = 1:length(RTfromThisFile)
        RT(ind) = str2num(RTfromThisFile{ind});
    end % end for ind = 1:length(RTfromFile)
    RTfromFiles{fileInd} = RT;
    
    respInTimeFromThisFile = dataFromFile{8}(2:end);
    respInTime = zeros(length(respInTimeFromThisFile),1);
    for ind = 1:length(respInTimeFromThisFile)
        respInTime(ind) = str2num(respInTimeFromThisFile{ind});
    end % end for ind = 1:length(RTfromFile)    
    respInTimeFromFiles{fileInd} = respInTime;
    
    fclose(fid);
end % end for fileInd = 1:length(outputTrainingFiles)

filename = ['checkingTrainingOutput_' date '.mat'];
save(filename, 'outputTrainingFiles','RTfromFiles','respInTimeFromFiles');

minusMat = RTfromFiles;
mismatchMat = RTfromFiles;
for i = 1:length(RTfromFiles)
    for j = 1:length(RTfromFiles{i})
        minusMat{i}(j) = 0;
        mismatchMat{i}(j) = 0;
        RT = RTfromFiles{i}(j);
        respInTime = respInTimeFromFiles{i}(j);
        if RT ~= 999000
            if RT<0
                minusMat{i}(j) = 1;
                fprintf(['Minus RT in file' num2str(i) ', RT' num2str(j) '\n'])
                fprintf(['RT = ' num2str(RT) '\n'])
                fprintf([outputTrainingFiles(i).name '\n'])
            end
            if respInTime > 1000 && RT < 1000
                mismatchMat{i}(j) = 1;
                fprintf(['resp>1000 and RT<1000 in file' num2str(i) ', RT' num2str(j) '\n'])
                fprintf(['RT = ' num2str(RT) '; resp = ' num2str(respInTime) '\n'])
                fprintf([outputTrainingFiles(i).name '\n'])
            end
            if respInTime < 1000 && RT > 1000
                mismatchMat{i}(j) = 2;
                fprintf(['resp<1000 and RT>1000 in file' num2str(i) ', RT' num2str(j) '\n'])
                fprintf(['RT = ' num2str(RT) '; resp = ' num2str(respInTime) '\n'])
                fprintf([outputTrainingFiles(i).name '\n'])
            end
        end
    end % end if RT ~= 999000
end

end % end function

