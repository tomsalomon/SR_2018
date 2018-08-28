%function analyze_BDMs(subjid,order,test_comp)
%subjid=input('Enter subjid from BDM: ' ,'s');
%%%order=input('Enter order 1 or 2 ');



%%%% still needs to :
% Sort the BDM by item name.
%Then add the one_several list.

%Then calculate the average BDM for one and for several.

%Then calculate the average BDM for HV items with SS and without - put in 1 column.
%Then calculate the average BDM for LV items with SS and without -  put in 1 column.
%Compare to BDM2.



clear all ;


okscan=[0 1 2];
test_comp=input('Are you scanning? 2 Toms_iMac, 1 MRI, 0 if testooom: ');
while isempty(test_comp) || sum(okscan==test_comp)~=1
    disp('ERROR: input must be 0,1 or 2. Please try again.');
    test_comp=input('Are you scanning? 2 Toms_iMac, 1 MRI, 0 if testooom: ');
end



if test_comp==0
    outpath='~/Documents/Boost_Short/Output/';
elseif test_comp==2
    outpath='~/Dropbox/Documents/Trained_Inhibition/Boost_Short/Output/';
end



subjects=  [  333 334 335 336 337 338 339 340 341 342 343 344  346 347 348 349 400 401 402 403 404 405  407];



memory_sums_go=zeros(size(subjects,2),4);
memory_sums_nogo=zeros(size(subjects,2),4);


O1_count=1;
O2_count=1;

for subjInd=1:length(subjects)
      outpath='~/Dropbox/Documents/Trained_Inhibition/Boost_Short/Output/';

      clear C D 
  


%path='~/Documents/TI_Code/Output';   %path to output
%path='/Users/tomtom/Dropbox/Documents/Trained_Inhibition/TI_Code/Output'; 
file=dir([outpath '/BM2_' num2str(subjects(subjInd)) '_BDM1*']);                       %determine BDM output file for subject subjid

fid=fopen([outpath '/' sprintf(file(length(file)).name)]);     %if multiple BDM files, open the last one
C=textscan(fid, '%d%s%f%d' , 'HeaderLines', 1);     %red in BDM output file into C
fclose(fid);

[names_sort,names_sort_ind]=sort(C{2}) %sorting by item name for later oneSeveral comparison
sorted_bids=C{3}(names_sort_ind) %sorting the bids based on the item name sort to later determine oneSeveral
present_ind_sort=C{1}(names_sort_ind) % this is the order by which items were presented in the BDM sorted according to name

M(:,1)=sorted_bids; %bids of items sorted alphabetically 
M(:,2)=1:1:60; %index sort by bid so I can sort images later 
%M(:,3)=oneSeveral; % order of items sorted by name to determine nonSeveral


sortedM=sortrows(M,-1)      %Sort descending indices by bid - sorts also the present_ind_sort (order of presentation index from BDM) and the item index to determine ChoclateNon

for i=1:60
    sortedlist(i,1)=names_sort(sortedM(i,2)); %creates the name list based on the sorted list of bids
end

  


file=dir([outpath '/BM2_' num2str(subjects(subjInd)) '_beepnobeep*']);                       %determine BDM output file for subject subjid

fid=fopen([outpath '/' sprintf(file(length(file)).name)]);     %if multiple BDM files, open the last one
D=textscan(fid, '%s%d%d%s%d%f%d' , 'HeaderLines', 1);     %red in BDM output file into C
fclose(fid);
  

for pic_ind=1:size(D{1},1)
TF=strcmp(D{4}(pic_ind),sortedlist)

beepno_subs{subjInd}(pic_ind,1)=find(TF);
beepno_subs{subjInd}(pic_ind,2)=D{5}(pic_ind);
beepno_subs{subjInd}(pic_ind,3)=D{7}(pic_ind);


switch beepno_subs{subjInd}(pic_ind,3)
    
    
case 1
    
    if sum(beepno_subs{subjInd}(pic_ind,1)==[8 11 12 15]) & beepno_subs{subjInd}(pic_ind,2)<999
memory_sums_go(subjInd,1)=memory_sums_go(subjInd,1)+beepno_subs{subjInd}(pic_ind,2);
   
    elseif sum(beepno_subs{subjInd}(pic_ind,1)==[46 49 50 53]) & beepno_subs{subjInd}(pic_ind,2)<999
 memory_sums_go(subjInd,2)=memory_sums_go(subjInd,2)+beepno_subs{subjInd}(pic_ind,2);
       
  elseif sum(beepno_subs{subjInd}(pic_ind,1)==[16 19 20 23]) & beepno_subs{subjInd}(pic_ind,2)<999
 memory_sums_go(subjInd,3)=memory_sums_go(subjInd,3)+beepno_subs{subjInd}(pic_ind,2);
        
       elseif sum(beepno_subs{subjInd}(pic_ind,1)==[17 18 21 22]) & beepno_subs{subjInd}(pic_ind,2)<999
 memory_sums_go(subjInd,4)=memory_sums_go(subjInd,4)+beepno_subs{subjInd}(pic_ind,2);
   
    end
    
    
       if sum(beepno_subs{subjInd}(pic_ind,1)==[9 10 13 14 ]) & beepno_subs{subjInd}(pic_ind,2)<999 & beepno_subs{subjInd}(pic_ind,2)==0
memory_sums_nogo(subjInd,1)=memory_sums_nogo(subjInd,1)+1;
   
    elseif sum(beepno_subs{subjInd}(pic_ind,1)==[47 48 51 52]) & beepno_subs{subjInd}(pic_ind,2)<999 & beepno_subs{subjInd}(pic_ind,2)==0
 memory_sums_nogo(subjInd,2)=memory_sums_nogo(subjInd,2)+1;
       
  elseif sum(beepno_subs{subjInd}(pic_ind,1)==[17 18 21 22]) & beepno_subs{subjInd}(pic_ind,2)<999 & beepno_subs{subjInd}(pic_ind,2)==0
 memory_sums_nogo(subjInd,3)=memory_sums_nogo(subjInd,3)+1;
        
       elseif sum(beepno_subs{subjInd}(pic_ind,1)==[16 19 20 23]) & beepno_subs{subjInd}(pic_ind,2)<999 & beepno_subs{subjInd}(pic_ind,2)==0
 memory_sums_nogo(subjInd,4)=memory_sums_nogo(subjInd,4)+1;
   
    end
    
    
    
 case 2   
    
    
        if sum(beepno_subs{subjInd}(pic_ind,1)==[9 10 13 14 ]) & beepno_subs{subjInd}(pic_ind,2)<999 & beepno_subs{subjInd}(pic_ind,2)==0
memory_sums_go(subjInd,1)=memory_sums_go(subjInd,1)+1;
   
    elseif sum(beepno_subs{subjInd}(pic_ind,1)==[47 48 51 52]) & beepno_subs{subjInd}(pic_ind,2)<999 & beepno_subs{subjInd}(pic_ind,2)==0
 memory_sums_go(subjInd,2)=memory_sums_go(subjInd,2)+1;
       
  elseif sum(beepno_subs{subjInd}(pic_ind,1)==[17 18 21 22]) & beepno_subs{subjInd}(pic_ind,2)<999 & beepno_subs{subjInd}(pic_ind,2)==0
 memory_sums_go(subjInd,3)=memory_sums_go(subjInd,3)+1;
        
       elseif sum(beepno_subs{subjInd}(pic_ind,1)==[16 19 20 23]) & beepno_subs{subjInd}(pic_ind,2)<999 & beepno_subs{subjInd}(pic_ind,2)==0
 memory_sums_go(subjInd,4)=memory_sums_go(subjInd,4)+1;
   
        end
        
            if sum(beepno_subs{subjInd}(pic_ind,1)==[8 11 12 15]) & beepno_subs{subjInd}(pic_ind,2)<999 
memory_sums_nogo(subjInd,1)=memory_sums_nogo(subjInd,1)+beepno_subs{subjInd}(pic_ind,2);
   
    elseif sum(beepno_subs{subjInd}(pic_ind,1)==[46 49 50 53]) & beepno_subs{subjInd}(pic_ind,2)<999 
 memory_sums_nogo(subjInd,2)=memory_sums_nogo(subjInd,2)+beepno_subs{subjInd}(pic_ind,2);
       
  elseif sum(beepno_subs{subjInd}(pic_ind,1)==[16 19 20 23]) & beepno_subs{subjInd}(pic_ind,2)<999 
 memory_sums_nogo(subjInd,3)=memory_sums_nogo(subjInd,3)+beepno_subs{subjInd}(pic_ind,2);
        
       elseif sum(beepno_subs{subjInd}(pic_ind,1)==[17 18 21 22]) & beepno_subs{subjInd}(pic_ind,2)<999 
 memory_sums_nogo(subjInd,4)=memory_sums_nogo(subjInd,4)+beepno_subs{subjInd}(pic_ind,2);
   
    end

 end
 end
       
    
end
