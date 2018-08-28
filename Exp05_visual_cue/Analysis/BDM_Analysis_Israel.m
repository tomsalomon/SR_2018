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
    outpath='./../Output/';
elseif test_comp==2
    outpath='~/Dropbox/Documents/Trained_Inhibition/Boost_Israel/Output/';
end


subjects=  [101:117];
%exclude:


O1_count=1;
O2_count=1;

for subjInd=1:length(subjects)
      outpath='~/Dropbox/Documents/Trained_Inhibition/Boost_Israel/Output/';

    %  clear Ladder1 Ladder2 respInTime respTime  
  
    


    
   if subjects(subjInd)<100
   
   filename=strcat(outpath,sprintf('ISF_0%d_BDM1.txt',subjects(subjInd)));
   
   else
   filename=strcat(outpath,sprintf('ISF_%d_BDM1.txt',subjects(subjInd)));
   end



 

%file=dir([path '/' subjects(subjInd) '_BDM1*']);                       %determine BDM output file for subject subjid

fid=fopen(filename);     %if multiple BDM files, open the last one
C=textscan(fid, '%d%s%f%d' , 'HeaderLines', 1);     %red in BDM output file into C
fclose(fid);

figure (subjects(subjInd));
hist(C{3});
if subjInd==1
    totC=C{3};
else
totC=totC+C{3};
end
figure
hist(totC./length(subjects))


[names_sort1,names_sort_ind1]=sort(C{2}); %sorting by item name for later oneSeveral comparison
sorted_bids1=C{3}(names_sort_ind1); %sorting the bids based on the item name sort to later determine oneSeveral
present_ind_sort1=C{1}(names_sort_ind1) ;% this is the order by which items were presented in the BDM sorted according to name

M1(:,1)=sorted_bids1; %bids of items sorted alphabetically 
M1(:,2)=1:1:60; %index sort by bid so I can sort images later 


sortedM1=sortrows(M1,-1)   ;   %Sort descending indices by bid - sorts also the present_ind_sort (order of presentation index from BDM) and the item index to determine ChoclateNon

for i=1:60
    sortedlist1(i,1)=names_sort1(sortedM1(i,2)); %creates the name list based on the sorted list of bids
end



sortedM1_by_itemname=sortedM1(:,2);

end
% 
%    if subjects(subjInd)<100
%    
%    filename=strcat(outpath,sprintf('ISF_0%d_BDM2.txt',subjects(subjInd)));
%    
%    else
%    filename=strcat(outpath,sprintf('ISF_%d_BDM2.txt',subjects(subjInd)));
%    end
% 
% 
% 
%  
% 
% %file=dir([path '/' subjects(subjInd) '_BDM1*']);                       %determine BDM output file for subject subjid
% 
% fid=fopen(filename);     %if multiple BDM files, open the last one
% C=textscan(fid, '%d%s%f%d' , 'HeaderLines', 1);     %red in BDM output file into C
% fclose(fid);
% 
% [names_sort2,names_sort_ind2]=sort(C{2}) ;%sorting by item name for later oneSeveral comparison
% sorted_bids2=C{3}(names_sort_ind2); %sorting the bids based on the item name sort to later determine oneSeveral
% present_ind_sort2=C{1}(names_sort_ind2) ;% this is the order by which items were presented in the BDM sorted according to name
% 
% M2(:,2)=sorted_bids2; %bids of items sorted alphabetically 
% M2(:,1)=1:1:60; %index sort by bid so I can sort images later 
% 
% 
% sortedM2=sortrows(M2)     ; %Sort descending indices by bid - sorts also the present_ind_sort (order of presentation index from BDM) and the item index to determine ChoclateNon
% 
% for i=1:60
%     sortedlist2(i,1)=names_sort2(sortedM2(i,1)); %creates the name list based on the sorted list of bids
% end
% 
% 
% 
% 
% 
% if subjects(subjInd)<100
%         filename=strcat(outpath,sprintf('ISF_0%d',subjects(subjInd)));
%     else
%         filename=strcat(outpath,sprintf('ISF_%d',subjects(subjInd)));
%     end
% 
% 
% 
%     logs=dir(strcat(filename, '_boostprobe','*.txt'));
%     mats=dir(strcat(filename, '_boostprobe','*.mat'));
%     mats_train=dir(strcat(filename, '_boosting','*.mat'));
%     
%     %    fid=fopen(strcat(outpath,logs(1).name));
%     load(strcat(outpath,mats_train(1).name));
% %  order_several(subjInd,1)=Several_side;
% %     order_several(subjInd,2)=order;
% %    
% %     
% %     BDM_1_one(subjInd,1)=mean(sortedM(find(sortedM(:,3)==1),1));
% %     BDM_1_sev(subjInd,1)=mean(sortedM(find(sortedM(:,3)==0),1));
% % 
% 
% switch order
%     
%     case 1
% BDM_1_Ex_O1(O1_count,1)=mean(sortedM1([8 11 12 15    ],1)); %stop High ?
% BDM_1_Ex_O1(O1_count,2)=mean(sortedM1([9 10 13 14   ],1)); % go High
% BDM_1_Ex_O1(O1_count,3)=mean(sortedM1([  46 49 50 53] ,1)); % stop Low
% BDM_1_Ex_O1(O1_count,4)=mean(sortedM1([   47 48 51 52],1)); % go Low
% BDM_1_Ex_O1(O1_count,5)=subjects(subjInd); % go Low
% BDM_1_Ex_O1(O1_count,6)=order; % go Low
% 
% names1{O1_count}=sortedlist1([8 11 12 15    ]);
% 
% BDM_2_Ex_O1(O1_count,1)=mean(sortedM2(sortedM1([8 11 12 15],2),2)); %stop High ?
% BDM_2_Ex_O1(O1_count,2)=mean(sortedM2(sortedM1([9 10 13 14],2),2)); % go High
% BDM_2_Ex_O1(O1_count,3)=mean(sortedM2(sortedM1([46 49 50 53],2),2)); % stop Low
% BDM_2_Ex_O1(O1_count,4)=mean(sortedM2(sortedM1([47 48 51 52],2),2)); % go Low
% BDM_2_Ex_O1(O1_count,5)=subjects(subjInd); % go Low
% BDM_2_Ex_O1(O1_count,6)=order; % go Low
% 
% names2{O1_count}=sortedlist2(sortedM2(sortedM1([8 11 12 15],2)));
% 
% O1_count=O1_count+1;
% 
% 
% 
% % 
% % BDM_2_Ex_O1(O1_count,1)=mean(sortedM([9 10 13 14     ],1)); %stop High ?
% % BDM_2_Ex_O1(O1_count,2)=mean(sortedM([ 8 11 12 15    ],1)); % go High
% % BDM_2_Ex_O1(O1_count,3)=mean(sortedM([  46 48 50 52] ,1)); % stop Low
% % BDM_2_Ex_O1(O1_count,4)=mean(sortedM([  46 49 50 53],1)); % go Low
% % O1_count=O1_count+1;
% %         
% 
% % 
% % %         
% % %         
% % %         BDM_2_HH_S_O1(subjInd,1)=mean(sortedM([8 10 12 14     ],1)); %stop High ?
% % % BDM_2_HH_G_O1(subjInd,2)=mean(sortedM([ 9 11 13 15   ],1)); % go High
% % % BDM_2_LL_S_O1(subjInd,3)=mean(sortedM([  46 48 50 52] ,1)); % stop Low
% % % BDM_2_LL_G_O1(subjInd,4)=mean(sortedM([   47 49 51 53],1)); % go Low
% % 
% % BDM_1(subjInd,1)=mean(sortedM(find(sortedM(:,3)==0),1)); %stop High ?
% % % BDM_1(subjInd,2)=mean(sortedM([1:7  9 11 13 15    17 19 21 23 24:30],1)); % go High
% % % BDM_1(subjInd,3)=mean(sortedM([38 40 42 44   46 48 50 52] ,1)); % stop Low
% % % BDM_1(subjInd,4)=mean(sortedM([31:37  39 41 43 45   47 49 51 53 54:60],1)); % go Low
% % % % 
% % 
%     case 2
% %  
% BDM_1_Ex_O2(O2_count,1)=mean(sortedM1([9 10 13 14    ],1)); %stop High ?
% BDM_1_Ex_O2(O2_count,2)=mean(sortedM1([  8 11 12 15  ],1)); % go High
% BDM_1_Ex_O2(O2_count,3)=mean(sortedM1([   47 48 51 52 ]  ,1)); % stop Low
% BDM_1_Ex_O2(O2_count,4)=mean(sortedM1([    46 49 50 53  ],1)); % go Low
% BDM_1_Ex_O2(O2_count,5)=subjects(subjInd); % go Low
% BDM_1_Ex_O2(O2_count,6)=order; % go Low
% 
% 
% BDM_2_Ex_O2(O2_count,1)=mean(sortedM2(sortedM1([9 10 13 14 ],2),2)); %stop High ?
% BDM_2_Ex_O2(O2_count,2)=mean(sortedM2(sortedM1([8 11 12 15],2),2)); % go High
% BDM_2_Ex_O2(O2_count,3)=mean(sortedM2(sortedM1([47 48 51 52 ],2),2)); % stop Low
% BDM_2_Ex_O2(O2_count,4)=mean(sortedM2(sortedM1([46 49 50 53],2),2)); % go Low
% BDM_2_Ex_O2(O2_count,5)=subjects(subjInd); % go Low
% BDM_2_Ex_O2(O2_count,6)=order; % go Low
% 
%        O2_count=O2_count+1; 
%        
% %        
% %        
% % BDM_2_Ex_O2(O2_count,1)=mean(sortedM([9 11 13 15     ],1)); %stop High ?
% % BDM_2_Ex_O2(O2_count,2)=mean(sortedM([  8 10 12 14 ],1)); % go High
% % BDM_2_Ex_O2(O2_count,3)=mean(sortedM([    47 49 51 53 ]  ,1)); % stop Low
% % BDM_2_Ex_O2(O2_count,4)=mean(sortedM([    46 48 50 52  ],1)); % go Low
% % 
% %        O2_count=O2_count+1; 
% % % % %         
% % %  BDM_2_HH_S_O2(subjInd,1)=mean(sortedM([9 11 13 15     ],1)); %stop High ?
% % % BDM_2_HH_G_O2(subjInd,2)=mean(sortedM([  8 10 12 14 ],1)); % go High
% % % BDM_2_LL_S_O2(subjInd,3)=mean(sortedM([    47 49 51 53 ]  ,1)); % stop Low
% % % BDM_2_LL_G_O2(subjInd,4)=mean(sortedM([    46 48 50 52  ],1)); % go Low
% % 
% % BDM_1(subjInd,1)=mean(sortedM([9 11 13 15     17 19 21 23 ],1)); %stop High ?
% % BDM_1(subjInd,2)=mean(sortedM([1:7  8 10 12 14     16 18 20 22  24:30],1)); % go High
% % BDM_1(subjInd,3)=mean(sortedM([39 41 43 45    47 49 51 53 ]  ,1)); % stop Low
% % BDM_1(subjInd,4)=mean(sortedM([31:37  38 40 42 44    46 48 50 52  54:60],1)); % go Low
% % 
% % 
% % 
%  end
%        
%     
% end
% BDM1_all=[BDM_1_Ex_O1 BDM_2_Ex_O1; BDM_1_Ex_O2 BDM_2_Ex_O2 ];
% 
% 
% [h,p]=ttest(BDM1_all(:,1)-BDM1_all(:,2),BDM1_all(:,7)-BDM1_all(:,8));
% [h,p]=ttest(BDM1_all(:,3)-BDM1_all(:,4),BDM1_all(:,9)-BDM1_all(:,10));
% 
% % 
% % one_several_bids_BDM2(subjInd,1)=mean(M(find(M(:,3)==1),1)); % bids for 1
% % one_several_bids_BDM2(subjInd,2)=mean(M(find(M(:,3)==0),1)); % bids for several 
% % 
% end