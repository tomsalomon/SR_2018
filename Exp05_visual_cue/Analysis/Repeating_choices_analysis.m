% ~~~~~~~~~~~~~~~~~~~~~  Repeating Choices Analysis  ~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~  Tom Salomon, December 2015  ~~~~~~~~~~~~~~~~~~~~~

% This script compares choices done in different probe session (original 
% vs. recall) and checks the similarity in patterns.

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

clear all
 rng('Shuffle');
subjects=[101:103,105:107,109:111,113,116:120,122:123,125]; % Define here your subjects' codes.
%exclude:
%118 - had poor ranking ditribution - consider removal?
%121 - did not look at the faces

analysis_path=pwd; % Analysis folder location
outpath_original=['./../Output/']; % Output folder location
outpath_recall=['./../Output/recall/']; % Output folder location
all_subjs_data_original{length(subjects)}={};
all_subjs_data_recall{length(subjects)}={};
all_subjs_data{length(subjects)}={};

Repeating_choices_results=zeros(length(subjects),18);
Repeating_choices_results(:,1)=subjects;

for subjInd=1:length(subjects)
    disp(subjInd);
    
    data_original=Probe_recode(subjects(subjInd),outpath_original);
    data_recall=Probe_recode(subjects(subjInd),outpath_recall);
    data=[data_original;data_recall];
    % The Probe_recode function will join all present output file for each subject into a single matrix, these are the matrix columns:
    % 1-subjectID       2-scanner	 3-order        4-block         5-run       6-trial	 7-onsettime    8-ImageLeft	 9-ImageRight	10-bidIndexLeft
    % 11-bidIndexRight	12-IsleftGo	 13-Response    14-PairType     15-Outcome  16-RT	 17-bidLeft     18-bidRight
    
    all_subjs_data_original{subjInd}=data_original; %All subjects' data
    all_subjs_data_recall{subjInd}=data_recall; %All subjects' data
    all_subjs_data{subjInd}=data;
    order=data_original(1,3);
    if order==1 %define which stimuli were Go items: [High    Low]
        GoStim=[7 10 12 13 15 18   44 45 47 50 52 53];
    elseif order==2
        GoStim=[8  9 11 14 16 17   43 46 48 49 51 54];
    end
    
    % this is a unique index for each comparison. first two numbers
    % indicate the lower rank item, and the latter two numbers indicate the
    % higher ranked item. e.g. in the comparison 3 vs 10, the index will
    % be 1003: 10-vs-03
    % then organize comparisons in a matrix with number of columns as the
    % number of block.
    choices_index=max(data(:,10),data(:,11))*100+min(data(:,10),data(:,11));
    choices_options=unique(choices_index);
    choices_matrix=zeros(length(choices_options),3+max(data(:,4))-min(data(:,4)));
    choices_matrix(:,1)=unique(choices_index);
    
    % add PairType to the matrix as the 2nd column
    choices_matrix(choices_matrix(:,1)<=1900,2)=1; %HV
    choices_matrix(choices_matrix(:,1)>1900 & choices_matrix(:,1)<=5500,2)=2; %LV
    choices_matrix(choices_matrix(:,1)>5500,2)=4; %Sanity NoGO
    
    % next columns are the outcomes for each comparison
   for block=min(data(:,4)):max(data(:,4))
       for j=1:length(choices_options)
           choices_matrix(j,2+block)=data(choices_index==choices_options(j)&data(:,4)==block,15);
       end
   end
   
   choices_matrix(choices_matrix==999)=0;
   session_I=choices_matrix(:,3)+choices_matrix(:,4);
   session_II=choices_matrix(:,5)+choices_matrix(:,6);

   sessions_differences=choices_matrix(:,3)+choices_matrix(:,4)-choices_matrix(:,5)-choices_matrix(:,6);
   sum_sessions_differences=sum(session_I-session_II);
      sum_abs_sessions_differences=sum(abs(session_I-session_II));

   % permutation test for the differences
   sum_rand_sessions_differences=zeros(10000,1);
   sum_abs_rand_sessions_differences=zeros(10000,1);

   for i=1:10000
      rand_sessions_differences=Shuffle(session_I)-session_II;
      sum_rand_sessions_differences(i)=sum(rand_sessions_differences);
      sum_abs_rand_sessions_differences(i)=sum(abs(rand_sessions_differences));
   end
   
   PairType=data(:,14);
   Outcome=data(:,15);
   Rank_left=data(:,10);
   Rank_right=data(:,11);
   
   % Organize data in a summary table
   Repeating_choices_results(subjInd,2)=order;
       
   Repeating_choices_results(subjInd,3)= sum(choices_matrix(:,2)==1 & choices_matrix(:,3)==1 & choices_matrix(:,4)==1); % first probe, HV - #chose Go in both trials
   Repeating_choices_results(subjInd,4)= sum(choices_matrix(:,2)==2 & choices_matrix(:,3)==1 & choices_matrix(:,4)==1); % first probe, LV - #chose Go in both trials
   Repeating_choices_results(subjInd,5)= sum(choices_matrix(:,2)==1 & choices_matrix(:,5)==1 & choices_matrix(:,6)==1); % recall, HV - #chose Go in both trials
   Repeating_choices_results(subjInd,6)= sum(choices_matrix(:,2)==2 & choices_matrix(:,5)==1 & choices_matrix(:,6)==1); % recall, LV - #chose Go in both trials
   
   Repeating_choices_results(subjInd,7)= 0.5*Repeating_choices_results(subjInd,3)/sum(choices_matrix(:,2)==1); % first probe, HV - %chose Go in both trials
   Repeating_choices_results(subjInd,8)= 0.5*Repeating_choices_results(subjInd,4)/sum(choices_matrix(:,2)==2); % first probe, LV - %chose Go in both trials
   Repeating_choices_results(subjInd,9)= 0.5*Repeating_choices_results(subjInd,5)/sum(choices_matrix(:,2)==1); % recall, HV - %chose Go in both trials
   Repeating_choices_results(subjInd,10)= 0.5*Repeating_choices_results(subjInd,6)/sum(choices_matrix(:,2)==2); % recall, LV - %chose Go in both trials
   
   Repeating_choices_results(subjInd,11)= sum(choices_matrix(:,2)==1 & choices_matrix(:,3)==1 & choices_matrix(:,4)==1 & choices_matrix(:,5)==1 & choices_matrix(:,6)==1); % HV - #chose Go in both session
   Repeating_choices_results(subjInd,12)= sum(choices_matrix(:,2)==2 & choices_matrix(:,3)==1 & choices_matrix(:,4)==1 & choices_matrix(:,5)==1 & choices_matrix(:,6)==1); % LV - #chose Go in both session

   Repeating_choices_results(subjInd,13)= Repeating_choices_results(subjInd,11)/Repeating_choices_results(subjInd,5); % HV - %Go in both session / Go in recall
   Repeating_choices_results(subjInd,14)= Repeating_choices_results(subjInd,12)/Repeating_choices_results(subjInd,6); % LV - %Go in both session / Go in recall

      Repeating_choices_results(subjInd,15)= sum_sessions_differences; % sum of differences between sessions
      Repeating_choices_results(subjInd,16)= sum_abs_sessions_differences; % sum of abs differences between sessions
      Repeating_choices_results(subjInd,17)= sum(sum_rand_sessions_differences<sum_sessions_differences)/length(sum_rand_sessions_differences); % p-val sum of differences between sessions
      Repeating_choices_results(subjInd,18)= sum(sum_abs_rand_sessions_differences<sum_abs_sessions_differences)/length(sum_abs_rand_sessions_differences); % p-val sum of absolute differences between sessions

end 

Repeating_choices_results_table = cell(1+size(Repeating_choices_results,1),size(Repeating_choices_results,2));
Titles = {'Subject', 'Order', ...
    '#HighValue-probe-Go twice', '#LowValue-probe-Go twice', '#HighValue-recall-Go twice', '#LowValue-recall-Go twice',...
    '%HighValue-probe-Go twice', '%LowValue-probe-Go twice', '%HighValue-recall-Go twice', '%LowValue-recall-Go twice',...
    '#HighValue double Go in both sessions', '#LowValue double Go in both sessions',...
    '%HighValue of Go coices in recall where subject chose Go in probe', '%LowValue of Go coices in recall where subject chose Go in probe'...
    'sum of differences between sessions', 'sum of absolute differences between sessions', 'p-val of differences between sessions', 'p-val of absolute differences between sessions'};
Repeating_choices_results_table(1,:) = Titles;
Repeating_choices_results_table(2:end,:) = num2cell(Repeating_choices_results);

% % Just a reminder - this is the stimulus assignment:
% %
% %              | Sanity HV |     Go/NoGo      | Sanity LV | 
% if order == 1
%     bid_sortedM([           7 10 12 13 15 18               ], 4) = 11; % HV_beep
%     bid_sortedM([ 3:6       8  9 11 14 16 17      19:22    ], 4) = 12; % HV_nobeep
%     bid_sortedM([           44 45 47 50 52 53              ], 4) = 22; % LV_beep
%     bid_sortedM([ 39:42     43 46 48 49 51 54     55:58    ], 4) = 24; % LV_nobeep
%     bid_sortedM([ 1:2            23:38            59:60    ], 4) = 0; % notTrained
% else
%     bid_sortedM([           8  9 11 14 16 17               ], 4) = 11; % HV_beep
%     bid_sortedM([ 3:6       7 10 12 13 15 18      19:22    ], 4) = 12; % HV_nobeep
%     bid_sortedM([           43 46 48 49 51 54              ], 4) = 22; % LV_beep
%     bid_sortedM([ 39:42     44 45 47 50 52 53     55:58    ], 4) = 24; % LV_nobeep
%     bid_sortedM([ 1:2            23:38            59:60    ], 4) = 0; % notTrained
% end % end if order == 1
