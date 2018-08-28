clear all

okscan=[0 1 2];
test_comp=input('Are you scanning? 2 Toms_iMac, 1 MRI, 0 if testooom: ');
while isempty(test_comp) || sum(okscan==test_comp)~=1
    disp('ERROR: input must be 0,1 or 2. Please try again.');
    test_comp=input('Are you scanning? 2 Toms_iMac, 1 MRI, 0 if testooom: ');
end



if test_comp==0
    outpath='~/Documents/Boost/Output/';
elseif test_comp==2
    outpath='~/Dropbox/Documents/Trained_Inhibition/Boost/Output/';
end


subjects= [  148 149 150 151 152 153 154  156 157 158 159 160 161 162] %messed up probe until 148. 155 didn't understand instructions of probe
%[58    65    67    68    69    70    71    80    81    89    92    93    94    96    98   101   102   103   105   111   112   113   114]
%subjects=  [58 59 60 65 66 67 68 69 70 71 72 75 77 78 80 81 83 84 85 87 88 89 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114] ; % many zeros 61, many 1000 62 63. 79 - didn't stop. 82 is 40. 
%subjects=  [58 59 60 65 66 68 69 70 71 72 75 77 78 80 81 83 84 87 88 89 91 92 93 94 95 96 97 98 99 101] ; % many zeros 61, many 1000 62 63. 79 - didn't stop. 82 is 40. 

%exclude 74, 76 90 ?- negative SSRT %%%% subjects 58,59,60 - maybe bidIndex is not flipped
choices=zeros(length(subjects),8);
choicesRT=zeros(length(subjects),8);
choicesNot=zeros(length(subjects),8);
choicesNotRT=zeros(length(subjects),8);





all_runs_allcols=cell(1920,17);

all_runs_all_subs=[];

for subjInd=1:length(subjects)
      outpath='~/Dropbox/Documents/Trained_Inhibition/Boost/Output/';
    
    %  for runnum=1:12
    
   if subjects(subjInd)<100
   
   filename=strcat(outpath,sprintf('BM2_0%d_boostprobe_',subjects(subjInd)));
   
   else
   filename=strcat(outpath,sprintf('BM2_%d_boostprobe_',subjects(subjInd)));
   end
   
   logs=dir(strcat(filename,'*.txt'))
%     mats=dir(strcat(filename, '_probe','*.mat'))
%     mats_train=dir(strcat(filename, '_train','*.mat'))
   
    fid=fopen(strcat(outpath,logs(1).name));
   % load(strcat(outpath,mats_train(1).name));
    
    
%%     
    P1=textscan(fid, '%s%d%d%d%d%d%s%s%d%d%d%s%d%d%.2f%.2f%.2f' , 'HeaderLines', 1);     %read in probe output file into P ;
    
   
    
    all_runs_all_subs=[all_runs_all_subs ; P1];
     fclose(fid);
    
       
     
     % end
end
% 

for colnum=1:17
for i=1:size(all_runs_all_subs,1)
all_runs_allcols{colnum}=[all_runs_allcols{colnum} ; all_runs_all_subs{i,colnum}];
end   
end

% 
% 
% 
%     fid1=fopen(('55subs_subname.txt'), 'w');    
% % 
% for i=1:length(all_runs_cols)
%              %write out the full list with the bids and also which item will be a stop item
%     fprintf(fid1, '%s\t\n', all_runs_cols{i}); % write item names, the stop/go high/low oneSeveral and item indeex
% end
% fprintf(fid1, '\n');
% fclose(fid1);
% 
% 
%     
%    for i=1:size(all_runs_all_subs,1)
% all_runs_cols_2=[all_runs_cols_2 ; all_runs_all_subs{i,2}];
% end 
%        
%    

