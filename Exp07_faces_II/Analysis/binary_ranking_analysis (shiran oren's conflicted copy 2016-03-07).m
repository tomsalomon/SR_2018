
clear all;

% Define analysis and output paths
analysis_path=pwd;
outpath='./../Output/';

% These are all the subjects' ranking results files
ranking_files=dir([outpath '*ItemRankingRes*']);

rankings=zeros(length(ranking_files),60); % Rankings of the 60 stimuli, each column identify a particular stimulus
stdevs=zeros(length(ranking_files),1); % Standard deviations of the final ranking table of each sunject. Small STD
% may indicate low preferences for different stimuli (i.e. the subject did not like certain stimuli more then others)
SubID=cell(length(ranking_files),1);
ReactionTime=zeros(length(ranking_files),1);
TransitiveChoices=cell(length(ranking_files),1);
ColleyViolations=cell(length(ranking_files),1);
NumberOfTransitiveChoices=zeros(length(ranking_files),1);
NumberOfColleyViolations=zeros(length(ranking_files),1);
ViolationSize=cell(length(ranking_files),1);
SumOfViolationSize=zeros(length(ranking_files),1);

% Go through each sunbject's file and extract the data
for i=1:length(ranking_files)
    fid=fopen([outpath,ranking_files(i).name]);
    data=textscan(fid,'%s %s %f %f %f %f %f','Headerlines',1);
    SubID{i}=data{1}(1);
    
    % contains a table with the data sorted by the stimuli's names: 1)SubjectID	2)StimName	3)StimNum	4)Rank	5)Wins	6)Loses  7)Total
    rankings(i,:)=data{4}'; % Stimuli's rankings, sorted alphabetically (e.g - first number is the '001.TIFF' ranking; second number is the '002.TIFF' ranking, etc.)
    fid=fclose(fid);
    stdevs(i)=std(data{4});
end

% plot rankings for all stimuli
mean_rankings=mean(rankings);
[~,~,rnk] = unique(mean_rankings);

%% make a bootstrap distribution
rng('Shuffle');
boots_size=100000;
bootstrap=zeros(boots_size,1);
for i=1:boots_size
 [num_of_ranks,~]=size(rankings(:));
 boots_sample=zeros(length(rankings(:,1)));
 for j=1:length(length(rankings(:,1)))
 boots_sample(j)=randi(num_of_ranks,[length(rankings(:,1)),1]);
 end
 bootstrap(i)=mean(rankings(boots_sample));
end
bootstrap=sort(bootstrap);
boots_low=bootstrap(boots_size*0.0001);
boots_high=bootstrap(boots_size*(1-0.0001));
%%

% Gender preferences - all subjects
male_rankings=mean(rankings(:,1:30),2);
female_rankings=mean(rankings(:,31:60),2);
[~,p]=ttest(male_rankings,female_rankings);
fprintf('\n<strong>ALL SUBJECTS RESULTS</strong>\n');
fprintf('Mean rank of male stimuli was: %.2f \n',mean(male_rankings));
fprintf('Mean rank of female stimuli was: %.2f \n',mean(female_rankings));
fprintf('Difference t-test sig. of %.4f \n',p);

figure
hold on
title(['All subjects (n=',num2str(length(rankings(:,1))),')'])
ylabel('Mean Colley ranking')
xlabel('sorted ranking')
bar(rnk(1:30),mean_rankings(1:30),'b')
bar(rnk(31:60),mean_rankings(31:60),'m')
errorbar(rnk(1:30),mean_rankings(1:30),std(rankings(:,1:30)),'b.')
errorbar(rnk(31:60),mean_rankings(31:60),std(rankings(:,31:60)),'m.')
plot(1:60,ones(60,1)*boots_low,'r')
plot(1:60,ones(60,1)*boots_high,'g')
hold off

% get personal details
personal_details_files=dir([outpath '*personalDetails*']);
gender=zeros(length(personal_details_files),1);
for i=1:length(personal_details_files)
    fid=fopen([outpath,personal_details_files(i).name]);
    personal_details=textscan(fid,'%s %f %s %f %f %f %s','Headerlines',1);
    
    % subjects gender: 1-female, 2-male
    gender(i)=personal_details{4}(1);
end

fprintf('\nNumber of female subject: %.0f',sum(gender==1));
fprintf('\nNumber of male subject: %.0f\n',sum(gender==2));

% male and female subjects seperately
% female subjects
mean_rankings=mean(rankings(gender==1,:));
[~,~,rnk] = unique(mean_rankings);

male_rankings=mean(rankings(gender==1,1:30),2);
female_rankings=mean(rankings(gender==1,31:60),2);
[~,p]=ttest(male_rankings,female_rankings);
fprintf('\n<strong>FEMALE SUBJECTS RESULTS</strong>\n');
fprintf('Mean rank of male stimuli was: %.2f \n',mean(male_rankings));
fprintf('Mean rank of female stimuli was: %.2f \n',mean(female_rankings));
fprintf('Difference t-test sig. of %.4f \n',p);

figure
subplot(1,2,1)
hold on
title(['Female subjects (n=',num2str(sum(gender==1)),')'])
ylabel('Mean Colley ranking')
xlabel('sorted ranking')
bar(rnk(1:30),mean_rankings(1:30),'b')
bar(rnk(31:60),mean_rankings(31:60),'m')
errorbar(rnk(1:30),mean_rankings(1:30),std(rankings(gender==1,1:30)),'b.')
errorbar(rnk(31:60),mean_rankings(31:60),std(rankings(gender==1,31:60)),'m.')
hold off

% male subjects
mean_rankings=mean(rankings(gender==2,:));
[~,~,rnk] = unique(mean_rankings);

male_rankings=mean(rankings(gender==2,1:30),2);
female_rankings=mean(rankings(gender==2,31:60),2);
[~,p]=ttest(male_rankings,female_rankings);
fprintf('\n<strong>MALE SUBJECTS RESULTS</strong>\n');
fprintf('Mean rank of male stimuli was: %.2f \n',mean(male_rankings));
fprintf('Mean rank of female stimuli was: %.2f \n',mean(female_rankings));
fprintf('Difference t-test sig. of %.4f \n',p);

subplot(1,2,2)
hold on
title(['Male subjects (n=',num2str(sum(gender==2)),')'])
ylabel('Mean Colley ranking')
xlabel('sorted ranking')
bar(rnk(1:30),mean_rankings(1:30),'b')
bar(rnk(31:60),mean_rankings(31:60),'m')
errorbar(rnk(1:30),mean_rankings(1:30),std(rankings(gender==2,1:30)),'b.')
errorbar(rnk(31:60),mean_rankings(31:60),std(rankings(gender==2,31:60)),'m.')
hold off




StimRank=data{4};
StimNames=data{2};
% convert StimNames from string to double
for i=1:length(StimNames)
    StimNames{i}=StimNames{i}(1:end-4);
end
StimNames=str2double(StimNames);

choices_files=dir([outpath '*_binary_ranking_*.txt']);
no_choices=zeros(length(choices_files),1);
for i=1:length(choices_files)
    fid=fopen([outpath,choices_files(i).name]);
    data=textscan(fid,'%s %f %f %s %s %f %f %s %f %f','Headerlines',1);
    no_choices(i)=sum(cell2mat(data{8})=='x');
    RT=data{1,10};
    RT(RT==999000)=[];
    ReactionTime(i)=mean(RT);
    fid=fclose(fid);
    
    SubjectChoice=cell2mat(data{8});
    SubjectChoseLeft=SubjectChoice=='u';
    SubjectChoseRight=SubjectChoice=='i';
    ImageLeft=data{4};
    ImageRight=data{5};
    
    for j=1:length(ImageLeft)
        ImageLeft{j}=ImageLeft{j}(1:end-4);
        ImageRight{j}=ImageRight{j}(1:end-4);
    end
    
    ImageLeft=str2double(ImageLeft);
    ImageRight=str2double(ImageRight);
    
    RankLeft=zeros(length(ImageLeft),1);
    RankRight=zeros(length(ImageLeft),1);
    
    for stimNum=1:length(StimNames)
        RankLeft(ImageLeft==StimNames(stimNum))=StimRank(stimNum);
        RankRight(ImageRight==StimNames(stimNum))=StimRank(stimNum);
    end
    
    TransitiveChoices{i}=((RankLeft>RankRight)&SubjectChoseLeft)|((RankLeft<RankRight)&SubjectChoseRight);
    ColleyViolations{i}=((RankLeft<RankRight)&SubjectChoseLeft)|((RankLeft>RankRight)&SubjectChoseRight);
    NumberOfTransitiveChoices(i)=sum(TransitiveChoices{i});
    NumberOfColleyViolations(i)=sum(ColleyViolations{i});
    ViolationSize{i}=ColleyViolations{i}.*abs(RankLeft-RankRight);
    SumOfViolationSize(i)=sum(ViolationSize{i});
end

% Print results: standard deviation of Colley Rankings
outliers=stdevs>(mean(stdevs)+3*std(stdevs))|stdevs<(mean(stdevs)-3*std(stdevs));
fprintf('\nA total of %d outliers were found using Colley rankings standard deviation:\n',sum(outliers));
fprintf('3 std confidence interval is: %.4f - %.4f\n',(mean(stdevs)-3*std(stdevs)),(mean(stdevs)+3*std(stdevs)));

findOutliers=find(outliers);
for i=1:length(findOutliers)
fprintf('%s had a Colley rankings standard deviation of %.4f\n',cell2mat(SubID{findOutliers(i)}),stdevs(findOutliers(i)));
end


% Print results: standard deviation of Colley Rankings
outliers=NumberOfColleyViolations>(mean(NumberOfColleyViolations)+3*std(NumberOfColleyViolations))|NumberOfColleyViolations<(mean(NumberOfColleyViolations)-3*std(NumberOfColleyViolations));
fprintf('\nA total of %d outliers were found using Colley violations count:\n',sum(outliers));
fprintf('3 std confidence interval is: %.4f - %.4f\n',(mean(NumberOfColleyViolations)-3*std(NumberOfColleyViolations)),(mean(NumberOfColleyViolations)+3*std(NumberOfColleyViolations)));

findOutliers=find(outliers);
for i=1:length(findOutliers)
fprintf('%s had a sum of %d Colley violations\n',cell2mat(SubID{findOutliers(i)}),NumberOfColleyViolations(findOutliers(i)));
end


% Print results: standard deviation of Colley Rankings
outliers=SumOfViolationSize>(mean(SumOfViolationSize)+3*std(SumOfViolationSize))|SumOfViolationSize<(mean(SumOfViolationSize)-3*std(SumOfViolationSize));
fprintf('\nA total of %d outliers were found using sum of violations sizes:\n',sum(outliers));
fprintf('3 std confidence interval is: %.4f - %.4f\n',(mean(SumOfViolationSize)-3*std(SumOfViolationSize)),(mean(SumOfViolationSize)+3*std(SumOfViolationSize)));

findOutliers=find(outliers);
for i=1:length(findOutliers)
fprintf('%s had a sum of %.4f violations sizes\n',cell2mat(SubID{findOutliers(i)}),SumOfViolationSize(findOutliers(i)));
end
