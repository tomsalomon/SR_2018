outputPath = 'D:\Rotem\Dropbox\Experiment_Israel\Codes\Boost_Israel\Output\';
logs = dir([outputPath 'ISF_1*_BDM1.txt']);
numTies = zeros(length(logs),1);
bids = zeros(60,length(logs));

for fileInd = 1:length(logs)
    fid = fopen([outputPath logs(fileInd).name]);
    data = textscan(fid,'%d %s %f %f','HeaderLines',1);
    fclose(fid);
    bids(:,fileInd) = data{3};
    numTies(fileInd) = length(bids(:,fileInd))-length(unique(bids(:,fileInd))); 
end


outputPath2 = 'D:\Rotem\Dropbox\Experiment_Israel\Codes\BMI_bs_40\Output\';
logs = dir([outputPath2 'BMI_bs_40*BDM1.txt']);
numTiesIsrael = zeros(length(logs),1);
bidsIsrael = zeros(60,length(logs));
for fileInd = 1:length(logs)
    fid = fopen([outputPath2 logs(fileInd).name]);
    data = textscan(fid,'%d %s %f %f','HeaderLines',1);
    fclose(fid);
    bidsIsrael(:,fileInd) = data{3};
    numTiesIsrael(fileInd) = length(bidsIsrael(:,fileInd))-length(unique(bidsIsrael(:,fileInd)));
end


outputPath3 = 'D:\Rotem\Dropbox\Experiment_Israel\Codes\Boost_Israel_New_Rotem_mac\Output\';
logs = dir([outputPath3 'BMI_bs*BDM1.txt']);
numTiesIsraelOld = zeros(length(logs),1);
bidsIsraelOld = zeros(60,length(logs));
for fileInd = 1:length(logs)
    fid = fopen([outputPath3 logs(fileInd).name]);
    data = textscan(fid,'%d %s %f %f','HeaderLines',1);
    fclose(fid);
    bidsIsraelOld(:,fileInd) = data{3};
    numTiesIsraelOld(fileInd) = length(bidsIsraelOld(:,fileInd))-length(unique(bidsIsraelOld(:,fileInd)));
end


averageTiesNum = mean(numTies)
averageTiesIsraelNum = mean(numTiesIsrael)
averageTiesIsraelOldNum = mean(numTiesIsraelOld)