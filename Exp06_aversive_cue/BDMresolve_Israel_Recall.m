function BDMresolve_Israel(subjectID, sessionNum, outputPath)

% function probeResolve_Israel(subjectID, sessionNum, outputPath)

% This function chooses a random item from the BDM and compute the amount of money that the participant bid on that item (y).
% Then, a random number x from (0:0.5:10) is chosen for the computer's bid.
% If x is lower than y for that item, the
% participant have to buy this item for x NIS.
% If not, the participant cannot buy the item.

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % % --------- Exterior files needed for task to run correctly: ----------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%   ''BDM1.txt'' --> created in the BDM session


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % % ------------------- Creates the following files: --------------------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%   ''BDM_resolve_session_' num2str(sessionNum) '.txt''


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % ------------------- dummy info for testing purposes -------------------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% subjectID = 'test999';
% sessionNum = 1;
% outputPath =
% '/Users/schonberglabimac1/Documents/Boost_Israel_New_Rotem_mac'; % On the
% experiment's mac

%%% -- by Rani for Recall -- 
subjectID = input('Subject code: ','s');
while isempty(subjectID)
    disp('ERROR: no value entered. Please try again.');
    subjectID = input('Subject code:','s');
end

sessionNum=2;
mainPath = pwd; % Change if you don't run from the experimnet folder - not recomended.
outputPath = [mainPath '/Output'];
%%% -------------------------

% Open data from BDM
tmp = dir([outputPath '/' subjectID '_BDM2.txt']);
fid = fopen([outputPath '/' tmp(length(tmp)).name]); %tmp(length(tmp)).name
BDMdata = textscan(fid, '%d %s %f %f', 'Headerlines',1);
fclose(fid);

total_num_items = length(BDMdata{1});

% Choose a random item
randomOrder = Shuffle(1:total_num_items);
item_ind = randomOrder(1);
item_chosen = BDMdata{2}{item_ind};
item_bid = BDMdata{3}(item_ind);


% Compute a random number
possibleNumbers = Shuffle(0.5:0.5:10);
chosenNumber = possibleNumbers(1);

fid2 = fopen([outputPath '/' subjectID '_BDM_resolve_session_' num2str(sessionNum) '.txt'],'a');

% save results

if chosenNumber <= item_bid
    % The subject buys the item for chosenNumber NIS
    fprintf(fid2, 'You may buy item %s for price %d, your bid was %d\n', item_chosen, chosenNumber, item_bid);
else % the subject cannot buy the item
    fprintf(fid2, 'You do not recieve item %s. Random number %d is higher than your bid %d\n', item_chosen, chosenNumber, item_bid);   
end % end if chosenNumber <= item_bid

fclose(fid2);
    
end % end function    