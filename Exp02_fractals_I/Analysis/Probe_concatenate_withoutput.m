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
choices=zeros(length(subjects),8);
choicesRT=zeros(length(subjects),8);
choicesNot=zeros(length(subjects),8);
choicesNotRT=zeros(length(subjects),8);





all_runs_allcols=cell(1792,17);

all_runs_all_subs=[];

for subjInd=1:length(subjects)
     
    
     % for run_number=1:12 % be careful because runnum was saved.
        outpath='~/Dropbox/Documents/Trained_Inhibition/Boost/Output/';    
    
   if subjects(subjInd)<100
   
   filename=strcat(outpath,sprintf('BM2_0%d_boostprobe_',subjects(subjInd)));
   
   else
   filename=strcat(outpath,sprintf('BM2_%d_boostprobe_',subjects(subjInd)));
   end
   
   logs=dir(strcat(filename,'*.txt'));
%     mats=dir(strcat(filename, '_probe','*.mat'))
%     mats_train=dir(strcat(filename, '_train','*.mat'))
   
    fid=fopen(strcat(outpath,logs(1).name));
    
    
    
%%     
    P1=textscan(fid, '%s%d%d%d%d%d%s%s%d%d%d%s%d%d%.2f%.2f%.2f' , 'HeaderLines', 1);     %read in probe output file into P ;
    
   fclose(fid);
    
    all_runs_all_subs=[all_runs_all_subs; P1];
     
  %    end
end
% 

for colnum=1:17
for i=1:size(all_runs_all_subs,1)
all_runs_allcols{colnum}=[all_runs_allcols{colnum} ; all_runs_all_subs{i,colnum}];
end   
end

% 
% 

    fid1=fopen(('14subsboost_subname_all.txt'), 'w');    
    fprintf(fid1,'subjid\tscanner\torder\tblock\truntrial\tonsettime\tImageLeft\tImageRight\tTypeLeft\tTypeRight\tIsLefthigh\tResponse\tPairType\tOutcome\tRT\tbidIndexLeft\tbidIndexRight\n'); %write the header line
   
for i=1:length(all_runs_allcols)    
    %write out the full list with the bids and also which item will be a stop item
                   
    fprintf(fid1, '%s\t%d\t%d\t%d\t%d\t%d\t%s\t%s\t%d\t%d\t%d\t%s\t%d\t%d\t%.2f\t%.2f\t%.2f\t\n', all_runs_allcols{1}{i}, all_runs_allcols{2}(i), all_runs_allcols{3}(i), all_runs_allcols{4}(i), all_runs_allcols{5}(i), all_runs_allcols{6}(i), all_runs_allcols{7}{i}, all_runs_allcols{8}{i}, all_runs_allcols{9}(i), all_runs_allcols{10}(i), all_runs_allcols{11}(i), all_runs_allcols{12}{i}, all_runs_allcols{13}(i),all_runs_allcols{14}(i),all_runs_allcols{15}(i), all_runs_allcols{16}(i),all_runs_allcols{17}(i)); % write item names, the stop/go high/low oneSeveral and item indeex
end
fprintf(fid1, '\n');
fclose(fid1);

% 
%     fid1=fopen(('55subs_subname.txt'), 'w');    
% % 
% for i=1:length(all_runs_allcols)
%     for colum=1:13     
%     %write out the full list with the bids and also which item will be a stop item
%     fprintf(fid1, '%s\t%d\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t '%s\t\n', all_runs_cols{1}(i), all_runs_cols{1}(i), all_runs_cols{1}(i), all_runs_cols{1}(i), all_runs_cols{1}(i), all_runs_cols{1}(i), all_runs_cols{1}(i), all_runs_cols{1}(i), all_runs_cols{1}(i), all_runs_cols{1}(i)); % write item names, the stop/go high/low oneSeveral and item indeex
% end
% fprintf(fid1, '\n');
% fclose(fid1);



% 
%     
%    for i=1:size(all_runs_all_subs,1)
% all_runs_cols_2=[all_runs_cols_2 ; all_runs_all_subs{i,2}];
% end 
%        
%    

