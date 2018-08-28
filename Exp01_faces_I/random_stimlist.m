function [list1, list2] = random_stimlist(n,number_of_trials)

% this function recieve two inputs: number of stimulus - n, and number of desired trials - number_of_trials.
% The output are two number_of_trials sized vector list1,list2 in which [list1(i),list2(i)] are random pairs of unique comparisons
% every stimulus appears same amount of times.

% ================================
% IMPORTANT NOTE I: 
% Every stimulus will be presented exactly 2*number_of_trials/n times. 
% Therefore, number_of_trials must be a multiple of n/2. 
%  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% e.g if n=60, number_of_trials can be 30,60,90,120....
% ================================

% ================================
% IMPORTANT NOTE II: 
% this version of code failes regularly, and requires using it with a
% try-cath loop. e.g.:
%
% % a=1;
% % while a==1
% %     try
% %         [shuffle_stimlist1,shuffle_stimlist2]=random_stimlist(n,number_of_trials);
% %         a=0;
% %     catch
% %         a=1;   
% %     end  % end try/catch
% % end
% ================================

% for testing:
% n=60;
% number_of_trials=300; %------change here according to desired number of trials (number of unique comparisons)


present_per_stim=2*number_of_trials/n;

% craete two lists of all possible non-ovelapping comparisons
stimlist1=[];
stimlist2=[];
for t=1:n
    stimlist1(end+1:end+n-t)=t;
    stimlist2(end+1:end+n-t)=(t+1:n);
end

shuffle_stimlist1=[];
shuffle_stimlist2=[];
list1=[];
list2=[];

[shuffle_stimlist1,shuff_stimlist1_ind]=Shuffle(stimlist1);
shuffle_stimlist2=stimlist2(shuff_stimlist1_ind);

for t=1:number_of_trials
    list1(end+1)=shuffle_stimlist1(1);
    list2(end+1)=shuffle_stimlist2(1);
    
    shuffle_stimlist1(1)=[];
    shuffle_stimlist2(1)=[];
    
    for stimulus= [list1(end),list2(end)]
        selection_check=[];
        selection_check=(sum(list1==stimulus)+sum(list2==stimulus));
        if  selection_check==present_per_stim
            todelete=(shuffle_stimlist1==stimulus)+(shuffle_stimlist2==stimulus);
            shuffle_stimlist1(todelete==1)=[];
            shuffle_stimlist2(todelete==1)=[];
        end
    end
end

selection_check=[];
    for stimulus=1:n
        selection_check(end+1)=(sum(list1==stimulus)+sum(list2==stimulus));
    end
end


