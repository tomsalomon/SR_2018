function BDM_Analysis_Israel_New(mainPath, experimentName, Subjects)
% function BDM_analysis_Israel_New(mainPath, experimentName, Subjects)
%
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
% =============== Created based on the previous boost codes ===============
% ===================== by Rotem Botvinik April 2015 ======================
% = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

% This function analyzes the BDM, to see if any subject should be excluded
% from the experiment deu to lack of variance or passion for snacks, according to the BDM.

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % % --------- Exterior files needed for task to run correctly: ----------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%   BDM files of the subjects


if nargin < 3
    Subjects = [101:102]; % write here only the subjects that should be analyzed (were not excluded)
    % 102- excluded due to extremely low rankings in the BDM
    % 108- excluded due to extremely low ladders (up to 0).
    % 114:115- excluded due to being vegan
    % 116- excluded due to extremely weird behavior
    
end

if nargin < 2
 experimentName = 'BMI_bs';
end

if nargin < 1
    mainPath = 'D:\Rotem\Dropbox\Experiment_Israel\Codes\Boost_Israel_New_Rotem_mac';
end

outputPath = [mainPath '/Output'];

% Files = dir([outputPath '/' experimentName '*_BDM1.txt']);

totalBid = 0;

for subjectIndex = 1:length(Subjects) 
    File = dir([outputPath '/' experimentName '_' num2str(Subjects(subjectIndex)) '_BDM1.txt']);
    fid = fopen([outputPath '/' File.name]);
    BDM1_data = textscan(fid, '%d%s%f%d' , 'HeaderLines', 1); %read in data as new matrix   
    fclose(fid);

    figure(Subjects(subjectIndex));
    BDM1_data{3} = BDM1_data{3};
    hist(BDM1_data{3},20);
    title(['BDM: Subject # ' num2str(Subjects(subjectIndex))]);
    xlabel('Bid');
    ylabel('Frequency');
    
    if subjectIndex == 1
        totalBid = BDM1_data{3};
    else
        totalBid = totalBid + BDM1_data{3};
    end

end % end for subjectIndex

% plot the total hist (of all subjects)
figure
hist(totalBid./length(subjectIndex))
title('Average of all subjects');
xlabel('Bid');
ylabel('Frequency');

end % end function