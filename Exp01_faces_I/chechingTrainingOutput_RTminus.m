
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