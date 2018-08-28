function [outputProbeFiles,RTfromFiles] = checkingProbeOutput()

% ==================== Rotem Botvinik - December 2014 ====================
% function [outputProbeFiles,RTfromFiles] = checkingProbeOutput()
% This function checks the output of the probe session, by reading all
% probe files (that are copied into the
% 'D:\Rotem\Matlab\Boost_old_preIsrael\Cheking_Probe_Output_ChooseEyes'
% folder and putting the RTs in a new RT array.
% Then, the function scans the RTs for values that are negative.
% If it finds a negative value, it prints the number of file and number of
% RT in which there is a problem.

outputPath = 'D:\Rotem\Matlab\Boost_old_preIsrael\Cheking_Probe_Output_ChooseEyes';
outputProbeFiles = dir([outputPath '\*Probe*.txt']);
RTfromFiles = cell(length(outputProbeFiles),1);

% for fileInd = 306:306
for fileInd = 1:length(outputProbeFiles)
    fid = fopen([outputPath '\' outputProbeFiles(fileInd).name]);
    [dataFromFile] = textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s','Delimiter',' ');
    RTfromThisFile = dataFromFile{15}(2:end);
    RT = zeros(length(RTfromThisFile),1);
    
    for ind = 1:length(RTfromThisFile)
        RT(ind) = str2num(RTfromThisFile{ind});
    end % end for ind = 1:length(RTfromFile)
    RTfromFiles{fileInd} = RT;
    
    fclose(fid);
end % end for fileInd = 1:length(outputProbeFiles)

filename = ['checkingProbeOutput_' date '.mat'];
save(filename, 'outputProbeFiles','RTfromFiles');

minusMat = RTfromFiles;
for i = 1:length(RTfromFiles)
    for j = 1:length(RTfromFiles{i})
        minusMat{i}(j) = 0;
        RT = RTfromFiles{i}(j);
        if RT<0
            minusMat{i}(j) = 1;
            fprintf(['Minus RT in file' num2str(i) ', RT' num2str(j) '\n'])
            fprintf(['RT = ' num2str(RT) '\n'])
            fprintf([outputProbeFiles(i).name '\n'])
        end
        
    end
end

end % end function

